# Todo — bitacora-log wrapper: always-on exec tracing

Topic: bitacora-log.sh evolution — provenance header, ALWAYS-on exec tracing
Session: 2026-08-01
Status: completed

## Tasks

- [x] Survey structure-stdout skill; apply keyed-line contract to wrapper
- [x] Create skill-list.sh fixture; establish run-a-fixture-then-read rule
- [x] Header keys: ARGS, CLI, GIT, BRANCH, ENV, SESSION, PID, TASK, SCOPE, OUT, IN
- [x] Output metrics: OUT_LINES, OUT_BYTES, ERR_LINES; stdout/stderr split
- [x] Integrity: DUR (ms), SHA anchor, exit propagation
- [x] Signal ranking: drop USER, HOST, TTY (constant/low-signal on this host)
- [x] Header ordering iterations (CMD first; DUR after PID; exit before GIT; SCOPE before SESSION)
- [x] TOOLS key: version every wrapper-invoked binary (git + coreutils suite)
- [x] Research exec-tracing alternatives (tracexec, execsnoop, fptrace, forkstat, auditd, bash_ct, Oil xtrace, strace)
- [x] PROGS/EXEC keys: tracexec ALWAYS-on per-invocation exec capture
- [x] Two-pass nested trace attempt → EPERM (ptrace cannot nest); redesign to single outer trace
- [x] Single-pass wrapper: outer tracexec captures wrapper + user command tree; inner runs directly
- [x] --trace FORMAT flag: persist full export (json/json-stream/perfetto) for deep analysis
- [x] Fix perfetto binary-protobuf summary gap (honest note + TRACE_FILE key)
- [x] Fixture suite: 10 synthetic + 10 _scripts code fixtures + Ruby toolchain fixture
- [x] Verify: Go CLI, Ruby analyzers, pipes, multi-toolchain (bash→ruby→assembler-cli) chains
- [x] Document session in bitacora (todo + report)
- [x] Bug-tracing .sh toolchain (3 scripts in _sandbox/)
  - [x] trace-bug.sh — buffered 3-layer (xtrace + DEBUG trap + tracexec); nested-safe under bitacora (EPERM defer)
  - [x] trace-stream.sh — live stdout stream (xtrace + DEBUG, --file tee)
  - [x] trace-live.sh — per-command timing via BASH_ENV-injected DEBUG trap
  - [x] Key finding: DEBUG traps don't cross shell processes; BASH_ENV injection makes them run inside the traced script
  - [x] buggy-script.sh fixture (missing cmd, nonexistent dir, masked exit 0)
  - [x] Composition verified: all 3 tracers + bitacora-log (provenance + EXEC + SHA)

## Open edges

- [x] `go=(no --version)` in PROGS — fixed: per-tool version flag (`go version`); verified `go=go version go1.26.5-X:nodwarf5 linux/amd64`
- json-stream trace format: summary parse not implemented (same binary/newline-delimited gap as perfetto)
- Perfetto/protobuf summary parsing: deferred — honest note emitted instead
- trace-live.sh: timing via BASH_ENV applies to bash scripts; non-bash commands (sh -c, binaries) fall back to wrapper-level timing only
- trace-stream.sh: no L3 tracexec layer (live-only); pair with bitacora-log for exec genealogy

## Logs

- task-stdout/20260801-*.log — all runs this session (sessions: ten-fixtures, scripts-fixtures, scripts-v2, ruby-fixture, onepass, trace-*, progs-*)
