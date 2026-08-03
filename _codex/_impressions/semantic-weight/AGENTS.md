# semantic-weight — Cross-Region Research Index

Schema-only project (no tool generation). Database-backed reference index for 5 rounds of cross-region linguistic research

## Workflow

- Query the DB via `bun:sqlite` CLI or SQLite browser
- Edit `.md` source files in `sources/`, `fundamentals/`, etc
- Re-run seed to update DB after edits

## Structure

```
semantic-weight/
├── AGENTS.md
└── .opencode/
    ├── manifests/
    │   ├── domain.md
    │   ├── entities.md
    │   └── properties.md
    └── schemas/
        ├── db.sql        # CREATE TABLE statements
        └── seed.sql      # 5 rounds of research data
```

## DB

- Driver: `bun:sqlite`
- File: `semantic-weight.db` (not yet generated)
- Schema: `.opencode/schemas/db.sql`
- Seed: `.opencode/schemas/seed.sql`

## Tables

```text
| Table | Entity | PK | Notes |
|-------|--------|----|-------|
| `regions` | Regions | EN, DE, FR, ES, CN, RU | 6 language regions |
| `fundamentals` | Core concepts | FUND.* | 20 shared across rounds |
| `sources` | Research papers | SRC.REGION.ID | 37 consolidated from 5 rounds |
| `researchers` | Key people | RES.ID | 21 indexed |
| `gaps` | Cross-cutting gaps | GAP.ID | 10 identified |
| `meta_analyses` | Systematic reviews | MA.ID | 0 found |
```

## ID Format

`{TYPE}.{REGION}.{SPECIFIC}` — e.g. `SRC.EN.CARNAP`, `FUND.IRP`, `GAP.NOUNIFY`

## Additive Migration

`ALTER TABLE ADD COLUMN` only — never `DROP` or `DELETE`
