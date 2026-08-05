// Package main — portup probes a CDP endpoint for readiness.
// Usage: portup {port}
// GETs http://127.0.0.1:{port}/json/version with a 2-second timeout; exits 0
// when the endpoint answers HTTP 200, 1 otherwise. Silent on both paths.
// Pure: no side effects.
package main

import (
	"fmt"
	"net/http"
	"os"
	"time"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "usage: portup {port}")
		os.Exit(2)
	}
	client := &http.Client{Timeout: 2 * time.Second}
	resp, err := client.Get(fmt.Sprintf("http://127.0.0.1:%s/json/version", os.Args[1]))
	if err != nil {
		os.Exit(1)
	}
	defer resp.Body.Close()
	if resp.StatusCode == http.StatusOK {
		os.Exit(0)
	}
	os.Exit(1)
}
