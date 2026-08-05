// Package main — bitacora frames a command's output into a task-stdout log.
// Usage: bitacora {name} [--trace] -- {command} [args...]
// Walks up from its own location to the _codex root (canonical and dive
// copies both resolve), writes {YYYYMMDD}-{HHMMSS}-{name}.log under
// _codex/_bitacora/task-stdout/ with the # CMD:/# DATE:/# CWD: header,
// streams the command live to terminal and file, then appends
// # DUR:/# DATE:/# exit: and exits with the command's status.
// --trace runs the command through tracexec for exec-tree lines.
// Framing only: the command's own output passes through unchanged.
// Side effects: runs commands, writes logs — orchestrator, not pure.
package main

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"
)

func usage() {
	fmt.Fprintln(os.Stderr, "usage: bitacora {name} [--trace] -- {command} [args...]")
	os.Exit(2)
}

// codexRoot walks up from the binary's own dir to the _codex ancestor.
func codexRoot() (string, error) {
	exe, err := os.Executable()
	if err != nil {
		return "", err
	}
	dir, err := filepath.Abs(filepath.Dir(exe))
	if err != nil {
		return "", err
	}
	for d := dir; ; d = filepath.Dir(d) {
		if filepath.Base(d) == "_codex" {
			return d, nil
		}
		if filepath.Dir(d) == d {
			break
		}
	}
	return "", fmt.Errorf("no _codex ancestor above %s", dir)
}

func main() {
	if len(os.Args) < 2 {
		usage()
	}
	name := os.Args[1]
	rest := os.Args[2:]
	trace := false
	if len(rest) > 0 && rest[0] == "--trace" {
		trace = true
		rest = rest[1:]
	}
	if len(rest) == 0 || rest[0] != "--" {
		usage()
	}
	cmdArgs := rest[1:]
	if len(cmdArgs) == 0 {
		usage()
	}

	root, err := codexRoot()
	if err != nil {
		fmt.Fprintf(os.Stderr, "bitacora: %v\n", err)
		os.Exit(1)
	}
	stdoutDir := filepath.Join(root, "_bitacora", "task-stdout")
	if err := os.MkdirAll(stdoutDir, 0o755); err != nil {
		fmt.Fprintf(os.Stderr, "bitacora: %v\n", err)
		os.Exit(1)
	}
	logPath := filepath.Join(stdoutDir, time.Now().Format("20060102-150405")+"-"+name+".log")
	logFile, err := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0o644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "bitacora: %v\n", err)
		os.Exit(1)
	}
	defer logFile.Close()

	// header — same fields the root assembler bitacora-log.sh records
	cmdLine := make([]string, 0, len(cmdArgs))
	for _, a := range cmdArgs {
		cmdLine = append(cmdLine, fmt.Sprintf("%q", a))
	}
	header := fmt.Sprintf("# CMD: %s\n# DATE: %s\n# CWD: %s\n# --------------------\n",
		strings.Join(cmdLine, " "), time.Now().Format(time.RFC3339), mustPwd())
	_, _ = logFile.WriteString(header)
	fmt.Print(header)

	// run — live tee to terminal + file, 2>&1 merged
	var cmd *exec.Cmd
	if trace {
		cmd = exec.Command("tracexec", append([]string{"log", "--"}, cmdArgs...)...)
	} else {
		cmd = exec.Command(cmdArgs[0], cmdArgs[1:]...)
	}
	cmd.Stdin = os.Stdin
	cmd.Stdout = io.MultiWriter(os.Stdout, logFile)
	cmd.Stderr = io.MultiWriter(os.Stdout, logFile)

	start := time.Now()
	err = cmd.Run()
	status := 0
	if err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			status = exitErr.ExitCode()
		} else {
			fmt.Fprintf(os.Stderr, "bitacora: %v\n", err)
			status = 1
		}
	}
	dur := time.Since(start).Milliseconds()

	// tail
	tail := fmt.Sprintf("# DUR: %dms\n# DATE: %s\n# exit: %d\n",
		dur, time.Now().Format(time.RFC3339), status)
	_, _ = logFile.WriteString(tail)
	fmt.Print(tail)
	os.Exit(status)
}

func mustPwd() string {
	pwd, err := os.Getwd()
	if err != nil {
		return "?"
	}
	return pwd
}
