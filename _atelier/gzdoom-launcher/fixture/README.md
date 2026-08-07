# fixture — gzdoom-launcher regression layer

Component proof before integration. Each fixture proves one behavior offline — no network, no gzdoom launch — and fails loudly (non-zero exit) when the component regresses. Naming follows the canonical form `{action}-{domain}-test.{ext}`; every file carries the header contract (purpose, run, proves).

## Precedence

The launcher chain gains the fixture gate between lint and smoke:

```text
uv format -> ruff check -> fixture -> smoke -> integrity -> launch
```

- `fixture` — the behavior gate: `bash fixture/run.sh` exits 0 only when every fixture passes
- A fixture claim requires a clean `ruff check` in the same session (epub-maker follows the same rule)

## Run

```bash
bash fixture/run.sh                          # all fixtures, aggregate exit
uv run python fixture/scan-iwad-test.py      # one fixture, direct
bash fixture/extract-wads-test.sh            # one bash fixture, direct
```

## Planned fixtures

### launcher.py — Python (import + call the real functions, offline)

```text
scan-iwad-test.py      proves scan() returns only wad/*.wad — non-recursive,
                       wad/custom/ excluded, sorted
scan-map-test.py       proves scan_map() includes doom1-tmp/ + doom2-tmp/
                       case-insensitively (.wad/.WAD) plus permanent map/*.wad
scan-mods-test.py      proves scan_mods() collects .pk3/.zip/.rar archives
                       and directories under mod/, sorted
command-build-test.py  proves the gzdoom command line: /opt/gzdoom/gzdoom
                       preference, -iwad, -file per selection, -savedir;
                       --dry-run prints the exact line
```

### script/wad-downloader + schema — bash (offline sample inputs)

```text
extract-wads-test.sh   proves the extraction helper moves any-case .wad
                       entries (e1m8b.wad, HOOVER.WAD) from a sample zip
                       into the target dir; errors on a zip with no .wad
probe-header-test.sh   proves probe-header.sh emits HEADER=PWAD|IWAD from
                       sample zips and fails on a zip without a .wad
append-upsert-test.sh  proves schema protocols on a scratch WADS_DB:
                       append APPENDED=1, dup guard exit 1, upsert
                       MODE=updated|inserted, 15 rows / 15 distinct urls
```

### epub-maker — existing

```text
run_tests.py           already the epub-maker fixture gate (8 tests over
                       fixture/sample/); referenced, not duplicated here
```

## Sample data

`fixture/sample/` holds offline inputs built by the fixtures themselves (`fixture/build-sample.sh` or inline):
a PWAD zip (wad + txt), an IWAD zip, an uppercase-.WAD zip (HOOVER.WAD shape), and a no-wad zip.

## Status

- [x] fixture/run.sh — orchestrator (aggregate exit)
- [x] fixture/sample/ — generated sample zips
- [x] scan-iwad-test.py
- [x] scan-map-test.py
- [x] scan-mods-test.py
- [x] command-build-test.py
- [x] extract-wads-test.sh (extraction pulled into the atomic `extract-wads.sh` helper)
- [x] probe-header-test.sh
- [x] append-upsert-test.sh

Last run: `FIXTURES pass=7 fail=0` (30 checks). The suite caught `probe-header.sh` case-sensitivity (HOOVER.WAD missed) — fixed; the fixture gate now guards the any-case `.wad` contract at both layers.
