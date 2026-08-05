// Package main — bitacora flow: pure core (body builders).
// Mirrors r0_record.py's todo_body / report_body. Pure: string
// composition only, no I/O.
package main

import "fmt"

// todoBody — the task-todo record body.
func todoBody(topic, desc, date string) string {
	return fmt.Sprintf("# %s — todo\n\n**Date:** %s\n**Project:** %s\n\n## Tasks\n\n", topic, date, desc)
}

// reportBody — the task-report record body.
func reportBody(ts, topic, desc, date string) string {
	return fmt.Sprintf("# %s — %s close-out\n\n**Date:** %s\n**Project:** %s\n\n## What happened\n\n## Decisions\n\n## Verification\n\n## Open edges\n\n## Todo state\n\n",
		ts, topic, date, desc)
}
