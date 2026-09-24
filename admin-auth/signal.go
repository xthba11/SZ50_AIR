package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"time"
)

type cellularSignal struct {
	Cell string   `json:"cell"`
	RSRP *float64 `json:"rsrp"`
	RSRQ *float64 `json:"rsrq"`
	SINR *float64 `json:"sinr"`
}

var signalHTTP = &http.Client{Timeout: 4 * time.Second, Transport: &http.Transport{Proxy: nil, MaxIdleConns: 1, IdleConnTimeout: 30 * time.Second}, CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse }}

func readCellularSignal() ([]byte, error) {
	response, e := signalHTTP.Get("http://127.0.0.1:8080/api/get/network")
	if e != nil {
		return nil, e
	}
	defer response.Body.Close()
	if response.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("network status %d", response.StatusCode)
	}
	raw, e := io.ReadAll(io.LimitReader(response.Body, 128*1024+1))
	if e != nil {
		return nil, e
	}
	if len(raw) > 128*1024 {
		return nil, fmt.Errorf("network response too large")
	}
	return raw, nil
}
func signalText(raw json.RawMessage) string {
	var s string
	if json.Unmarshal(raw, &s) == nil {
		return s
	}
	var n json.Number
	if json.Unmarshal(raw, &n) == nil {
		if _, e := strconv.ParseFloat(string(n), 64); e == nil {
			return string(n)
		}
	}
	return ""
}
func signalNumber(raw json.RawMessage, min, max float64) *float64 {
	n, e := parseNumber([]byte(signalText(raw)))
	if e != nil || *n < min || *n > max {
		return nil
	}
	return n
}
func parseCellularSignal(raw []byte) (*cellularSignal, error) {
	var response struct {
		Code *int
		Data struct {
			Technology string
			Network    []struct{ Band, ARFCN, PCI, RSRP, RSRQ, SINR json.RawMessage }
		}
	}
	if json.NewDecoder(bytes.NewReader(raw)).Decode(&response) != nil || response.Code == nil || *response.Code != 0 || len(response.Data.Network) == 0 {
		return nil, fmt.Errorf("network data unavailable")
	}
	row := response.Data.Network[0]
	signal := &cellularSignal{Cell: response.Data.Technology + "|" + signalText(row.Band) + "|" + signalText(row.ARFCN) + "|" + signalText(row.PCI), RSRP: signalNumber(row.RSRP, -160, -20), RSRQ: signalNumber(row.RSRQ, -50, 20), SINR: signalNumber(row.SINR, -40, 60)}
	if signal.RSRP == nil && signal.RSRQ == nil && signal.SINR == nil {
		return nil, fmt.Errorf("signal readings unavailable")
	}
	return signal, nil
}
