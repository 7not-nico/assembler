// Package main — text: the one home for word walking shared by modules.
package main

import "strings"

// split breaks a string into whitespace-separated fields.
func split(s string) []string {
	return strings.Fields(s)
}
