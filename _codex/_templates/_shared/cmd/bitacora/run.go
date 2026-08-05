// Package main — bitacora flow: io edge (command framing).
// Mirrors r4_bitacora.py's cmd_run. Composes the pure core (frame.go).
// --trace runs through tracexec for exec-tree lines. Streams live: the log
// handle opens once; io.MultiWriter tees stdout+stderr to terminal and log
// simultaneously (no buffering, mirrors bash `2>&1 | tee -a`). io:
// subprocess + log write. Exit: the framed command's status.
package main

import (
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"time"
)

// cmdRun — frame a command: header, run, tail. io: subprocess + log write.
func cmdRun(name string, trace bool, cmd []string) int {
	if len(cmd) == 0 {
		fmt.Fprintln(os.Stderr, "command required")
		return 2
	}
	base, err := root()
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR %v\n", err)
		return 1
	}
	stdoutDir := filepath.Join(base, "_bitacora", "task-stdout")
	if err := os.MkdirAll(stdoutDir, 0o755); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR %v\n", err)
		return 1
	}
	now := time.Now()
	ts := now.Format("20060102-150405")
	logPath := filepath.Join(stdoutDir, ts+"-"+name+".log")

	// one handle for the whole frame — header, streamed body, tail
	logFile, err := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0o644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "ERROR %v\n", err)
		return 1
	}
	defer logFile.Close()

	header := frameHeader(cmd, mustPwd(), now.Format(time.RFC3339))
	logFile.WriteString(header)
	fmt.Print(header)

	argv := cmd
	if trace {
		argv = append([]string{"tracexec", "log", "--"}, cmd...)
	}
	start := time.Now()
	status := runStream(logFile, argv)
	durMS := int(time.Since(start).Milliseconds())

	tail := frameTail(durMS, status, time.Now().Format(time.RFC3339))
	logFile.WriteString(tail)
	fmt.Print(tail)
	return status
}

// runStream — run argv, teeing stdout+stderr live to logFile and terminal.
// No buffering: output flows as produced (builds, traces stream in real time).
func runStream(logFile *os.File, argv []string) int {
	proc := exec.Command(argv[0], argv[1:]...)
	proc.Stdout = io.MultiWriter(os.Stdout, logFile)
	proc.Stderr = io.MultiWriter(os.Stderr, logFile)
	runErr := proc.Run()
	if runErr != nil {
		if errors.Is(runErr, exec.ErrNotFound) {
			fmt.Fprintf(os.Stderr, "ERROR command not found: %s\n", argv[0])
			return 127
		}
		if _, ok := runErr.(*exec.ExitError); !ok {
			fmt.Fprintf(os.Stderr, "ERROR %v\n", runErr)
			return 1
		}
	}
	if proc.ProcessState != nil {
		return proc.ProcessState.ExitCode()
	}
	return 0
}

func mustPwd() string {
	pwd, err := os.Getwd()
	if err != nil {
		return "?"
	}
	return pwd
}
