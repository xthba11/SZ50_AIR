package main

import (
	"context"
	"errors"
	"io"
	"net/http"
	"net/http/httptest"
	"strconv"
	"strings"
	"testing"
	"time"
)

func waitSpeed(t *testing.T, s *speedService) speedResult {
	t.Helper()
	limit := time.Now().Add(3 * time.Second)
	for time.Now().Before(limit) {
		r := s.snapshot()
		if r.State != "running" {
			return r
		}
		time.Sleep(5 * time.Millisecond)
	}
	t.Fatal("speed test did not finish")
	return speedResult{}
}
func TestSpeedMeasurements(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/backend/garbage.php" {
			n, _ := strconv.Atoi(r.URL.Query().Get("ckSize"))
			w.Write(make([]byte, n<<20))
			return
		}
		if r.URL.Path == "/backend/empty.php" {
			if r.Method == "GET" {
				return
			}
			n, e := io.Copy(io.Discard, r.Body)
			if e != nil || n != 512 {
				t.Error("upload length", n, e)
			}
			return
		}
		http.NotFound(w, r)
	}))
	defer server.Close()
	s := newSpeedService()
	s.base = server.URL
	s.downBytes = 1 << 20
	s.warmupBytes = 64 << 10
	s.upBytes = 512
	req := httptest.NewRequest("POST", "/air-api/speedtest", strings.NewReader(`{"confirm":true}`))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	s.ServeHTTP(w, req)
	if w.Code != 202 {
		t.Fatal(w.Code)
	}
	r := waitSpeed(t, s)
	if !r.DownloadLimited || r.DownloadSeconds <= 0 || r.State != "done" || r.Download == nil || r.Upload == nil || r.Latency == nil || r.Bytes != (1<<20)+512 || r.Node != speedNodeName {
		t.Fatal(r)
	}
	req = httptest.NewRequest("POST", "/air-api/speedtest", strings.NewReader(`{"confirm":true}`))
	req.Header.Set("Content-Type", "application/json")
	w = httptest.NewRecorder()
	s.ServeHTTP(w, req)
	if w.Code != 429 {
		t.Fatal("cooldown not enforced", w.Code)
	}
}
func TestSpeedCancelAndSingleJob(t *testing.T) {
	started := make(chan struct{}, 1)
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		select {
		case started <- struct{}{}:
		default:
		}
		<-r.Context().Done()
	}))
	defer server.Close()
	s := newSpeedService()
	s.base = server.URL
	post := func() int {
		r := httptest.NewRequest("POST", "/air-api/speedtest", strings.NewReader(`{"confirm":true}`))
		r.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()
		s.ServeHTTP(w, r)
		return w.Code
	}
	if post() != 202 {
		t.Fatal("start")
	}
	<-started
	if post() != 409 {
		t.Fatal("duplicate accepted")
	}
	s.ServeHTTP(httptest.NewRecorder(), httptest.NewRequest("DELETE", "/air-api/speedtest", nil))
	if waitSpeed(t, s).State != "cancelled" {
		t.Fatal("not cancelled")
	}
}
func TestSpeedPartialFailure(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) { w.Write([]byte("short")) }))
	defer server.Close()
	s := newSpeedService()
	s.base = server.URL
	s.downBytes = 100
	_, _, e := s.measure(context.Background(), "download", 100)
	if e == nil {
		t.Fatal("truncated payload accepted")
	}
}
func TestSpeedAuthentication(t *testing.T) {
	h := authHandler(credentials{"admin", "test"}, "http://127.0.0.1:1", "")
	for _, path := range []string{"/air-api/speedtest", "/air-api/wifi-security"} {
		r := httptest.NewRequest("POST", path, strings.NewReader(`{"confirm":true}`))
		w := httptest.NewRecorder()
		h.ServeHTTP(w, r)
		if w.Code != 401 {
			t.Fatal(path, w.Code)
		}
	}
}

func TestSpeedRejectsUnexpectedSuccessPage(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "POST" {
			io.Copy(io.Discard, r.Body)
		}
		w.Write([]byte("<html>Unavailable</html>"))
	}))
	defer server.Close()
	for _, phase := range []string{"latency", "upload"} {
		s := newSpeedService()
		s.base = server.URL
		if _, _, e := s.measure(context.Background(), phase, 512); e == nil {
			t.Fatal("HTML accepted as valid", phase)
		}
	}
}

func TestSpeedTimedDownloadAndWarmup(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		time.Sleep(150 * time.Millisecond) // Connection/header delay must not enter the sample.
		w.WriteHeader(200)
		w.(http.Flusher).Flush()
		block := make([]byte, 1024)
		for i := 0; i < 1024; i++ {
			if _, e := w.Write(block); e != nil {
				return
			}
			w.(http.Flusher).Flush()
			select {
			case <-r.Context().Done():
				return
			case <-time.After(5 * time.Millisecond):
			}
		}
	}))
	defer server.Close()
	s := newSpeedService()
	s.base = server.URL
	s.warmupBytes = 4096
	s.downloadDuration = 100 * time.Millisecond
	before := time.Now()
	rate, _, err := s.measure(context.Background(), "download", 1<<20)
	elapsed := time.Since(before)
	result := s.snapshot()
	if err != nil || rate <= 0 || result.DownloadSeconds < 0.09 || result.DownloadSeconds > 0.3 || elapsed < 250*time.Millisecond || result.DownloadLimited || result.Bytes <= 4096 || result.Bytes >= 1<<20 {
		t.Fatal(rate, err, result, elapsed)
	}
	// The displayed throughput excludes the warmup bytes as well as connection delay.
	want := float64(result.Bytes-4096) * 8 / result.DownloadSeconds / 1e6
	if rate != want {
		t.Fatal(rate, want)
	}
}
func TestSpeedCancelDuringDownload(t *testing.T) {
	started := make(chan struct{})
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.Write(make([]byte, 8192))
		w.(http.Flusher).Flush()
		close(started)
		<-r.Context().Done()
	}))
	defer server.Close()
	s := newSpeedService()
	s.base = server.URL
	s.warmupBytes = 1024
	ctx, cancel := context.WithCancel(context.Background())
	go func() { <-started; cancel() }()
	if _, _, err := s.measure(ctx, "download", 1<<20); !errors.Is(err, context.Canceled) {
		t.Fatal(err)
	}
}
