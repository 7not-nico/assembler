# bin-go — STATUS: the romsfun toolchain ported to Go

Go r3 port of the romsfun instantiator. The root bash tools are the
behavioral base; every hardcoded value cites `schema/seed.sql` (embedded,
never read from disk). Browse and fetch delegate to the canonical bash
tools (playwright-core has no Go driver); verify, launch, stop, trace are
native Go.

## Done — modules complete and build-verified

| Module | File | Responsibility | Verified |
|---|---|---|---|
| module | `go.mod` | module romsfun, go 1.26.5 | build ok |
| seed | `schema/seed.sql` | constants (single home, incl. TRACE_PATTERNS) | copied from root |
| schema | `schema.go` | `Store`, embedded parse, `value`/`integer` fail-loudly | seed cited |
| core | `core.go` | `validConsole`, `consoles`, `slugify`, `isImage` | n/a |
| text | `text.go` | `split` (single word-walker home) | n/a |
| probe | `probe.go` | `run`, `stream`, `read`, `size`, `typeOf`, `executable` | n/a |
| archive | `archive.go` | `kind`, `bareAcceptable`, `imagePattern`, `firstImage`, `sizeInArchive` | zip stdlib verified |
| browser | `browser.go` | `assertReady` (native CDP probe), `port` (env override) | 200 live |
| process | `process.go` | `spawn` (Setsid, zombie-aware health), `halt` (/proc sweep) | RUN + STOPPED=1 |
| trace | `trace.go` | `patterns`, `loadPatterns`, `mine` (keyed lines) | matches bash |
| io | `io.go` | six ops, keyed lines, `root()` exe-resolve, restart hint | all six pass |
| entry | `main.go` | subcommand dispatch, usage (exit 2) | ok |

Build chain: `gofmt -w *.go` → `go vet ./...` → `go build -o romsfun .`
— all clean. Binary gitignored (`/romsfun`).

## Verification evidence

| Case | Command | Result |
|---|---|---|
| zip verify | `romsfun verify …/mega-man-zero-2-usa.zip` | `OK Mega Man Zero 2 (USA).gba (8388608 B)`, `SIZE=8388608`, exit 0 |
| bare gba | `romsfun verify "/tmp/opencode/mmz2/Mega Man Zero 2 (USA).gba"` | `OK bare image`, 8388608 B |
| bare sfc | `romsfun verify "…/Super Mario - Yossy Island (Japan).sfc"` | `OK bare image`, 2097152 B |
| ext override | `verify … --image-ext nds` | `ERROR no image inside archive (expected .nds)`, exit 1 |
| trace | `romsfun trace /tmp/trace-test.log` | `LINES=6`, EVIDENCE 1/3/4/6, `DONE 6 lines, 15 patterns` — matches bash |
| trace real | `romsfun trace /tmp/opencode/snes9x-trace.log --head 3` | `LINES=18`, head-limited |
| launch run | `launch /usr/bin/tail /tmp/trace-test.log --emu-arg -f` | `RUN pid=…`, then `stop tail` → `STOPPED=1` |
| launch fail | `launch /usr/bin/true …` | `FAIL emulator exited early`, exit 1 |
| stop idle | `romsfun stop tail` | `no tail running`, `STOPPED=0`, exit 0 |
| browse live | `browse "mega man zero 2" game-boy-advance` | `SEARCH`/`GAME`×4/`OPEN`/`DL`/`VARIANTS:` 1–4, exit 0 |
| invalid console | `browse zelda not-a-console` | `ERROR invalid console` + valid list, exit 1 |
| usage | `verify` / `bogus` | usage + exit 2 |
| cwd-independence | run from `/tmp` | same output |

## Not done — remaining edges

| Item | Notes |
|---|---|
| fetch live test | delegation untested against a real download URL (browser ready, script proven) |
| real-emulator launch | smoke used `tail -f` as stand-in; `/usr/bin/mgba` + GBA rom ready for a real boot |
| commit | `bin-c/`, `bin/` (Python), `bin-typescrypt/` also uncommitted; nothing committed this session |
| base fix | `deps/paths.sh` depth corrected `../../_shared/bin` → `../../../_shared/bin` (stale since `instantiator/` subfolder; unblocks browse/fetch/acquire toolchain-wide) — not yet committed |

## How to finish

1. `go build -o romsfun .` (already clean); run fetch live + a real mgba
   boot when convenient.
2. `git add bin-go/ …; git commit` — include the `paths.sh` depth fix.
