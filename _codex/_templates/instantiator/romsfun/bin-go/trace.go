// Package main — trace: mine evidence lines from an exec trace.
package main

import (
	"fmt"
	"os"
	"regexp"
	"strings"
)

// patterns splits the seed TRACE_PATTERNS on |.
func patterns(s *Store) []string {
	return strings.Split(value(s, "TRACE_PATTERNS"), "|")
}

// loadPatterns reads one regex per line from a patterns file.
func loadPatterns(path string) ([]string, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return nil, err
	}
	var pats []string
	for _, line := range strings.Split(string(b), "\n") {
		if t := strings.TrimSpace(line); t != "" {
			pats = append(pats, t)
		}
	}
	return pats, nil
}

// mine prints the TRACE/LINES/HEAD/EVIDENCE/DONE keyed lines for a trace.
func mine(path string, pats []string, head int) error {
	b, err := os.ReadFile(path)
	if err != nil {
		return err
	}
	raw := string(b)
	total := strings.Count(raw, "\n")
	lines := strings.Split(raw, "\n")
	if len(lines) > 0 && lines[len(lines)-1] == "" {
		lines = lines[:len(lines)-1]
	}
	fmt.Printf("TRACE=%s\n", path)
	fmt.Printf("LINES=%d\n", total)
	for i := 0; i < head && i < total; i++ {
		fmt.Printf("HEAD %s\n", lines[i])
	}
	for _, pat := range pats {
		re, err := regexp.Compile(pat)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR bad pattern %q: %s\n", pat, err)
			continue
		}
		n := 0
		for i, line := range lines {
			if re.MatchString(line) {
				fmt.Printf("EVIDENCE %d:%s\n", i+1, line)
				n++
				if n >= 5 {
					break
				}
			}
		}
	}
	fmt.Printf("DONE %d lines, %d patterns\n", total, len(pats))
	return nil
}
