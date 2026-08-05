// Package main — slugify converts a filename to a lowercase dash-slug.
// Usage: slugify {filename}
// Spaces, parentheses, brackets, and punctuation become dashes; dashes
// collapse; leading/trailing dashes strip; the single trailing extension
// preserves. Byte-wise ASCII handling matches the original bash tr behavior
// (non-ASCII bytes become dashes). Pure: no side effects.
package main

import (
	"fmt"
	"os"
	"strings"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "usage: slugify {filename}")
		os.Exit(2)
	}
	fmt.Println(slugify(os.Args[1]))
}

func slugify(input string) string {
	base := input
	ext := ""
	if dot := strings.LastIndexByte(input, '.'); dot >= 0 {
		base = input[:dot]
		ext = input[dot+1:]
	}
	var b strings.Builder
	dash := false
	for i := 0; i < len(base); i++ {
		c := base[i]
		if c >= 'A' && c <= 'Z' {
			c += 'a' - 'A'
		}
		keep := (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
		if keep {
			b.WriteByte(c)
			dash = false
		} else if !dash {
			b.WriteByte('-')
			dash = true
		}
	}
	slug := strings.Trim(b.String(), "-")
	if ext != "" {
		return slug + "." + ext
	}
	return slug
}
