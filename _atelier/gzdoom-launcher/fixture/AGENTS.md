# AMANDA gzdoom-launcher fixture — Agent Instructions

## Identity

- serves as the agent instruction file for the launcher fixture layer
- instantiates the regression gate under `_atelier/gzdoom-launcher/fixture/`
- states final absolute states per `RUL.AGENTS.STATE`

## Domain

This layer proves launcher behavior offline before smoke/integrity/launch.
No network, no gzdoom launch: every fixture exercises one component against
live layout or generated samples and fails loudly on regression.

## Structure

- `run.sh` — the aggregate gate; builds samples, runs all 7 fixtures, exit 0 only when every fixture passes
- `scan-iwad-test.py` / `scan-map-test.py` / `scan-mods-test.py` / `command-build-test.py` — launcher.py behavior fixtures (uv run python)
- `extract-wads-test.sh` / `probe-header-test.sh` / `append-upsert-test.sh` — bash fixtures over the wad-downloader + schema tooling
- `sample/build.sh` — regenerates the 4 offline sample zips (pwad, iwad, uppercase .WAD, no-wad); idempotent

## Runtime

```bash
bash fixture/run.sh
uv run python fixture/scan-iwad-test.py
bash fixture/probe-header-test.sh
```

## Precedence

```text
uv format -> ruff check -> fixture -> smoke -> integrity -> launch
```

- `fixture` — the behavior gate; a passing run.sh is required before smoke claims
- a fixture claim requires a clean `ruff check` in the same session

## Integrity

- every fixture exits non-zero on any failed check; run.sh aggregates pass/fail counts
- sample zips are generated (git-ignored), never committed
- fixtures prove the case-insensitive .wad contract at both layers (probe-header, extract-wads, scan_map)
