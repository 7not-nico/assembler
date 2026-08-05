// Package codex — shared _codex root resolution for the templates-shared
// binaries. Pure: path math only, no I/O beyond path resolution.
// Serves cmd/codexroot and cmd/bitacora (and any future binary needing the
// root). One home for the walk-up — no duplication across binaries.
package codex

import (
	"fmt"
	"path/filepath"
)

// Root — walk up from base until a directory named _codex; returns its
// absolute path. Symlinks resolve for parity with the bash cd+pwd behavior.
func Root(base string) (string, error) {
	abs, err := filepath.Abs(base)
	if err != nil {
		return "", err
	}
	resolved, err := filepath.EvalSymlinks(abs)
	if err != nil {
		return "", err
	}
	for dir := resolved; ; dir = filepath.Dir(dir) {
		if filepath.Base(dir) == "_codex" {
			return dir, nil
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
	}
	return "", fmt.Errorf("no _codex ancestor above %s", resolved)
}
