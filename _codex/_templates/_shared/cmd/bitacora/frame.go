// Package main — bitacora flow: pure core (frame builders).
// Mirrors r0_record.py's frame_header / frame_tail / usage_text. Pure:
// string composition only, no I/O.
package main

import (
	"fmt"
	"strings"
)

// frameHeader — the # CMD:/# DATE:/# CWD: header block.
func frameHeader(cmd []string, cwd, date string) string {
	quoted := make([]string, len(cmd))
	for i, c := range cmd {
		quoted[i] = fmt.Sprintf("%q", c)
	}
	return fmt.Sprintf("# CMD: %s\n# DATE: %s\n# CWD: %s\n# --------------------\n",
		strings.Join(quoted, " "), date, cwd)
}

// frameTail — the # DUR:/# DATE:/# exit: tail block.
func frameTail(durMS int, status int, date string) string {
	return fmt.Sprintf("# DUR: %dms\n# DATE: %s\n# exit: %d\n", durMS, date, status)
}

// usageText — the usage block.
func usageText() string {
	return "usage: bitacora {todo|run|report} ...\n" +
		"  bitacora todo   {topic} [\"{desc}\"]\n" +
		"  bitacora run    {name} [--trace] -- {cmd...}\n" +
		"  bitacora report {topic} [\"{desc}\"]"
}
