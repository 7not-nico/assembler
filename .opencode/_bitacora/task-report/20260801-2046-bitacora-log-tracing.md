# Report — bitacora-log wrapper: always-on exec tracing

Date: 2026-08-01
Topic: bitacora-log-tracing
Todo: task-todo/bitacora-log-tracing.md
Session logs: task-stdout/20260801-*.log (sessions: ten-fixtures, scripts-fixtures, scripts-v2, ruby-fixture, onepass, trace-*, progs-*)

## What was done

1. **Applied structure-stdout contract** — wrapper emits keyed `KEY=value` lines; contract line last in data; diagnostics on stderr; one key per concept.

2. **Evolved header provenance** through iterative signal-ranking (user-driven ordering):
   - Final header: `CMD, ENV, TOOLS, DATE, PID | DUR, exit, GIT, BRANCH, SCOPE, SESSION, TASK, CLI, ARGS, OUT, IN, CWD`
   - Split into pre-run part 1 (CMD..PID) + post-run part 2 (DUR..CWD) because DUR/exit resolve post-run
   - DROPPED USER, HOST, TTY — constant or low-signal on single-user host (decision test: "would a different value change a decision?")

3. **Tail metrics** — OUT_LINES, OUT_BYTES, ERR_LINES (stdout/stderr split via temp files), DUR (ms), SHA (integrity anchor, `sed '/^# SHA:/,$d'` verification), exit propagation.

4. **TOOLS key** — versions every binary the wrapper itself invokes: git + 12 coreutils (sha256sum, date, wc, cat, tee, mktemp, rm, timeout, tr, head, cut). Family-collapse recommended but not applied (12 entries remain).

5. **ALWAYS-on exec tracing via tracexec** (researched alternatives online: strace, execsnoop/bpftrace, fptrace, forkstat, auditd, bash_ct, Oil xtrace):
   - `PROGS` — unique binaries + versions (digit-guarded probe, `(no --version)` fallback)
   - `EXEC*` — every invocation, `pid|filename|argv` — pipes, subshells, children all captured
   - tracexec REQUIRED: missing → hard error, refuses untraced runs (guarantee: every command traced or not at all)
   - `--trace FORMAT` flag (json/json-stream/perfetto): persists full export for deep analysis; perfetto opens in Chrome trace viewer

6. **Fixture suite** — 21 fixtures:
   - 10 synthetic bash (skill-list, args, stderr, keyed, numbers, multiline, slow, env, both, empty)
   - 10 `_scripts` code fixtures wrapping real toolchain (Go CLI: count, list, rings, audit, check id-match, check precedes; Ruby: naming, schema, seed-audit, protocol launcher)
   - 1 Ruby functional toolchain test (fixture-ruby-test.rb + .sh wrapper)
   - Standing rule established: after every change → run a new fixture + read the log output

## Decisions

| Decision | Rationale |
|---|---|
| tracexec over strace/execsnoop | non-root, exec-only, JSON export, tree-following, purpose-built (kxxt/tracexec) |
| Single-pass outer trace | nested ptrace = EPERM (empirically discovered); one tracer, wrapper + user command both captured |
| `--successful-only` | drops failed PATH probes (341→105 events clean) |
| Drop USER/HOST/TTY | constant/low-signal per decision test |
| `--trace perfetto` honest note | binary protobuf unparseable by json schema; emit `(summary unavailable — full export in TRACE_FILE)` |
| tracexec hard-required | "every command logged ALWAYS" — silent untraced fallback unacceptable |

## Errors found & fixed

| Bug | Fix |
|---|---|
| Nested tracexec EPERM (ptrace cannot nest) | redesign: one outer trace, inner runs directly |
| `PROGS_INFO: unbound variable` | initialize before loop |
| BINS overwritten (filtered line clobbered by unfiltered cat) | single filtered assignment |
| Traceback text leaking into PROGS | `sed -n 's/^PROG|\//\//p'` absolute-path filter |
| python `\"` escaping SyntaxError | plain `"` inside single-quoted python |
| pid int/str concat TypeError | `str(ev.get("pid", "?"))` |
| perfetto binary-protobuf → empty summary | format-gated parse + honest note |
| `EXECS_INFO: unbound` when perfetto skips readarray | initialize `EXECS_INFO=()` at outer top |

## Findings

- **ptrace cannot nest**: two tracexec runs → `EPERM: Operation not permitted` (tracexec-backend-ptrace). Single tracer is the architectural constraint.
- **tracexec 0.17.0 JSON schema**: `events[]` with `id, pid, filename, argv.value, result, cwd, env, fdinfo, timestamp` — rich enough for version probing.
- **Clean 105-event trace** for a pipe command: wrapper probes (git, date, wc, tee, python3) + user command tree (sh, grep, wc) — full genealogy, no ENOENT noise.
- **Multi-toolchain chain captured**: `bash → ruby fixture → assembler-cli count → assembler-cli audit patterns` in one EXEC stream (106 events).
- **Perfetto export is binary protobuf** (wire-format `0a 97 03…`), not UTF-8 JSON — Chrome-viewable, not python-parseable without protobuf tooling.
- **Go CLI (`assembler-cli`) has no version flag** — `--version` prints usage; honest `(no --version)` fallback.
- **Go version probe**: `go --version` empty → `go version` (special-cased in ENV only; PROGS uniform probe still `(no --version)`).

## Open edges

- ~~`go=(no --version)` in PROGS~~ — fixed: per-tool version flag (`go version`); verified `go=go version go1.26.5-X:nodwarf5 linux/amd64` (log 210424)
- json-stream trace format: summary parse not implemented (newline-delimited, same gap as perfetto)
- Perfetto/protobuf summary parsing: deferred — honest note emitted instead
- 10 synthetic fixtures + wrapper + fixtures uncommitted (git status: 74 dirty files)

## Todo state

All tasks completed per task-todo/bitacora-log-tracing.md (23 tasks incl. trace toolchain). Open edges recorded above (5, all non-blocking).

## Follow-up: bug-tracing .sh toolchain (same session)

Three tracers in `_sandbox/`, each distinct:

| Script | Mechanism | Output | Nested under bitacora |
|---|---|---|---|
| `trace-bug.sh` | L1 xtrace + L2 DEBUG trap + L3 tracexec | buffered report | L3 defers (EPERM guard via BITACORA_SELF_TRACED) |
| `trace-stream.sh` | xtrace + DEBUG trap | live stdout, --file tee | works (no own tracexec) |
| `trace-live.sh` | per-command timing via DEBUG trap | live stdout `step:Ns|cmd` | works |

**Key technical finding**: DEBUG traps do NOT cross shell process boundaries — `sh -c` and even `bash -T script.sh` spawn new shells that lose the parent's trap. Fix: BASH_ENV injection — bash sources `$BASH_ENV` before any non-interactive script, so a temp env file installing the DEBUG trap runs INSIDE the traced script's shell. Verified: `step:1s|sleep 1` etc. appear for the script's own commands.

**Bug fixture**: `_sandbox/buggy-script.sh` — `missing_command`, `ls /nonexistent-dir` (errors swallowed by 2>/dev/null), `exit 0` masks failures. All tracers surface the pattern.

**Composition verified**: all 3 tracers + bitacora-log.sh — provenance header + live stream + EXEC genealogy + SHA in one log each (trace-bug: 210058, trace-stream: 210321).

