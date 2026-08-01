// Package violation holds audit findings and their report formatting.
// ring: 0 (PURE) — no I/O.
package violation

import (
	"fmt"

	"assembler/scripts/golib/internal/report"
)

// Fault is one audit finding.
type Fault struct {
	ID     string
	Type   string
	Field  string
	Value  string
	Problem string
}

// ReportFaults formats faults as an aligned table, or an ok marker.
func ReportFaults(faults []Fault) string {
	if len(faults) == 0 {
		return "ok — 0 faults"
	}
	rows := make([][]string, 0, len(faults))
	for _, f := range faults {
		rows = append(rows, []string{f.ID, f.Type, f.Field, f.Value, f.Problem})
	}
	return fmt.Sprintf("Faults (%d):\n%s", len(faults), report.FormatTable(rows, []string{"ID", "Type", "Field", "Value", "Problem"}))
}
