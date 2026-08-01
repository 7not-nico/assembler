// Ring-match check — ID prefix must map to the directory the file lives in.
// ring: 2 (LOCAL-READ)
package check

import (
	"assembler/scripts/golib/internal/entity"
	"assembler/scripts/golib/internal/patlib"
	"assembler/scripts/golib/internal/violation"
)

// CheckRingMatch verifies each entry's ID prefix matches its entity type.
func CheckRingMatch(entries []entity.EntityEntry) []violation.Fault {
	var faults []violation.Fault
	for _, entry := range entries {
		prefix := patlib.IDPrefix(entry.ID)
		expected := patlib.EntityTypeFromPrefix(prefix)
		if expected == "" {
			faults = append(faults, violation.Fault{
				ID:      entry.ID,
				Type:    entry.Type,
				Field:   "prefix",
				Value:   prefix,
				Problem: "unrecognized entity prefix",
			})
		} else if expected != entry.Type {
			faults = append(faults, violation.Fault{
				ID:      entry.ID,
				Type:    entry.Type,
				Field:   "prefix",
				Value:   prefix + " → " + expected + ", file in " + entry.Type,
				Problem: "prefix-type mismatch",
			})
		}
	}
	return faults
}
