package main

import (
 "crypto/hmac"
 "crypto/rand"
 "encoding/base64"
 "io"
 "strconv"
 "crypto/sha256"
 "crypto/subtle"
 "encoding/json"
 "fmt"
 "log"
 "net"
 "net/http"
 "net/http/httputil"
 "net/url"
 "os"
 "strings"
 "sync"
 "time"
)

type credentials struct { Username string `json:"username"`; Password string `json:"password"` }

const sessionName = "SZ50_ADMIN_SESSION"
const sessionDuration = 8 * time.Hour
// Shared across ports; a process restart（或修改密码）invalidates previous sessions.
var (
 sessionKeyMu sync.RWMutex
 sessionKey = newSessionKey()
)
func newSessionKey() []byte {
 key := make([]byte, 32)
 // 优先读 /dev/urandom：这类设备冷启动时内核熵池尚未初始化，
 // crypto/rand 走 getrandom(2) 会被阻塞 60 秒（实测日志 "crypto/rand: blocked for 60 seconds"），
 // 那样网关启动后一分钟内完全不监听端口，后台表现为"打不开 + 连接被重置"。
 if f, err := os.Open("/dev/urandom"); err == nil {
  _, err = io.ReadFull(f, key)
  f.Close()
  if err == nil {
   return key
  }
 }
 if _, err := rand.Read(key); err != nil {
  panic("Cannot initialize session key")
 }
 return key
}
// rotateSessionKey 重新生成会话密钥：已签发的会话立即失效（改密码后调用）
func rotateSessionKey() {
 key := newSessionKey()
 sessionKeyMu.Lock(); sessionKey = key; sessionKeyMu.Unlock()
}
func sessionKeyBytes() []byte {
 sessionKeyMu.RLock(); defer sessionKeyMu.RUnlock(); return sessionKey
}
func sessionToken(expires time.Time) string {
 stamp:=strconv.FormatInt(expires.Unix(),10)
 mac:=hmac.New(sha256.New,sessionKeyBytes())
 mac.Write([]byte(stamp))
 return stamp+"."+base64.RawURLEncoding.EncodeToString(mac.Sum(nil))
}
func validSession(r *http.Request) bool {
 cookie,err:=r.Cookie(sessionName);if err!=nil{return false}
 parts:=strings.Split(cookie.Value,".");if len(parts)!=2{return false}
 seconds,err:=strconv.ParseInt(parts[0],10,64);if err!=nil{return false}
 expires:=time.Unix(seconds,0)
 remaining:=time.Until(expires)
 if remaining<=0 || remaining>sessionDuration+time.Minute{return false}
 return hmac.Equal([]byte(cookie.Value),[]byte(sessionToken(expires)))
}

func authHandler(c credentials, upstream, api string) http.Handler {
 applyCred(c) // 装入认证哈希（幂等；生产环境 main 也会调一次）
 target, err := url.Parse(upstream); if err != nil { panic(err) }
 proxy := httputil.NewSingleHostReverseProxy(target)
 director := proxy.Director
 proxy.Director = func(r *http.Request) {
  director(r)
  if api != "" && (r.URL.Path == "/api" || strings.HasPrefix(r.URL.Path, "/api/")) { r.URL.Host = api }
  r.Header.Del("Authorization")
  r.Header.Del("Proxy-Authorization")
  r.Header.Del("Forwarded")
  r.Header.Del("X-Forwarded-For")
  r.Header.Del("X-Forwarded-Host")
  r.Header.Del("X-Forwarded-Proto")
 }
 proxy.Transport = &http.Transport{Proxy:nil, DialContext:(&net.Dialer{Timeout:5*time.Second}).DialContext, ResponseHeaderTimeout:30*time.Second, IdleConnTimeout:30*time.Second, MaxIdleConns:16}
 proxy.ModifyResponse = func(r *http.Response) error { r.Header.Set("Cache-Control", "no-store"); return nil }
 proxy.ErrorHandler = func(w http.ResponseWriter, r *http.Request, e error) { http.Error(w,"Backend unavailable",http.StatusBadGateway) }
 slots := make(chan struct{}, 48)
 return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
  w.Header().Set("Cache-Control", "no-store")
  select { case slots <- struct{}{}: defer func(){<-slots}(); default: http.Error(w,"Busy",503); return }
  // 自建登录页（含浏览器自动请求的 favicon 与全站背景脚本）在认证之前处理 —— 它本身不需要认证
  if r.URL.Path==loginPath {loginHandler(w,r);return}
  if r.URL.Path==logoutPath {logoutHandler(w,r);return}
  if r.URL.Path=="/favicon.ico" {w.WriteHeader(http.StatusNoContent);return}
  if r.URL.Path=="/air-bg.js" {proxy.ServeHTTP(w,r);return}
  u,p,ok := r.BasicAuth()
  // 主动退出过的浏览器：不再接受它缓存里的 Basic 凭据，否则会被静默重新登录
  if _,cerr:=r.Cookie(noBasicCookieName);cerr==nil {ok=false}
  gotU, gotP := sha256.Sum256([]byte(u)),sha256.Sum256([]byte(p))
  wantU, wantP := credHashes()
  match := subtle.ConstantTimeCompare(wantU[:],gotU[:]) & subtle.ConstantTimeCompare(wantP[:],gotP[:])
  hasSession:=validSession(r)
  if !hasSession && (!ok || match != 1) {
   // 浏览器导航/iframe：跳到自建登录页，输错时页面上能给提示（原生弹框做不到）
   if wantsHTML(r) { http.Redirect(w,r,loginPath+"?next="+url.QueryEscape(r.URL.RequestURI()),http.StatusFound); return }
   time.Sleep(150*time.Millisecond)
   // 浏览器在页面里发起的请求（轮询 / fetch / 子资源）**不下发 Basic 挑战**：
   // 否则会话一失效，浏览器立刻弹出它自己的认证框，还会拿存着的旧凭据反复重试。
   // 实测——在系统设置页点退出后，残留页面的轮询（/api/get/network 等）每个都 401+挑战，
   // 浏览器就一直弹「系统窗口」。判据用 Sec-Fetch-*（浏览器必发、curl/脚本不发），
   // 因此 API 与命令行客户端的 401 + Basic 语义完全不受影响。
   if r.Header.Get("Sec-Fetch-Site")=="" && r.Header.Get("Sec-Fetch-Mode")=="" && r.Header.Get("Sec-Fetch-Dest")=="" {
    w.Header().Set("WWW-Authenticate",`Basic realm="SZ50 Admin"`)
   }
   http.Error(w,"Login required",401)
   return
  }
  host,err := url.Parse("http://"+r.Host)
  if err != nil || host.Hostname() == "" || r.Header.Get("Sec-Fetch-Site") == "cross-site" { http.Error(w,"Forbidden",403); return }
  for _,key := range []string{"Origin","Referer"} {
   if value:=r.Header.Get(key); value!="" { origin,e:=url.Parse(value); if e!=nil || !strings.EqualFold(origin.Hostname(),host.Hostname()) { http.Error(w,"Forbidden",403); return } }
  }
  if r.Method == "CONNECT" || r.URL.IsAbs() || strings.HasPrefix(r.URL.Path,"//") { http.Error(w,"Bad request",400); return }
  if r.ContentLength > 16<<20 { http.Error(w,"Body too large",413); return }
  if !hasSession {
   expires:=time.Now().Add(sessionDuration)
   http.SetCookie(w,&http.Cookie{Name:sessionName,Value:sessionToken(expires),Path:"/",HttpOnly:true,SameSite:http.SameSiteStrictMode,Expires:expires,MaxAge:int(sessionDuration/time.Second)})
  }
  // Backend services do not receive the gateway authentication cookie.
  cookies:=r.Cookies()
  r.Header.Del("Cookie")
  for _,cookie:=range cookies {if cookie.Name!=sessionName {r.AddCookie(cookie)}}
  r.Body = http.MaxBytesReader(w,r.Body,16<<20)
  if r.URL.Path=="/air-api/credentials" {credentialsHandler(w,r);return}
  if r.URL.Path=="/air-api/speedtest" {internetSpeed.ServeHTTP(w,r);return}
  if r.URL.Path=="/air-api/wifi-security" {wifiSecurity.ServeHTTP(w,r);return}
  if strings.HasPrefix(r.URL.Path,"/air-api/wifi/") {wifiRadar.ServeHTTP(w,r);return}
  if r.URL.Path=="/air-api/monitor" {deviceMonitor.ServeHTTP(w,r);return}
  if r.URL.Path=="/air-api/traffic" || strings.HasPrefix(r.URL.Path,"/air-api/traffic/") {
   if r.URL.Path=="/air-api/traffic/daily" {proxyService.ServeDailyVnstat(w,r);return}
   if r.URL.Path=="/air-api/traffic/vnstatd" {trafficStats.ServeVnstatdHTTP(w,r);return}
   trafficStats.ServeHTTP(w,r)
   return
  }
  if strings.HasPrefix(r.URL.Path,"/air-api/proxy") || strings.HasPrefix(r.URL.Path,"/air-api/network") {proxyService.ServeHTTP(w,r);return}
  if r.URL.Path=="/air-api/charge" || strings.HasPrefix(r.URL.Path,"/air-api/charge/") {chargeManager.ServeHTTP(w,r);return}
  if strings.HasPrefix(r.URL.Path,"/air-api/system/") || r.URL.Path=="/air-api/system" {systemManager.ServeHTTP(w,r);return}
  if strings.HasPrefix(r.URL.Path,"/air-api/") {wifiDevices.ServeHTTP(w,r);return}
  proxy.ServeHTTP(w,r)
 })
}

func main() {
 wifiDevices.start()
 go wifiRadar.ensureSoftapIni()
 wifiRadar.startSoftapWatchdog()
 deviceMonitor.start()
 trafficStats.start()
 proxyService.start()
 chargeManager.start()
 systemManager.start()
 config := "/home/root/admin-auth/credentials.json"
 data,err:=os.ReadFile(config); if err!=nil { log.Fatal("Cannot read credentials") }
 var c credentials
 if json.Unmarshal(data,&c)!=nil || c.Username=="" || c.Password=="" { log.Fatal("Invalid credentials") }
 applyCred(c)   // 装入全局哈希，供认证与改密码接口共用
 mappings:=[][2]int{{18080,80},{18081,8080},{17681,7681},{19998,9998}}
 type service struct { listener net.Listener; handler http.Handler }
 var services []service
 for _,ports:=range mappings {
  listener,e:=net.Listen("tcp",fmt.Sprintf(":%d",ports[0])); if e!=nil { log.Fatal(e) }
  api:=""; if ports[1]==80 { api="127.0.0.1:8080" }
  services=append(services,service{listener,authHandler(c,fmt.Sprintf("http://127.0.0.1:%d",ports[1]),api)})
 }
 for _,s:=range services {
  srv:= &http.Server{Handler:s.handler, ReadHeaderTimeout:10*time.Second,ReadTimeout:60*time.Second, IdleTimeout:30*time.Second,MaxHeaderBytes:32768}
  go func(srv *http.Server,l net.Listener){ log.Fatal(srv.Serve(l)) }(srv,s.listener)
 }
 select{}
}
