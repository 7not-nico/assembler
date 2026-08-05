---
id: PATTERN.STREAM.TEE.FRAME
title: Stream-Tee Frame — Live Output, One Handle, No Buffer
layer: pattern/
purpose: "A command frame streams output live to terminal and log through one handle via io.MultiWriter — no buffering, no reopen, mirroring bash tee."
naming: stream-tee-frame.md
tags: [pattern, morphism, streaming, tee, framing, go]
status: active
---
# STREAM-TEE-FRAME.md

**Layer:** pattern/
**Naming:** `stream-tee-frame.md` — code morphism, reusable structure.
**Composes with:** `pattern/bitacora-log-framing.md` (the frame it streams); derived from `study/` + `fixture/` proof.

## Morphism

A command frame opens its log handle once, then tees the command's stdout and stderr live to terminal and log simultaneously — output flows as produced, never buffered in memory.

## Structure

```go
logFile, _ := os.OpenFile(logPath, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0o644)
defer logFile.Close()

logFile.WriteString(header); fmt.Print(header)      // header through one handle

proc := exec.Command(argv[0], argv[1:]...)
proc.Stdout = io.MultiWriter(os.Stdout, logFile)   // tee: terminal + log
proc.Stderr = io.MultiWriter(os.Stderr, logFile)
status := proc.Run()

logFile.WriteString(tail); fmt.Print(tail)          // tail through the same handle
```

Invariant: one file handle per frame; output streams in real time; the log mirrors exactly what the terminal shows; no intermediate buffer grows with output size.

## Verification

Run a long build through the frame — the log grows as the build progresses, never after; a megabyte output leaves the process at constant memory; the log tail (`# exit:`) always lands after the stream closes.

## Instance

`_shared/cmd/bitacora/run.go` (2026-08-05) — replaced the buffered `bytes.Buffer` capture; the melonDS build (megabytes) streams live; 14-case matrix green.
