// Package main — bitacora flow: io edge (record writes + root resolution).
// Mirrors r4_bitacora.py's record_write. Composes the pure core (record.go,
// body.go). Memoized _codex root via internal/codex; lazy no-clobber via
// filepath.Glob. io: fs writes.
package main

import (
	"fmt"
	"os"
	"path/filepath"

	"templates-shared/internal/codex"
)

// rootMemo — memoized _codex root (one walk, shared across call sites).
var rootMemo string

// root — memoized _codex root from this binary's own dir.
func root() (string, error) {
	if rootMemo != "" {
		return rootMemo, nil
	}
	exe, err := os.Executable()
	if err != nil {
		return "", err
	}
	r, err := codex.Root(filepath.Dir(exe))
	if err != nil {
		return "", err
	}
	rootMemo = r
	return r, nil
}

// recordWrite — create a record file, no-clobber per topic. io: fs write.
func recordWrite(rec Record, body string) (string, error) {
	base, err := root()
	if err != nil {
		return "", err
	}
	recDir := filepath.Join(base, "_bitacora", rec.subdir)
	if err := os.MkdirAll(recDir, 0o755); err != nil {
		return "", err
	}
	matches, err := filepath.Glob(filepath.Join(recDir, "*-"+rec.topic+".md"))
	if err != nil {
		return "", err
	}
	if len(matches) > 0 {
		// filepath.Glob returns sorted matches — first is the oldest record
		return "", fmt.Errorf("%s record exists: %s", rec.subdir, matches[0])
	}
	path := rec.path(base)
	if err := os.WriteFile(path, []byte(body), 0o644); err != nil {
		return "", err
	}
	return path, nil
}
