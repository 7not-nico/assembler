// ID-match check — frontmatter id must equal the file stem.
// ring: 2 (LOCAL-READ)
package check

import (
	"path/filepath"

	"assembler/scripts/golib/internal/entity"
	"assembler/scripts/golib/internal/violation"
)

// CheckIDMatch verifies each entry's frontmatter id equals its filename stem.
func CheckIDMatch(entries []entity.EntityEntry) []violation.Fault {
	var faults []violation.Fault
	for _, entry := range entries {
		stem := filepath.Base(entry.FilePath)
		if i := len(stem) - 1; i >= 0 && stem[i] == '.' {
			stem = stem[:i]
		} else if i := lastDot(stem); i >= 0 {
			stem = stem[:i]
		}
		if entry.ID == "" {
			faults = append(faults, violation.Fault{
				ID:      stem,
				Type:    entry.Type,
				Field:   "id",
				Value:   "(missing)",
				Problem: "frontmatter id field is missing or empty",
			})
		} else if entry.ID != stem {
			faults = append(faults, violation.Fault{
				ID:      stem,
				Type:    entry.Type,
				Field:   "id",
				Value:   "frontmatter id=" + entry.ID + ", filename=" + stem,
				Problem: "frontmatter id does not match filename",
			})
		}
	}
	return faults
}

func lastDot(s string) int {
	for i := len(s) - 1; i >= 0; i-- {
		if s[i] == '.' {
			return i
		}
	}
	return -1
}
