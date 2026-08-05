// Package main — tests for the pure core (record, body, frame). No I/O.
package main

import (
	"strings"
	"testing"
)

func TestRecordPath(t *testing.T) {
	r := Record{subdir: "task-todo", topic: "test", ts: "20260805-120000"}
	got := r.path("/codex")
	want := "/codex/_bitacora/task-todo/20260805-120000-test.md"
	if got != want {
		t.Errorf("path = %s, want %s", got, want)
	}
}

func TestTodoBody(t *testing.T) {
	got := todoBody("topic", "desc", "2026-08-05")
	for _, want := range []string{"# topic — todo", "**Date:** 2026-08-05", "**Project:** desc", "## Tasks"} {
		if !strings.Contains(got, want) {
			t.Errorf("todoBody missing %q:\n%s", want, got)
		}
	}
}

func TestReportBody(t *testing.T) {
	got := reportBody("20260805-120000", "topic", "desc", "2026-08-05")
	for _, want := range []string{"close-out", "## What happened", "## Decisions", "## Verification", "## Open edges", "## Todo state"} {
		if !strings.Contains(got, want) {
			t.Errorf("reportBody missing %q", want)
		}
	}
}

func TestFrameHeader(t *testing.T) {
	got := frameHeader([]string{"echo", "hi"}, "/cwd", "2026-08-05T12:00:00Z")
	want := "# CMD: \"echo\" \"hi\"\n# DATE: 2026-08-05T12:00:00Z\n# CWD: /cwd\n# --------------------\n"
	if got != want {
		t.Errorf("frameHeader = %q, want %q", got, want)
	}
}

func TestFrameTail(t *testing.T) {
	got := frameTail(42, 7, "2026-08-05T12:00:00Z")
	want := "# DUR: 42ms\n# DATE: 2026-08-05T12:00:00Z\n# exit: 7\n"
	if got != want {
		t.Errorf("frameTail = %q, want %q", got, want)
	}
}

func TestUsageText(t *testing.T) {
	got := usageText()
	for _, want := range []string{"todo", "run", "report"} {
		if !strings.Contains(got, want) {
			t.Errorf("usageText missing %q", want)
		}
	}
}
