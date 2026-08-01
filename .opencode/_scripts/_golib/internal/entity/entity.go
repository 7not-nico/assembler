// Package entity loads entity entries from .opencode/entities/{type}/.
// ring: 2 (LOCAL-READ) — filesystem reads.
package entity

import (
	"os"
	"path/filepath"

	"assembler/scripts/golib/internal/frontmatter"
	"assembler/scripts/golib/internal/paths"
)

// EntityEntry is one parsed entity file.
type EntityEntry struct {
	Type     string
	ID       string
	Title    string
	Metadata frontmatter.Frontmatter
	FilePath string
}

// LoadEntities loads entries of one entity type. Files without parseable
// frontmatter or backmatter are skipped.
func LoadEntities(entityType string) []EntityEntry {
	var entries []EntityEntry
	for _, path := range paths.EntityFiles(entityType) {
		text, err := os.ReadFile(path)
		if err != nil {
			continue
		}
		fm := frontmatter.ParseMetadata(string(text))
		if fm == nil {
			continue
		}
		id := fm.ID
		if id == "" {
			id = fileStem(path)
		}
		entries = append(entries, EntityEntry{
			Type:     entityType,
			ID:       id,
			Title:    fm.Title,
			Metadata: *fm,
			FilePath: path,
		})
	}
	return entries
}

// LoadAllEntities loads every entity type.
func LoadAllEntities() []EntityEntry {
	var all []EntityEntry
	for _, entityType := range paths.EntityTypes() {
		all = append(all, LoadEntities(entityType)...)
	}
	return all
}

// IdentifierSet builds a set of all entity IDs.
func IdentifierSet(entries []EntityEntry) map[string]struct{} {
	set := make(map[string]struct{}, len(entries))
	for _, entry := range entries {
		set[entry.ID] = struct{}{}
	}
	return set
}

func fileStem(path string) string {
	base := filepath.Base(path)
	if i := len(base) - 1; i >= 0 && base[i] == '.' {
		return base[:i]
	}
	for i := len(base) - 1; i >= 0; i-- {
		if base[i] == '.' {
			return base[:i]
		}
	}
	return base
}
