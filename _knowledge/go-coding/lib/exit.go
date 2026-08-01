// Package lib — shared I/O utilities for calculator shells.
// This is part of the imperative shell — all functions handle
// stdin/stdout interaction, not pure computation.
package lib

import "strings"

// IsExit — returns true if the line signals program exit.
func IsExit(line string) bool {
	switch strings.ToLower(strings.TrimSpace(line)) {
	case "exit", "quit", "q":
		return true
	default:
		return false
	}
}
