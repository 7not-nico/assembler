// Package main — bitacora flow: constants (the file-top declarations).
// Every constant the flow uses lives here — record structure, subdirs, and
// time formats — so no file scatters a literal. Compiled into the binary;
// the compiler enforces them (Go has no runtime schema read).
package main

const (
	// _RecordRoot — the record root dir name under _codex.
	_RecordRoot = "_bitacora"

	// _StdoutSubdir — the command-log subdir under the record root.
	_StdoutSubdir = "task-stdout"

	// _TodoSubdir — the task-todo subdir.
	_TodoSubdir = "task-todo"

	// _ReportSubdir — the task-report subdir.
	_ReportSubdir = "task-report"

	// _TsFormat — record filename timestamp: YYYYMMDD-HHMMSS.
	_TsFormat = "20060102-150405"

	// _DateFormat — record header date: YYYY-MM-DD.
	_DateFormat = "2006-01-02"
)
