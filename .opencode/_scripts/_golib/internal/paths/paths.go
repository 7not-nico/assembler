// Package paths resolves the assembler root and entity directories.
// ring: 2 (LOCAL-READ) — filesystem discovery.
package paths

import (
	"os"
	"path/filepath"
	"runtime"
	"sort"
	"strings"
)

// root walks upward from this source file to the ancestor containing
// .opencode/entities. Handles both layouts:
//   assembler/_scripts/_golib and assembler/.opencode/_scripts/_golib
var root = resolveRoot()

func resolveRoot() string {
	_, file, _, _ := runtime.Caller(0) // internal/paths/paths.go
	dir := filepath.Dir(file)
	for {
		if isDir(filepath.Join(dir, ".opencode", "entities")) {
			return dir
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			panic("assembler root not found — no .opencode/entities ancestor")
		}
		dir = parent
	}
}

// Root returns the assembler root directory (contains .opencode/).
func Root() string { return root }

// EntitiesDir returns the .opencode/entities directory.
func EntitiesDir() string { return filepath.Join(root, ".opencode", "entities") }

func isDir(path string) bool {
	info, err := os.Stat(path)
	return err == nil && info.IsDir()
}

// EntityTypes lists directories under entities/ that contain .md files.
func EntityTypes() []string {
	base := EntitiesDir()
	entries, err := os.ReadDir(base)
	if err != nil {
		return nil
	}
	var types []string
	for _, entry := range entries {
		if !entry.IsDir() {
			continue
		}
		files, err := os.ReadDir(filepath.Join(base, entry.Name()))
		if err != nil {
			continue
		}
		for _, f := range files {
			if !f.IsDir() && strings.HasSuffix(f.Name(), ".md") {
				types = append(types, entry.Name())
				break
			}
		}
	}
	sort.Strings(types)
	return types
}

// EntityFiles lists .md files under entities/{entityType} (max depth 2).
func EntityFiles(entityType string) []string {
	base := filepath.Join(EntitiesDir(), entityType)
	var files []string
	_ = filepath.WalkDir(base, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return nil
		}
		if d.IsDir() {
			rel, _ := filepath.Rel(base, path)
			if rel != "." && strings.Count(rel, string(filepath.Separator)) >= 2 {
				return filepath.SkipDir
			}
			return nil
		}
		if strings.HasSuffix(d.Name(), ".md") {
			files = append(files, path)
		}
		return nil
	})
	sort.Strings(files)
	return files
}
