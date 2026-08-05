// Package codex — tests for the shared root resolution. Pure: no setup.
package codex

import (
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func TestRootFromTemplates(t *testing.T) {
	// this file lives at _shared/internal/codex/ — walk up to _codex
	dir, err := filepath.Abs(".")
	if err != nil {
		t.Fatal(err)
	}
	got, err := Root(dir)
	if err != nil {
		t.Fatalf("Root: %v", err)
	}
	// the root must be the _codex ancestor of the test dir
	if filepath.Base(got) != "_codex" {
		t.Errorf("Root base = %q, want _codex", filepath.Base(got))
	}
	rel, err := filepath.Rel(got, dir)
	if err != nil || strings.HasPrefix(rel, "..") {
		t.Errorf("Root(%s) = %s is not an ancestor (rel %q)", dir, got, rel)
	}
}

func TestRootNoAncestor(t *testing.T) {
	_, err := Root("/")
	if err == nil {
		t.Error("Root(/) should error (no _codex above /)")
	}
}

func TestRootMissingDir(t *testing.T) {
	tmp := t.TempDir()
	missing := filepath.Join(tmp, "does-not-exist")
	if _, err := Root(missing); err == nil {
		t.Errorf("Root(%s) should error on missing path", missing)
	}
}

func TestRootFromExplicitCodex(t *testing.T) {
	tmp := t.TempDir()
	codexDir := filepath.Join(tmp, "_codex")
	if err := os.MkdirAll(codexDir, 0o755); err != nil {
		t.Fatal(err)
	}
	got, err := Root(codexDir)
	if err != nil {
		t.Fatalf("Root: %v", err)
	}
	if got != codexDir {
		t.Errorf("Root = %s, want %s", got, codexDir)
	}
}
