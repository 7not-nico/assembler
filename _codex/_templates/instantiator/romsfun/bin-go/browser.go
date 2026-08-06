// Package main — browser: shared Chromium readiness.
package main

import (
	"fmt"
	"net/http"
	"os"
	"time"
)

// assertReady verifies the shared CDP browser answers /json/version on port.
func assertReady(port string) error {
	client := &http.Client{Timeout: 2 * time.Second}
	resp, err := client.Get(fmt.Sprintf("http://127.0.0.1:%s/json/version", port))
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("cdp http %d", resp.StatusCode)
	}
	return nil
}

// port returns the CDP port: env CDP_PORT overrides the seed default.
func port(s *Store) string {
	if p := os.Getenv("CDP_PORT"); p != "" {
		return p
	}
	return value(s, "CDP_PORT_HEADED")
}
