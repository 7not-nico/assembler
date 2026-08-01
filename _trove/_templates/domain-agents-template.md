# AMANDA {domain}/{subdomain} — Agent Instructions

## Domain

This project acquires and catalogues {domain} papers — {one-sentence domain}. The project downloads PDFs, captures metadata, registers them in `findings.db`, and documents the work.

## Structure

- `{domain}/{subdomain}/` holds the catalog — one validated PDF per file, `{slug}.pdf` naming (arxiv `{arxiv-id}-{slug}.pdf`, biorxiv `{slug-from-doi}.pdf`), `meta.json` beside the PDFs.
- `_trove/_scripts/` holds atomic tooling — bash for acquisition, functional Ruby for DB.
- `_trove/_bitacora/` holds the record — `task-todo/` (todo first), `task-report/` (report after), `task-invariant/` (predicates), `task-fixture/` (harnesses), `task-stdout/` (command logs via `run-logged.sh`).
- `_trove/_templates/` holds the bootstrap + improvement loop — read before work; `report/` records session errors and findings.

## Precedence chain — obligatory

The project advances through the trove chain in order:

```text
invariant/ → _templates/ → _bitacora/ → _scripts/ → {domain}/{subdomain}/ → .opencode/
```

- `invariant/` — always-true catalog predicates + violation signatures (PDF `%PDF`, row keying `domain/subdomain/filename`, Ruby-only DB writes, 1 req/3s etiquette). Outermost.
- `_templates/` — bootstrap + improvement loop. Precedes the record.
- `_bitacora/` — the record. Todo first, report after.
- `_scripts/` — atomic acquisition tools. Bash performs acquisition; functional Ruby performs DB interaction.
- `{domain}/{subdomain}/` — the catalog. One validated PDF per file.
- `.opencode/` — the TS/MCP toolchain. Innermost; carries its own AGENTS.md.

Violating the order — acquiring without reading the templates, skipping the bitacora todo, writing the DB from bash, registering an unvalidated PDF, keying rows outside `domain/subdomain/filename` — marks the work incomplete.

## Records

Every session writes bitacora files. The todo precedes work; the report follows completion; every command output flows through `run-logged.sh {name} -- {command}` into `_bitacora/task-stdout/`. Knowledge lands in its layer: invariant (state fact) → fixture (proof) → study (architecture) → report (record). Templates live in `_trove/_templates/`.

## Delegation

This project owns the {domain} acquisition: {sources, subdomain scope, verification}.
