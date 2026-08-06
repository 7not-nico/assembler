// Package main — schema: cite the seed. Hardcoded values live only in
// schema/seed.sql (embedded below); no module hardcodes a value elsewhere.
package main

import (
	_ "embed"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

//go:embed schema/seed.sql
var seed string

// Store holds the seed key/value table.
type Store struct {
	values map[string]string
}

// load parses seed.sql INSERT rows into a Store; exits on a malformed seed.
func load() *Store {
	row := regexp.MustCompile(`\('([^']*)', '([^']*)'`)
	s := &Store{values: make(map[string]string)}
	for _, line := range strings.Split(seed, "\n") {
		m := row.FindStringSubmatch(line)
		if m == nil {
			continue
		}
		if _, dup := s.values[m[1]]; dup {
			fmt.Fprintf(os.Stderr, "ERROR duplicate seed key: %s\n", m[1])
			os.Exit(1)
		}
		s.values[m[1]] = m[2]
	}
	return s
}

// value returns the seed value for key; exits when the key is absent.
func value(s *Store, key string) string {
	v, ok := s.values[key]
	if !ok {
		fmt.Fprintf(os.Stderr, "ERROR missing seed key: %s\n", key)
		os.Exit(1)
	}
	return v
}

// integer parses the seed value for key as an int; exits when malformed.
func integer(s *Store, key string) int {
	n, err := strconv.Atoi(value(s, key))
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR seed key not an integer: %s\n", key)
		os.Exit(1)
	}
	return n
}
