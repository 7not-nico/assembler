// Package main — process: detach-launch and exact-name stop.
package main

import (
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"syscall"
	"time"
)

// spawn starts bin with rom in a new session, logging to path; returns the
// pid when the process survives the grace period.
func spawn(bin, rom, log string, envs, emuArgs []string) (int, error) {
	if err := os.MkdirAll("/tmp/opencode", 0o755); err != nil {
		return 0, err
	}
	lf, err := os.OpenFile(log, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, 0o644)
	if err != nil {
		return 0, err
	}
	defer lf.Close()
	cmd := exec.Command(bin, append(append([]string{}, emuArgs...), rom)...)
	cmd.Stdout = lf
	cmd.Stderr = lf
	cmd.Stdin = nil
	cmd.Env = append(os.Environ(), envs...)
	cmd.SysProcAttr = &syscall.SysProcAttr{Setsid: true}
	if err := cmd.Start(); err != nil {
		return 0, err
	}
	pid := cmd.Process.Pid
	time.Sleep(2 * time.Second)
	if !alive(pid) {
		_ = cmd.Wait()
		body, _ := read(log)
		return 0, fmt.Errorf("emulator exited early — crash or missing window\n%s", body)
	}
	return pid, nil
}

// halt terminates every process whose comm matches name, sweeps wrappers
// whose command line names it, and returns 1 stopped / 0 not running.
func halt(name string) (int, error) {
	pids := procsNamed(name)
	if len(pids) == 0 {
		fmt.Printf("no %s running\n", name)
		fmt.Println("STOPPED=0")
		return 0, nil
	}
	for _, p := range pids {
		_ = syscall.Kill(p, syscall.SIGTERM)
	}
	time.Sleep(1 * time.Second)
	for _, p := range allProcs() {
		line := cmdline(p)
		if strings.Contains(line, name) &&
			(strings.Contains(line, "tracexec") || strings.Contains(line, "run-bitacora")) {
			_ = syscall.Kill(p, syscall.SIGTERM)
		}
	}
	time.Sleep(1 * time.Second)
	if left := procsNamed(name); len(left) > 0 {
		fmt.Fprintln(os.Stderr, "ERROR still running:")
		for i, p := range left {
			if i >= 3 {
				break
			}
			fmt.Fprintf(os.Stderr, "%d %s\n", p, cmdline(p))
		}
		fmt.Println("STOPPED=0")
		return 0, fmt.Errorf("still running")
	}
	fmt.Printf("%s chain stopped\n", name)
	fmt.Println("STOPPED=1")
	return 1, nil
}

// procsNamed returns pids whose comm matches name exactly (pgrep -x analog).
func procsNamed(name string) []int {
	var out []int
	for _, p := range allProcs() {
		if comm, err := os.ReadFile("/proc/" + strconv.Itoa(p) + "/comm"); err == nil &&
			strings.TrimSpace(string(comm)) == name {
			out = append(out, p)
		}
	}
	return out
}

// allProcs lists numeric /proc entries as pids.
func allProcs() []int {
	ents, err := os.ReadDir("/proc")
	if err != nil {
		return nil
	}
	var out []int
	for _, e := range ents {
		if pid, err := strconv.Atoi(e.Name()); err == nil {
			out = append(out, pid)
		}
	}
	return out
}

// cmdline returns a process's command line (NUL fields joined by space).
func cmdline(pid int) string {
	b, err := os.ReadFile("/proc/" + strconv.Itoa(pid) + "/cmdline")
	if err != nil {
		return ""
	}
	return strings.TrimSpace(strings.ReplaceAll(string(b), "\x00", " "))
}

// alive reports whether pid exists and is not a zombie.
func alive(pid int) bool {
	b, err := os.ReadFile("/proc/" + strconv.Itoa(pid) + "/stat")
	if err != nil {
		return false
	}
	i := strings.LastIndexByte(string(b), ')')
	if i < 0 || i+2 >= len(b) {
		return false
	}
	return b[i+2] != 'Z'
}
