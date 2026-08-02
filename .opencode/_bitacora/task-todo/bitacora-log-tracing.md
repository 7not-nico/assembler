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
- [x] fixture-ruby-sim.sh — composes the 3 _sandbox Ruby programs (random-sum, random-stats, monte-carlo) through the wrapper; SKIP gracefully on fresh clone (gitignored _sandbox); verified pass:3 (log 211147)
- [x] Verify: Go CLI, Ruby analyzers, pipes, multi-toolchain (bash→ruby→assembler-cli) chains
- [x] Document session in bitacora (todo + report)
- [x] Bug-tracing .sh toolchain (3 scripts in _sandbox/)
  - [x] trace-bug.sh — buffered 3-layer (xtrace + DEBUG trap + tracexec); nested-safe under bitacora (EPERM defer)
  - [x] trace-stream.sh — live stdout stream (xtrace + DEBUG, --file tee)
  - [x] trace-live.sh — per-command timing via BASH_ENV-injected DEBUG trap
  - [x] Key finding: DEBUG traps don't cross shell processes; BASH_ENV injection makes them run inside the traced script
  - [x] buggy-script.sh fixture (missing cmd, nonexistent dir, masked exit 0)
  - [x] Composition verified: all 3 tracers + bitacora-log (provenance + EXEC + SHA)
  - [x] trace-exec.sh — exec timeline tracer (elapsed/delta ms, pid-nesting tree, errno flags); finding: tracexec has no ppid
  - [x] trace-useful.sh — useful-log tracer: collapses PATH-scan ENOENT bursts, surfaces real exec tree; 15 raw → 4 useful events (buggy-script)
  - [x] cloth-config fixtures: fixture-cloth-config.sh (structural, pass:150), fixture-cloth-api.sh (API surface, pass:16); awk ternary paren fix, threshold corrections
  - [x] cloth suite expanded to 5: + fixture-cloth-animators.sh (pass:13), fixture-cloth-serializers.sh (pass:7), fixture-cloth-entries.sh (pass:30); serializer FORMATS comma-trim fix
  - [x] fixture-cloth-docs.sh — Context7 docs-vs-code conformance: 9/9 documented methods, 4/4 chain setters, 3/3 screen API; RESULT=pass:docs-conformant
  - [x] fixture-trace-useful.sh — mode-aware (deferred under bitacora / standalone full trace); fixed nested-tracexec EPERM hang (was clearing BITACORA_SELF_TRACED → ptrace EPERM stall)
  - [x] trace-strace.sh — syscall-level tracer (strace 7.0): per-process exits expose masked failures (127 command-not-found, 2 ls error); PATH scans collapsed, locale/ld.so noise dropped; label parsed from error write (child never execs)
  - [x] fixture-trace-strace.sh — mode-aware; standalone pass:4 (PIDS=4, FAILED=117, exit127+exit2 surfaced, scans collapsed)

## Open edges

- [x] `go=(no --version)` in PROGS — fixed: per-tool version flag (`go version`); verified `go=go version go1.26.5-X:nodwarf5 linux/amd64`
- json-stream trace format: summary parse not implemented (same binary/newline-delimited gap as perfetto)
- Perfetto/protobuf summary parsing: deferred — honest note emitted instead
- trace-live.sh: timing via BASH_ENV applies to bash scripts; non-bash commands (sh -c, binaries) fall back to wrapper-level timing only
- trace-stream.sh: no L3 tracexec layer (live-only); pair with bitacora-log for exec genealogy
- tracexec emits no ppid — pid-nesting heuristic infers depth (first-seen pid = child, re-exec = same level)
- nested tracexec under bitacora hangs (ptrace EPERM): tracers defer via BITACORA_SELF_TRACED; do NOT clear it inside fixtures
- docs study (Playwright + web): tracexec native flags duplicate tracer logic — `--show-cwd`, `--decode-errno`, `--diff-env`, `--diff-fd`, `--show-interpreter`; consider replacing python re-parsing
- eBPF backend: does NOT use ptrace → nests under bitacora (EPERM-free); requires root/CAP_BPF (memlock rlimit error without); kernel 7.1.5 supports it (≥5.17) but CapEff=0 blocks — needs sudo password

## Logs

- task-stdout/20260801-*.log — all runs this session (sessions: ten-fixtures, scripts-fixtures, scripts-v2, ruby-fixture, onepass, trace-*, progs-*)
