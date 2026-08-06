// Package main — romsfun: the romsfun instantiator toolchain in Go.
// Usage: romsfun {browse|fetch|verify|launch|stop|trace} [args...]
package main

import (
	"fmt"
	"os"
)

func main() {
	if len(os.Args) < 2 {
		usage()
		os.Exit(2)
	}
	s := load()
	switch os.Args[1] {
	case "browse":
		browse(s, os.Args[2:])
	case "fetch":
		fetch(s, os.Args[2:])
	case "verify":
		verify(s, os.Args[2:])
	case "launch":
		launch(s, os.Args[2:])
	case "stop":
		stop(s, os.Args[2:])
	case "trace":
		trace(s, os.Args[2:])
	default:
		fmt.Fprintf(os.Stderr, "ERROR unknown command: %s\n", os.Args[1])
		usage()
		os.Exit(2)
	}
}

func usage() {
	fmt.Fprintln(os.Stderr, `usage: romsfun {browse|fetch|verify|launch|stop|trace} [args...]
  browse  {game} {console} [--timeout {s}]                              list download variants
  fetch   {url} [timeout] [--out {dir}] [--selector {css}]              download via shared browser
  verify  {file} [--image-ext {ext,ext...}]                             verify a game archive
  launch  {binary} {rom} [--log {path}] [--env K=V]... [--emu-arg {arg}]...  detach-launch an emulator
  stop    {binary}                                                      stop a process chain
  trace   {trace-file} [--patterns {file}] [--head {n}]                 mine evidence lines`)
}
