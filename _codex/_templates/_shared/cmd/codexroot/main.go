// Package main — codexroot resolves the _codex root ancestor of a base dir.
// Usage: codexroot {base_dir}
// Thin entry: delegates the walk-up to internal/codex. Prints the absolute
// path on stdout, exits 0. Prints an error on stderr, exits 1. Usage: exit 2.
// Pure: no side effects.
package main

import (
	"fmt"
	"os"

	"templates-shared/internal/codex"
)

func main() {
	if len(os.Args) != 2 {
		fmt.Fprintln(os.Stderr, "usage: codexroot {base_dir}")
		os.Exit(2)
	}
	root, err := codex.Root(os.Args[1])
	if err != nil {
		fmt.Fprintf(os.Stderr, "codexroot: %v\n", err)
		os.Exit(1)
	}
	fmt.Println(root)
}
