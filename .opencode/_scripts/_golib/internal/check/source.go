// Source check — ID-shaped source values must resolve to existing entities.
// ring: 2 (LOCAL-READ)
package check

import (
	"strings"

	"assembler/scripts/golib/internal/entity"
	"assembler/scripts/golib/internal/patlib"
	"assembler/scripts/golib/internal/violation"
)

// CheckSource verifies source fields that look like entity IDs.
// URLs, "assembler", "INSP.*", and citation strings are exempt.
func CheckSource(entries []entity.EntityEntry, allIDs map[string]struct{}) []violation.Fault {
	var faults []violation.Fault
	for _, entry := range entries {
		value := strings.TrimSpace(entry.Metadata.Source)
		if value == "" {
			continue
		}
		if strings.HasPrefix(value, "assembler") || strings.HasPrefix(value, "http") || strings.HasPrefix(value, "INSP") {
			continue
		}
		if !patlib.IsIDShape(value) {
			continue
		}
		if _, ok := allIDs[value]; !ok {
			faults = append(faults, violation.Fault{
				ID:      entry.ID,
				Type:    entry.Type,
				Field:   "source",
				Value:   value,
				Problem: "source does not match any known entity ID",
			})
		}
	}
	return faults
}
