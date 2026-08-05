// Package main — bitacora flow: pure core (record identity).
// Mirrors r0_record.py's Record. Owns its path derivation. Pure: no I/O,
// no side effects. Body/frame builders live in body.go / frame.go.
package main

import (
	"fmt"
	"path/filepath"
)

// Record — a record identity: subdir + topic + timestamp. Owns path
// derivation. Pure: value type, no methods with side effects.
type Record struct {
	subdir string
	topic  string
	ts     string
}

// path — {base}/_bitacora/{subdir}/{ts}-{topic}.md
func (r Record) path(base string) string {
	return filepath.Join(base, _RecordRoot, r.subdir, fmt.Sprintf("%s-%s.md", r.ts, r.topic))
}
