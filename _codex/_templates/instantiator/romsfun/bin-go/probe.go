// Package main — probe: the one home for exec and stat primitives.
package main

import (
	"fmt"
	"os"
	"os/exec"
	"strings"
)

// run executes a command and returns its trimmed stdout.
func run(name string, args ...string) (string, error) {
	out, err := exec.Command(name, args...).Output()
	return strings.TrimSpace(string(out)), err
}

// stream executes a command with stdout and stderr inherited.
func stream(name string, args ...string) error {
	cmd := exec.Command(name, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	return cmd.Run()
}

// read returns a file's contents trimmed.
func read(path string) (string, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return "", err
	}
	return strings.TrimSpace(string(b)), nil
}

// size returns a file's size in bytes.
func size(path string) (int64, error) {
	fi, err := os.Stat(path)
	if err != nil {
		return 0, err
	}
	return fi.Size(), nil
}

// executable reports whether path exists and has an execute bit set.
func executable(path string) bool {
	fi, err := os.Stat(path)
	if err != nil {
		return false
	}
	return fi.Mode()&0o111 != 0
}

// typeOf probes a file's type via `file -b`; exits when the probe fails.
func typeOf(path string) string {
	t, err := run("file", "-b", path)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR file probe failed: %s\n", path)
		os.Exit(1)
	}
	return t
}
