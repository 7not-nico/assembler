# schema — download registry (wads.db)

One SQLite database registers every WAD download. Mirror of the canonical `.opencode/_schemas/seeds/` pattern: DDL + seed files, `INSERT OR IGNORE` (append) and `INSERT OR REPLACE` (upsert) protocols. Paste the download URL into the `url` column via the scripts.

## Layout

```text
schema/
├── wads.db            sqlite3 database (the live registry)
├── seeds/
│   ├── 00-ddl.sql     DDL — wad_sources (file UNIQUE, url UNIQUE, CHECKs)
│   └── 01-wads.sql    seed — 15 verified downloads, INSERT OR IGNORE
├── scripts/
│   ├── probe-header.sh  extract first .wad, emit HEADER=PWAD|IWAD
│   ├── append.sh        append protocol: INSERT OR IGNORE
│   └── upsert.sh        upsert protocol: INSERT OR REPLACE
└── README.md          this pattern doc
```

## Table

```sql
wad_sources (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  file TEXT NOT NULL UNIQUE,   -- archive name in wad/custom/, the record key
  title TEXT NOT NULL,
  author TEXT,
  game TEXT NOT NULL CHECK(game IN ('doom','doom2','heretic','hexen','strife')),
  kind TEXT NOT NULL DEFAULT 'map' CHECK(kind IN ('map','maps','episode','megawad')),
  size_bytes INTEGER NOT NULL, -- verified archive size on disk
  sha256 TEXT NOT NULL,        -- full archive digest (integrity key)
  date TEXT,                   -- release date MM/DD/YY from the listing
  source TEXT NOT NULL,        -- idgames leaf path (mirror-agnostic)
  url TEXT NOT NULL UNIQUE,    -- full download URL (the paste point)
  header TEXT NOT NULL CHECK(header IN ('PWAD','IWAD')),
  created TEXT NOT NULL DEFAULT (datetime('now')),
  updated TEXT NOT NULL DEFAULT (datetime('now'))
)
```

## Protocols

Both scripts derive `size_bytes`, `sha256`, and `header` from the artifact in `wad/custom/` — never from caller args. `WADS_DB=` and `CUSTOM_DIR=` env overrides relocate the data for scratch tests.

### append — a NEW download

```bash
bash schema/scripts/append.sh <file> <title> <author> <game> <kind> <date> <source> <url>
```

`INSERT OR IGNORE` (append-if-absent). Fails when `file` or `url` already exists — an existing record needs upsert, never a second row.

### upsert — update-or-insert

```bash
bash schema/scripts/upsert.sh <file> <title> <author> <game> <kind> <date> <source> <url>
```

`INSERT OR REPLACE` keyed on `file`. Key present → row replaced (`MODE=updated`); absent → inserted (`MODE=inserted`). Re-running after a re-download refreshes size/sha256 in place.

### probe — header assertion

```bash
bash schema/scripts/probe-header.sh <zip>
```

Extracts the first `.wad`, emits `HEADER=PWAD|IWAD` — the standalone/custom assertion behind both protocols.

## Conventions

- Every row traces to a verified download: `7z t` archive pass + PWAD header probe + sha256 match on disk.
- Every download first runs the acquisition chain (`script/wad-downloader/scripts/download.sh`), then registers here.
- Seeds are additive-only: `INSERT OR IGNORE`/`INSERT OR REPLACE`, never drops (`SPEC.SCHEMA.MIGRATION.AUGMENT`).
- `wad/custom/` loads via `-file`; the launcher never surfaces these as IWADs.
- The TSV seed source (`wads.tsv`) is archived in `schema/.archive/` — the SQL registry supersedes it.

## Current state

- 15 WADs registered; 15 archives in `wad/custom/`, all `7z t` clean, all headers `PWAD`.
- Registry maintained by the wad-downloader project (`script/wad-downloader/AGENTS.md`).
