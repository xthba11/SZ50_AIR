package main
import("io";"net/http";"net/http/httptest";"strings";"testing")
func TestAuthenticationBoundary(t *testing.T){
 calls:=0
 upstream:=httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter,r *http.Request){calls++;if r.Header.Get("Authorization")!="" {t.Error("credentials forwarded")};w.Write([]byte("backend"))}));defer upstream.Close()
 h:=authHandler(credentials{"admin","test-password"},upstream.URL,"")
 for _,tc:=range []struct{name,password,origin string;status int}{
 {"anonymous","","",401},{"wrong","wrong","",401},{"valid","test-password","",200},{"foreign-origin","test-password","http://foreign.invalid",403},
 }{
 t.Run(tc.name,func(t *testing.T){r:=httptest.NewRequest("GET","/",nil);if tc.password!=""{r.SetBasicAuth("admin",tc.password)};r.Header.Set("Origin",tc.origin);w:=httptest.NewRecorder();h.ServeHTTP(w,r);if w.Code!=tc.status{t.Fatalf("got %d",w.Code)}})
 }
 if calls!=1{t.Fatalf("unauthorized traffic reached backend: %d calls",calls)}
}
func TestAPIAndPost(t *testing.T){
 api:=httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter,r *http.Request){b,_:=io.ReadAll(r.Body);if r.URL.Path!="/api/exec/atcmd" || string(b)!="read-only-test"{t.Error("request changed")};w.Write([]byte("ok"))}));defer api.Close()
 h:=authHandler(credentials{"admin","test-password"},"http://127.0.0.1:1",strings.TrimPrefix(api.URL,"http://"))
 r:=httptest.NewRequest("POST","/api/exec/atcmd",strings.NewReader("read-only-test"));r.SetBasicAuth("admin","test-password");w:=httptest.NewRecorder();h.ServeHTTP(w,r)
 if w.Code!=200 || w.Body.String()!="ok"{t.Fatal(w.Code,w.Body.String())}
}
