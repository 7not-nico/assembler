# Todo — 20260802-175112 mgba-diagnostics-scripts

Add atomic bash diagnostic scripts to the mGBA dive (`scripts/`) that emit richer keyed debug data in stdout. Each follows the atomic-script contract: one task, args in, keyed `KEY=value` out, stderr diagnostics, non-zero on failure, `set -uo pipefail`.

- [x] Write this todo — timestamped bitacora record (precedes work)
- [x] `inspect-rom.sh` — header forensics: title, code, maker, version, mbc, rom/ram size, dest, checksums, SHA256, size, type
- [x] `survey-roms.sh [gb|gbc|gba]` — inventory sweep: one keyed line per ROM + count
- [x] `probe-runtime.sh {pid}` — live process sample: state, CPU%, RSS, VSZ, threads, elapsed, cmdline
- [x] `check-save.sh {rom}` — save diagnostics: .sav presence/size/mtime, savestate count + newest
- [x] Test each script against real dive data (logged; inspect/survey/probe/check)
- [x] Update the dive AGENTS.md scripts list (7 → 11)
- [x] Write the session report `_codex/_bitacora/task-report/20260802-175112-mgba-diagnostics-scripts.md`
