# tracexec-fidelity-fix

Timestamp: 2026-08-03 20260803-133605

## What was done

- Verified `reference/tracexec.md` top-level help citation against live `tracexec --help` — **exact match** (`tracexec-help-fidelity3`).
- Detected the log-mode citation was hand-condensed (options rewrapped to single lines) instead of verbatim — fidelity gap found by line-set comparison (`tracexec-log-fidelity`).
- Rewrote the log-mode citation block in `reference/tracexec.md` to the true verbatim two-line format from live `tracexec log --help` — full option set including `--no-*` variants, experimental `--fd-in-cmdline`/`--stdio-in-cmdline`, `--inline-timestamp-format`, `--seccomp-bpf`, `--polling-interval`, filters, `-o, --output`, `-h, --help`. Reference now 172 lines.
- Re-verified: `FIDELITY: exact match — log-mode citation = live tracexec log --help` (`tracexec-log-fidelity-final`).
- Cleaned temp files: fidelity-check.rb, live captures removed (`fidelity-cleanup`).
- Closed todo `2026-08-03--tracexec-fidelity-fix.md`.

## Decisions

- Verbatim citations must be byte-exact — condensed/rewrapped quotes fail the fidelity bar for the reference layer.
- Line-set comparison over regex extraction — simpler and robust against shell quoting.

## Open edges

- None — both citation blocks in `reference/tracexec.md` are now byte-verbatim against live tool output.

## Todo state

- [x] verify top-level help citation vs live (exact match)
- [x] detect log-mode citation not verbatim
- [x] rewrite log-mode citation verbatim
- [x] re-verify fidelity — both blocks exact
- [x] clean temp files
- [x] close todo, write report

Logs: `bitacora-fidelity-todo`, `tracexec-help-fidelity3`, `tracexec-log-fidelity`, `tracexec-log-fidelity-final`, `fidelity-cleanup`, `bitacora-fidelity-close` → `_knowledge/_bitacora/task-stdout/`.
