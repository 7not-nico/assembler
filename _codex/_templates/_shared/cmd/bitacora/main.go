// Package main — bitacora flow: thin dispatch entry.
// Usage: bitacora {todo|run|report} ...
//
//	bitacora todo   {topic} ["{desc}"]           — open a task-todo record
//	bitacora run    {name} [--trace] -- {cmd...} — frame a command's output
//	bitacora report {topic} ["{desc}"]           — open a task-report record
//
// Composes the pure core (record.go, body.go, frame.go) and the io edge
// (write.go, run.go). Dispatch only — no logic here. Exit: framed command's
// status on run; 0 on record open; 1 on errors; 2 on usage.
package main

import (
	"fmt"
	"os"
	"time"
)

func usage() {
	fmt.Fprintln(os.Stderr, usageText())
	os.Exit(2)
}

func main() {
	argv := os.Args[1:]
	if len(argv) == 0 {
		usage()
	}
	sub := argv[0]
	switch sub {
	case "todo":
		if len(argv) < 2 {
			usage()
		}
		topic := argv[1]
		desc := topic
		if len(argv) > 2 {
			desc = argv[2]
		}
		now := time.Now()
		ts := now.Format("20060102-150405")
		rec := Record{subdir: "task-todo", topic: topic, ts: ts}
		path, err := recordWrite(rec, todoBody(topic, desc, now.Format("2006-01-02")))
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR %v\n", err)
			os.Exit(1)
		}
		fmt.Printf("TODO=%s\n", path)
	case "report":
		if len(argv) < 2 {
			usage()
		}
		topic := argv[1]
		desc := topic
		if len(argv) > 2 {
			desc = argv[2]
		}
		now := time.Now()
		ts := now.Format("20060102-150405")
		rec := Record{subdir: "task-report", topic: topic, ts: ts}
		path, err := recordWrite(rec, reportBody(ts, topic, desc, now.Format("2006-01-02")))
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR %v\n", err)
			os.Exit(1)
		}
		fmt.Printf("REPORT=%s\n", path)
	case "run":
		if len(argv) < 3 {
			usage()
		}
		name := argv[1]
		rest := argv[2:]
		trace := false
		if len(rest) > 0 && rest[0] == "--trace" {
			trace = true
			rest = rest[1:]
		}
		if len(rest) == 0 || rest[0] != "--" {
			usage()
		}
		cmd := rest[1:]
		if len(cmd) == 0 {
			usage() // empty command after -- : no log written
		}
		os.Exit(cmdRun(name, trace, cmd))
	default:
		usage()
	}
}
