package main

import (
	"os"
	"testing"
)

func TestCellularSignal(t *testing.T) {
	for _, raw := range []string{`{"Code":0,"Data":{"Technology":"nr","Network":[{"Band":"78","ARFCN":"633984","PCI":"300","RSRP":"-63.3","RSRQ":"-1.0","SINR":"29.5"}]}}`, `{"Code":0,"Data":{"Technology":"nr","Network":[{"Band":78,"ARFCN":633984,"PCI":300,"RSRP":-63.3,"RSRQ":-1,"SINR":29.5}]}}`} {
		s, e := parseCellularSignal([]byte(raw))
		if e != nil || s.Cell != "nr|78|633984|300" || s.RSRP == nil || *s.RSRP != -63.3 || *s.RSRQ != -1 || *s.SINR != 29.5 {
			t.Fatal(s, e)
		}
	}
	for _, raw := range []string{`{}`, `{"Code":1}`, `{"Code":0,"Data":{"Network":[]}}`, `{"Code":0,"Data":{"Network":[{"RSRP":null,"RSRQ":"unknown","SINR":"NaN"}]}}`} {
		if _, e := parseCellularSignal([]byte(raw)); e == nil {
			t.Fatal("invalid data accepted")
		}
	}
	s, e := parseCellularSignal([]byte(`{"Code":0,"Data":{"Network":[{"RSRP":"-70","RSRQ":null,"SINR":999}]}}`))
	if e != nil || s.RSRQ != nil || s.SINR != nil {
		t.Fatal("missing signal fabricated", s, e)
	}
}
func TestSignalFailureKeepsGap(t *testing.T) {
	s := newMonitorService()
	s.read = func(string) ([]byte, error) { return nil, os.ErrNotExist }
	s.glob = func(string) ([]string, error) { return nil, nil }
	s.run = func(string, ...string) (string, error) { return "", os.ErrNotExist }
	s.network = func() ([]byte, error) { return nil, os.ErrNotExist }
	s.sample()
	p := s.samples[0]
	if p.Signal != nil || p.SignalError == "" {
		t.Fatal("network error has no gap")
	}
}
