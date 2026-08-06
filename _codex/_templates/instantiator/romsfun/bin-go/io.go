// Package main — io: the six ops with keyed result lines.
package main

import (
	"fmt"
	"os"
	"path/filepath"
	"strconv"
	"strings"
)

// root resolves the instantiator root (parent of the bin-go exe dir).
func root() string {
	exe, err := os.Executable()
	if err != nil {
		fmt.Fprintln(os.Stderr, "ERROR resolve executable:", err)
		os.Exit(1)
	}
	return filepath.Dir(filepath.Dir(exe))
}

// restartHint prints the shared-browser restart instruction and exits.
func restartHint() {
	fmt.Fprintln(os.Stderr, "ERROR shared browser not running — start it: bash "+
		filepath.Join(root(), "..", "..", "shell", "start-browser.sh"))
	os.Exit(1)
}

// browse lists a game's download variants via the shared browser (delegates
// to the canonical bash tool).
func browse(s *Store, args []string) {
	query, console := "", ""
	timeout := value(s, "TIMEOUT_BROWSE")
	i := 0
	for i < len(args) {
		switch {
		case args[i] == "--timeout":
			if i+1 < len(args) {
				timeout = args[i+1]
			}
			i += 2
		case strings.HasPrefix(args[i], "--"):
			fmt.Fprintf(os.Stderr, "ERROR unknown flag: %s\n", args[i])
			os.Exit(1)
		case query == "":
			query = args[i]
			i++
		case console == "":
			console = args[i]
			i++
		default:
			i++
		}
	}
	if query == "" || console == "" {
		fmt.Fprintln(os.Stderr, "usage: romsfun browse {game} {console} [--timeout {s}]")
		os.Exit(2)
	}
	if !validConsole(s, console) {
		fmt.Fprintf(os.Stderr, "ERROR invalid console '%s' — valid: %s\n", console, consoles(s))
		os.Exit(1)
	}
	if err := assertReady(port(s)); err != nil {
		restartHint()
	}
	if err := stream("bash", filepath.Join(root(), "browse-romsfun.sh"),
		query, console, "--timeout", timeout); err != nil {
		os.Exit(1)
	}
}

// fetch downloads a file via the shared browser (delegates to the canonical
// bash tool).
func fetch(s *Store, args []string) {
	if len(args) == 0 {
		fmt.Fprintln(os.Stderr, "usage: romsfun fetch {url} [timeout] [--out {dir}] [--selector {css}]")
		os.Exit(2)
	}
	url := args[0]
	timeout := value(s, "TIMEOUT_FETCH")
	rest := args[1:]
	if len(rest) > 0 && !strings.HasPrefix(rest[0], "--") {
		timeout = rest[0]
		rest = rest[1:]
	}
	out, sel := "", value(s, "FETCH_SELECTOR")
	i := 0
	for i < len(rest) {
		switch rest[i] {
		case "--out":
			if i+1 < len(rest) {
				out = rest[i+1]
			}
			i += 2
		case "--selector":
			if i+1 < len(rest) {
				sel = rest[i+1]
			}
			i += 2
		default:
			i++
		}
	}
	if err := assertReady(port(s)); err != nil {
		restartHint()
	}
	argv := []string{filepath.Join(root(), "fetch-download.sh"), url, timeout}
	if out != "" {
		argv = append(argv, "--out", out)
	}
	argv = append(argv, "--selector", sel)
	if err := stream("bash", argv...); err != nil {
		os.Exit(1)
	}
}

// verify checks a downloaded game archive and reports the image inside.
func verify(s *Store, args []string) {
	if len(args) == 0 {
		fmt.Fprintln(os.Stderr, "usage: romsfun verify {file} [--image-ext {ext,ext...}]")
		os.Exit(2)
	}
	file := args[0]
	exts := value(s, "IMAGE_EXTS")
	i := 1
	for i < len(args) {
		switch args[i] {
		case "--image-ext":
			exts = ""
			if i+1 < len(args) {
				exts = args[i+1]
			}
			i += 2
		default:
			i++
		}
	}
	if _, err := os.Stat(file); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR no such file: %s\n", file)
		os.Exit(1)
	}
	ft := typeOf(file)
	if kind(ft) == "bare" {
		if !bareAcceptable(ft) {
			fmt.Fprintf(os.Stderr, "ERROR unrecognized archive type: %s\n", ft)
			os.Exit(1)
		}
		sz, err := size(file)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR stat failed: %s\n", file)
			os.Exit(1)
		}
		fmt.Println("OK   bare image")
		fmt.Printf("IMAGE=%s\n", file)
		fmt.Printf("SIZE=%d\n", sz)
		return
	}
	img, ok := firstImage(file, exts)
	if !ok {
		fmt.Fprintf(os.Stderr, "ERROR no image inside archive (expected .%s)\n",
			strings.Join(split(exts), "|."))
		os.Exit(1)
	}
	sz, ok := sizeInArchive(file, img)
	if !ok {
		fmt.Fprintf(os.Stderr, "ERROR size lookup failed for %s\n", img)
		os.Exit(1)
	}
	fmt.Printf("OK   %s (%d B)\n", img, sz)
	fmt.Printf("IMAGE=%s\n", img)
	fmt.Printf("SIZE=%d\n", sz)
}

// launch detaches an emulator binary on a rom and health-checks the process.
func launch(s *Store, args []string) {
	if len(args) < 2 {
		fmt.Fprintln(os.Stderr, "usage: romsfun launch {binary} {rom} [--log {path}] [--env K=V]... [--emu-arg {arg}]...")
		os.Exit(2)
	}
	bin, rom := args[0], args[1]
	log := value(s, "LAUNCH_LOG")
	var envs, emuArgs []string
	i := 2
	for i < len(args) {
		switch args[i] {
		case "--log":
			if i+1 < len(args) {
				log = args[i+1]
			}
			i += 2
		case "--env":
			if i+1 < len(args) {
				envs = append(envs, args[i+1])
			}
			i += 2
		case "--emu-arg":
			if i+1 < len(args) {
				emuArgs = append(emuArgs, args[i+1])
			}
			i += 2
		default:
			i++
		}
	}
	if _, err := os.Stat(rom); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR no such ROM: %s\n", rom)
		os.Exit(1)
	}
	if !executable(bin) {
		fmt.Fprintf(os.Stderr, "ERROR emulator not found: %s\n", bin)
		os.Exit(1)
	}
	if t, err := run("file", rom); err == nil {
		fmt.Println(t)
	}
	fmt.Printf("LAUNCH %s %s\n", bin, rom)
	pid, err := spawn(bin, rom, log, envs, emuArgs)
	if err != nil {
		fmt.Printf("FAIL  %s\n", err)
		os.Exit(1)
	}
	fmt.Printf("RUN   pid=%d log=%s\n", pid, log)
}

// stop terminates a process chain by exact binary name.
func stop(s *Store, args []string) {
	if len(args) == 0 {
		fmt.Fprintln(os.Stderr, "usage: romsfun stop {binary}")
		os.Exit(2)
	}
	if _, err := halt(args[0]); err != nil {
		os.Exit(1)
	}
}

// trace mines evidence lines from an exec trace.
func trace(s *Store, args []string) {
	if len(args) == 0 {
		fmt.Fprintln(os.Stderr, "usage: romsfun trace {trace-file} [--patterns {file}] [--head {n}]")
		os.Exit(2)
	}
	path := args[0]
	pats := patterns(s)
	head := integer(s, "TRACE_HEAD")
	i := 1
	for i < len(args) {
		switch args[i] {
		case "--patterns":
			if i+1 < len(args) {
				var err error
				pats, err = loadPatterns(args[i+1])
				if err != nil {
					fmt.Fprintf(os.Stderr, "ERROR load patterns: %s\n", err)
					os.Exit(1)
				}
			}
			i += 2
		case "--head":
			if i+1 < len(args) {
				n, err := strconv.Atoi(args[i+1])
				if err != nil {
					fmt.Fprintf(os.Stderr, "ERROR bad head value: %s\n", args[i+1])
					os.Exit(1)
				}
				head = n
			}
			i += 2
		default:
			i++
		}
	}
	if _, err := os.Stat(path); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR no such trace: %s\n", path)
		os.Exit(1)
	}
	if err := mine(path, pats, head); err != nil {
		fmt.Fprintf(os.Stderr, "ERROR %s\n", err)
		os.Exit(1)
	}
}
