// Package report renders aligned tables and bullet lists.
// ring: 0 (PURE) — no I/O.
package report

import (
	"fmt"
	"strings"
)

// FormatTable renders rows into aligned columns with a header and separator.
func FormatTable(rows [][]string, headers []string) string {
	if len(rows) == 0 {
		return "(empty)"
	}
	widths := make([]int, len(headers))
	for i, h := range headers {
		widths[i] = len(h)
	}
	for _, row := range rows {
		for i, val := range row {
			if i < len(widths) && len(val) > widths[i] {
				widths[i] = len(val)
			}
		}
	}
	pad := func(cells []string) string {
		parts := make([]string, len(cells))
		for i, cell := range cells {
			parts[i] = fmt.Sprintf("%-*s", widths[i], cell)
		}
		return strings.Join(parts, " | ")
	}
	head := make([]string, len(headers))
	for i, h := range headers {
		head[i] = fmt.Sprintf("%-*s", widths[i], h)
	}
	seps := make([]string, len(widths))
	for i, w := range widths {
		seps[i] = strings.Repeat("-", w)
	}
	var body []string
	for _, row := range rows {
		body = append(body, pad(row))
	}
	return strings.Join(append([]string{strings.Join(head, " | "), strings.Join(seps, "-|-")}, body...), "\n")
}

// FormatList renders items as a bullet list.
func FormatList(items []string) string {
	if len(items) == 0 {
		return ""
	}
	lines := make([]string, len(items))
	for i, item := range items {
		lines[i] = "- " + item
	}
	return strings.Join(lines, "\n")
}
