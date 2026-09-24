package main

import (
	"fmt"
	"net/http/httptest"
	"strings"
	"testing"
	"time"
)

func props(mode string, enabled bool, password string) string {
	return fmt.Sprintf("dict entry( string \"TetheringProtocol\" variant string %q )\ndict entry( string \"Tethering\" variant boolean %t )\ndict entry( string \"TetheringPassphrase\" variant string %q )", mode, enabled, password)
}
func TestHotspotParsing(t *testing.T) {
	p, e := parseHotspot(props("wpa2", true, "test12345"))
	if e != nil || p.Mode != "wpa2" || !p.Enabled || !p.HasPassword {
		t.Fatal(p, e)
	}
	if _, e := parseHotspot("ServiceUnknown"); e == nil {
		t.Fatal("service error accepted")
	}
}
func fakeSecurity(failTarget bool) (*securityService, *string, *bool, *[]string) {
	s := newSecurityService()
	mode := "wpa2"
	enabled := true
	calls := []string{}
	s.sleep = func(time.Duration) {}
	s.run = func(name string, args ...string) (string, error) {
		if name == "/usr/sbin/wpa_cli" {
			key := map[string]string{"wpa2": "WPA2-PSK", "wpa": "WPA-PSK", "none": "NONE"}[mode]
			if !enabled {
				return "wpa_state=DISCONNECTED", nil
			}
			return "mode=AP\nwpa_state=COMPLETED\nkey_mgmt=" + key, nil
		}
		if args[len(args)-1] == "net.connman.Technology.GetProperties" {
			return props(mode, enabled, "test12345"), nil
		}
		key, value := args[len(args)-2], args[len(args)-1]
		calls = append(calls, key+"="+value)
		if key == "string:TetheringProtocol" {
			next := strings.TrimPrefix(value, "variant:string:")
			if failTarget && next == "wpa" {
				return "", fmt.Errorf("rejected")
			}
			mode = next
		}
		if key == "string:Tethering" {
			enabled = value == "variant:boolean:true"
		}
		return "method return", nil
	}
	return s, &mode, &enabled, &calls
}
func TestSecurityApplyAndRollback(t *testing.T) {
	for _, failed := range []bool{false, true} {
		s, mode, enabled, calls := fakeSecurity(failed)
		s.apply("wpa", hotspotState{Mode: "wpa2", Enabled: true, HasPassword: true})
		want := "wpa"
		state := "done"
		if failed {
			want = "wpa2"
			state = "failed"
		}
		if *mode != want || !*enabled || s.result.State != state || len(*calls) < 3 {
			t.Fatal(failed, *mode, *enabled, s.result, *calls)
		}
	}
}
func TestSecurityValidationAndNoop(t *testing.T) {
	s, _, _, calls := fakeSecurity(false)
	for _, tc := range []struct {
		body string
		code int
	}{{`{"mode":"wpa3","confirm":true}`, 400}, {`{"mode":"none","confirm":false}`, 400}, {`{"mode":"wpa2","confirm":true,"command":"anything"}`, 400}, {`{"mode":"wpa2","confirm":true}`, 200}} {
		r := httptest.NewRequest("PUT", "/air-api/wifi-security", strings.NewReader(tc.body))
		r.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()
		s.ServeHTTP(w, r)
		if w.Code != tc.code {
			t.Fatal(w.Code, w.Body.String())
		}
	}
	if len(*calls) != 0 {
		t.Fatal("no-op changed hotspot")
	}
	s.run = func(string, ...string) (string, error) { return "", fmt.Errorf("missing service") }
	w := httptest.NewRecorder()
	s.ServeHTTP(w, httptest.NewRequest("GET", "/air-api/wifi-security", nil))
	if w.Code != 503 {
		t.Fatal("service failure accepted")
	}
}
