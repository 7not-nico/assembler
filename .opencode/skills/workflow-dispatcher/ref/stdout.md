# Stdout

**Route** — structure stdout so every pipe consumer extracts maximum value: keyed result lines as the machine contract, diagnostics to stderr, human text separate.

**Target** — load `structure-stdout` before writing or composing scripts whose output feeds another step.

**Notes**

- Emit one keyed result line (`KEY=value`) as the final stdout line — let `tail -1 | cut -d= -f2` parse it.
- Keep stdout machine-clean — stream banners and progress to stderr or a `--verbose` flag.
- Query logs with `rg`, the ripgrep binary — `rg '^KEY=' log` finds the contract.
- Compute derived metrics with `qalc` — raw keys feed it; results cite their source keys.
- Follow `NEX.TOOL.SEQUENCE` for audit-style output — inventory, pass/fail marks, summary, score.
