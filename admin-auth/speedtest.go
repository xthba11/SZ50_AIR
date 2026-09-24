package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net"
	"net/http"
	"strconv"
	"sync"
	"sync/atomic"
	"time"
)

const speedDownloadBytes int64 = 100 << 20
const speedWarmupBytes int64 = 2 << 20
const speedDownloadDuration = 15 * time.Second
const speedUploadBytes int64 = 4 << 20
const speedNodeName = "南航·南京"

type speedResult struct {
	DownloadSeconds float64   `json:"download_seconds"`
	DownloadLimited bool      `json:"download_limited"`
	State           string    `json:"state"`
	Phase           string    `json:"phase"`
	Download        *float64  `json:"download_mbps"`
	Upload          *float64  `json:"upload_mbps"`
	Latency         *float64  `json:"latency_ms"`
	Bytes           int64     `json:"bytes"`
	Budget          int64     `json:"budget_bytes"`
	Node            string    `json:"node"`
	Error           string    `json:"error"`
	Started         time.Time `json:"started_at"`
	Finished        time.Time `json:"finished_at"`
}
type speedService struct {
	mu                 sync.Mutex
	result             speedResult
	count              atomic.Int64
	cancel             context.CancelFunc
	client             *http.Client
	base               string
	downBytes, upBytes int64
	warmupBytes        int64
	downloadDuration   time.Duration
}

func newSpeedService() *speedService {
	return &speedService{result: speedResult{State: "idle", Budget: speedDownloadBytes + speedUploadBytes}, base: "https://speed.nuaa.edu.cn", downBytes: speedDownloadBytes, warmupBytes: speedWarmupBytes, downloadDuration: speedDownloadDuration, upBytes: speedUploadBytes, client: &http.Client{Transport: &http.Transport{Proxy: nil, DialContext: (&net.Dialer{Timeout: 5 * time.Second}).DialContext, TLSHandshakeTimeout: 8 * time.Second, ResponseHeaderTimeout: 12 * time.Second, DisableCompression: true, MaxIdleConns: 2, IdleConnTimeout: 15 * time.Second}, CheckRedirect: func(*http.Request, []*http.Request) error { return http.ErrUseLastResponse }}}
}
func jsonReply(w http.ResponseWriter, status int, value any) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.Header().Set("Cache-Control", "no-store")
	w.WriteHeader(status)
	json.NewEncoder(w).Encode(value)
}
func readJSON(w http.ResponseWriter, r *http.Request, value any) error {
	if r.Header.Get("Content-Type") != "application/json" {
		return fmt.Errorf("JSON required")
	}
	dec := json.NewDecoder(http.MaxBytesReader(w, r.Body, 1024))
	dec.DisallowUnknownFields()
	if err := dec.Decode(value); err != nil {
		return err
	}
	var tail any
	if dec.Decode(&tail) != io.EOF {
		return fmt.Errorf("extra JSON")
	}
	return nil
}
func (s *speedService) snapshot() speedResult {
	s.mu.Lock()
	defer s.mu.Unlock()
	result := s.result
	result.Bytes = s.count.Load()
	return result
}
func (s *speedService) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	switch r.Method {
	case "GET":
		jsonReply(w, 200, s.snapshot())
	case "POST":
		var input struct {
			Confirm bool `json:"confirm"`
		}
		if readJSON(w, r, &input) != nil || !input.Confirm {
			jsonReply(w, 400, map[string]string{"error": "请确认测速流量"})
			return
		}
		s.mu.Lock()
		if s.result.State == "running" {
			s.mu.Unlock()
			jsonReply(w, 409, map[string]string{"error": "已有测速正在进行"})
			return
		}
		if !s.result.Finished.IsZero() && time.Since(s.result.Finished) < 10*time.Second {
			s.mu.Unlock()
			jsonReply(w, 429, map[string]string{"error": "请稍后再测"})
			return
		}
		ctx, cancel := context.WithTimeout(context.Background(), 75*time.Second)
		s.cancel = cancel
		s.count.Store(0)
		s.result = speedResult{State: "running", Phase: "latency", Started: time.Now(), Budget: s.downBytes + s.upBytes}
		s.mu.Unlock()
		go s.run(ctx)
		jsonReply(w, 202, s.snapshot())
	case "DELETE":
		s.mu.Lock()
		if s.cancel != nil {
			s.cancel()
		}
		s.mu.Unlock()
		jsonReply(w, 202, s.snapshot())
	default:
		w.Header().Set("Allow", "GET, POST, DELETE")
		http.Error(w, "Method not allowed", 405)
	}
}

type uploadStream struct {
	remaining int64
	count     *atomic.Int64
}

func (u *uploadStream) Read(p []byte) (int, error) {
	if u.remaining == 0 {
		return 0, io.EOF
	}
	if int64(len(p)) > u.remaining {
		p = p[:u.remaining]
	}
	for i := range p {
		p[i] = byte(i*37 + 17)
	}
	u.remaining -= int64(len(p))
	u.count.Add(int64(len(p)))
	return len(p), nil
}
func (s *speedService) request(ctx context.Context, method, path string, body io.Reader, size int64) (*http.Response, error) {
	r, e := http.NewRequestWithContext(ctx, method, s.base+path, body)
	if e != nil {
		return nil, e
	}
	r.Header.Set("Cache-Control", "no-store")
	r.Header.Set("Accept-Encoding", "identity")
	if method == "POST" {
		r.ContentLength = size
		r.Header.Set("Content-Type", "application/octet-stream")
	}
	response, e := s.client.Do(r)
	if e != nil {
		return nil, e
	}
	if response.StatusCode != 200 {
		response.Body.Close()
		return nil, fmt.Errorf("node status %d", response.StatusCode)
	}
	return response, nil
}
func (s *speedService) measure(ctx context.Context, phase string, size int64) (float64, string, error) {
	if phase == "download" {
		return s.measureDownload(ctx, size)
	}
	ctx, cancel := context.WithTimeout(ctx, 30*time.Second)
	defer cancel()
	s.mu.Lock()
	s.result.Phase = phase
	s.mu.Unlock()
	before := s.count.Load()
	start := time.Now()
	var response *http.Response
	var e error
	if phase == "upload" {
		response, e = s.request(ctx, "POST", "/backend/empty.php", &uploadStream{remaining: size, count: &s.count}, size)
	} else {
		response, e = s.request(ctx, "GET", "/backend/empty.php?r="+strconv.FormatInt(time.Now().UnixNano(), 10), nil, 0)
	}
	if e != nil {
		return 0, "", e
	}
	defer response.Body.Close()
	node := speedNodeName
	if phase == "latency" {
		n, err := io.Copy(io.Discard, io.LimitReader(response.Body, 1024))
		e = err
		if e == nil && n != 0 {
			e = fmt.Errorf("unexpected latency response")
		}
		return float64(time.Since(start).Microseconds()) / 1000, node, e
	}
	{
		n, err := io.Copy(io.Discard, io.LimitReader(response.Body, 4096))
		e = err
		if e == nil && n != 0 {
			e = fmt.Errorf("unexpected upload response")
		}
		if e != nil {
			return 0, node, e
		}
		if s.count.Load()-before != size {
			return 0, node, fmt.Errorf("incomplete upload")
		}
	}
	return float64(size) * 8 / time.Since(start).Seconds() / 1e6, node, nil
}

// Keep warmup and measurement in the same response so the warmed connection is used.
func (s *speedService) measureDownload(parent context.Context, size int64) (float64, string, error) {
	ctx, cancel := context.WithTimeout(parent, 30*time.Second)
	defer cancel()
	s.mu.Lock()
	s.result.Phase = "warmup"
	s.mu.Unlock()
	response, err := s.request(ctx, "GET", "/backend/garbage.php?ckSize="+strconv.FormatInt((size+(1<<20)-1)/(1<<20), 10)+"&r="+strconv.FormatInt(time.Now().UnixNano(), 10), nil, 0)
	if err != nil {
		return 0, speedNodeName, err
	}
	defer response.Body.Close()
	var total, measured int64
	var start time.Time
	var timer *time.Timer
	defer func() {
		if timer != nil {
			timer.Stop()
		}
	}()
	begin := func() {
		start = time.Now()
		timer = time.AfterFunc(s.downloadDuration, cancel)
		s.mu.Lock()
		s.result.Phase = "download"
		s.mu.Unlock()
	}
	if s.warmupBytes == 0 {
		begin()
	}
	buffer := make([]byte, 32<<10)
	for total < size {
		limit := int64(len(buffer))
		if remain := size - total; limit > remain {
			limit = remain
		}
		if total < s.warmupBytes && limit > s.warmupBytes-total {
			limit = s.warmupBytes - total
		}
		n, readErr := response.Body.Read(buffer[:limit])
		total += int64(n)
		s.count.Add(int64(n))
		if !start.IsZero() {
			measured += int64(n)
		}
		if start.IsZero() && total >= s.warmupBytes {
			begin()
		}
		if parent.Err() != nil {
			return 0, speedNodeName, parent.Err()
		}
		elapsed := time.Duration(0)
		if !start.IsZero() {
			elapsed = time.Since(start)
		}
		if elapsed >= s.downloadDuration && measured > 0 {
			// A cancellation from our sampling timer is a normal end, unlike a caller cancellation.
			if readErr == nil || ctx.Err() == context.Canceled {
				break
			}
		}
		if readErr != nil {
			if readErr == io.EOF && total == size {
				break
			}
			return 0, speedNodeName, fmt.Errorf("incomplete download: %w", readErr)
		}
	}
	if measured == 0 || start.IsZero() {
		return 0, speedNodeName, fmt.Errorf("no download sample after warmup")
	}
	seconds := time.Since(start).Seconds()
	if seconds <= 0 {
		seconds = 0.001
	}
	s.mu.Lock()
	s.result.DownloadSeconds = seconds
	s.result.DownloadLimited = total >= size && seconds < s.downloadDuration.Seconds()
	s.mu.Unlock()
	return float64(measured) * 8 / seconds / 1e6, speedNodeName, nil
}

func (s *speedService) run(ctx context.Context) {
	var failure error
	// Establish TLS before taking the displayed HTTP latency measurement.
	_, _, failure = s.measure(ctx, "latency", 0)
	if failure == nil {
		v, node, e := s.measure(ctx, "latency", 0)
		failure = e
		if e == nil {
			s.mu.Lock()
			s.result.Latency = &v
			s.result.Node = node
			s.mu.Unlock()
		}
	}
	for _, phase := range []string{"download", "upload"} {
		if failure != nil {
			break
		}
		size := s.downBytes
		if phase == "upload" {
			size = s.upBytes
		}
		v, node, e := s.measure(ctx, phase, size)
		failure = e
		if e == nil {
			s.mu.Lock()
			if phase == "download" {
				s.result.Download = &v
			} else {
				s.result.Upload = &v
			}
			if node != "" {
				s.result.Node = node
			}
			s.mu.Unlock()
		}
	}
	s.mu.Lock()
	defer s.mu.Unlock()
	s.result.State = "done"
	s.result.Phase = ""
	s.result.Finished = time.Now()
	if ctx.Err() == context.Canceled {
		s.result.State = "cancelled"
	} else if failure != nil {
		s.result.State = "failed"
		s.result.Error = "测速节点连接失败或超时，请重试"
	}
	if s.cancel != nil {
		s.cancel()
		s.cancel = nil
	}
	s.client.CloseIdleConnections()
}

var internetSpeed = newSpeedService()
