// Package main — codexroot resolves the _codex root ancestor of a base dir.
// Usage: codexroot {base_dir}
// Walks up from base_dir until a directory named _codex; prints its absolute
// path on stdout, exits 0. Prints an error on stderr, exits 1. Symlinks
// resolve for parity with the bash cd+pwd behavior. Pure: no side effects.
package main

import (
	"fmt"
	"os"
	"path/filepath"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "usage: codexroot {base_dir}")
		os.Exit(2)
	}
	base, err := filepath.Abs(os.Args[1])
	if err != nil {
		fmt.Fprintf(os.Stderr, "codexroot: %v\n", err)
		os.Exit(1)
	}
	base, err = filepath.EvalSymlinks(base)
	if err != nil {
		fmt.Fprintf(os.Stderr, "codexroot: %v\n", err)
		os.Exit(1)
	}
	for dir := base; ; dir = filepath.Dir(dir) {
		if filepath.Base(dir) == "_codex" {
			fmt.Println(dir)
			os.Exit(0)
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
	}
	fmt.Fprintf(os.Stderr, "codexroot: no _codex ancestor above %s\n", base)
	os.Exit(1)
}
