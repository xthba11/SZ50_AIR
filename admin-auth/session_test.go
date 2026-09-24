package main

import (
 "io"
 "net/http"
 "net/http/cookiejar"
 "net/http/httptest"
 "strings"
 "testing"
 "time"
)

func TestSingleLoginAcrossPorts(t *testing.T) {
 upstream:=httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter,r *http.Request){
  if _,err:=r.Cookie(sessionName);err==nil{t.Error("session leaked to backend")}
  w.Write([]byte("ok"))
 }));defer upstream.Close()
 c:=credentials{"admin","test-password"}
 first:=httptest.NewServer(authHandler(c,upstream.URL,""));defer first.Close()
 second:=httptest.NewServer(authHandler(c,upstream.URL,""));defer second.Close()
 jar,_:=cookiejar.New(nil)
 client:=&http.Client{Jar:jar}
 login,_:=http.NewRequest("GET",first.URL+"/",nil)
 login.SetBasicAuth(c.Username,c.Password)
 response,err:=client.Do(login);if err!=nil{t.Fatal(err)}
 io.Copy(io.Discard,response.Body);response.Body.Close()
 if response.StatusCode!=200{t.Fatal(response.Status)}
 cookies:=response.Cookies()
 if len(cookies)!=1 || !cookies[0].HttpOnly || cookies[0].SameSite!=http.SameSiteStrictMode || cookies[0].Path!="/" || cookies[0].Domain!="" {t.Fatal("unsafe session cookie settings")}
 response,err=client.Get(second.URL+"/");if err!=nil{t.Fatal(err)}
 defer response.Body.Close()
 if response.StatusCode!=200{t.Fatalf("second port required another login: %d",response.StatusCode)}
}

func TestRejectInvalidSessions(t *testing.T){
 h:=authHandler(credentials{"admin","test-password"},"http://127.0.0.1:1","")
 for _,value:=range []string{"invalid",sessionToken(time.Now().Add(-time.Minute)),sessionToken(time.Now().Add(24*time.Hour)),sessionToken(time.Now().Add(time.Hour))+"x"}{
  r:=httptest.NewRequest("GET","/",nil);r.AddCookie(&http.Cookie{Name:sessionName,Value:value})
  w:=httptest.NewRecorder();h.ServeHTTP(w,r)
  if w.Code!=401{t.Fatalf("invalid session accepted: %d",w.Code)}
 }
 r:=httptest.NewRequest("GET","/",nil);r.AddCookie(&http.Cookie{Name:sessionName,Value:sessionToken(time.Now().Add(time.Hour))});r.Header.Set("Origin","http://foreign.invalid")
 w:=httptest.NewRecorder();h.ServeHTTP(w,r)
 if w.Code!=403{t.Fatal("cross-site session accepted")}
 if strings.Contains(w.Header().Get("Set-Cookie"),sessionName){t.Fatal("session issued on rejection")}
}
