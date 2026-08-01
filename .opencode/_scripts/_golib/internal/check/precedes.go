// Precedes check — precedes targets must exist; Tortoise-Hare cycle detection.
// ring: 2 (LOCAL-READ)
package check

import (
	"strings"

	"assembler/scripts/golib/internal/entity"
	"assembler/scripts/golib/internal/violation"
)

// CheckPrecedes verifies precedes targets exist and reports dependency cycles.
func CheckPrecedes(entries []entity.EntityEntry) ([]violation.Fault, []string) {
	var faults []violation.Fault
	var cycles []string

	entityTable := make(map[string]struct{}, len(entries))
	precedesTable := make(map[string][]string)
	for _, entry := range entries {
		entityTable[entry.ID] = struct{}{}
		if len(entry.Metadata.Precedes) > 0 {
			precedesTable[entry.ID] = entry.Metadata.Precedes
		}
	}

	// Each precedes target must exist.
	for _, entry := range entries {
		for _, target := range entry.Metadata.Precedes {
			if _, ok := entityTable[target]; !ok {
				faults = append(faults, violation.Fault{
					ID:      entry.ID,
					Type:    entry.Type,
					Field:   "precedes",
					Value:   target,
					Problem: "precedes target not found among entities",
				})
			}
		}
	}

	// Tortoise-Hare cycle detection on first-target chains.
	visited := make(map[string]struct{})
	for start := range precedesTable {
		if _, seen := visited[start]; seen {
			continue
		}
		var path []string
		current := start
		pathSeen := make(map[string]int)
		for {
			if _, seen := pathSeen[current]; seen {
				cycleStart := pathSeen[current]
				cycles = append(cycles, strings.Join(path[cycleStart:], " → "))
				break
			}
			visited[current] = struct{}{}
			pathSeen[current] = len(path)
			path = append(path, current)
			targets, ok := precedesTable[current]
			if !ok || len(targets) == 0 {
				break
			}
			current = targets[0]
		}
	}

	return faults, cycles
}
