# invariants.md — always-true state predicates

**Layer:** task-invariant/
**Naming:** `{topic}.md` — the predicates that must hold before any trove work.
**Composes with:** `_trove/AGENTS.md` precedence chain (`invariant/` layer).

## Predicates

```
I1  Papers live under {domain}/{subdomain}/ — one PDF per file, no strays
I2  Every catalogued PDF validates as %PDF (magic bytes) at registration
I3  Every findings.db row keys id = domain/subdomain/filename
I4  DB writes run only in functional Ruby (.rb) — bash never touches the DB
I5  arxiv API etiquette: 1 req/3s, single connection, UA present
I6  Bitacora order: todo precedes work, report follows completion
I7  Metadata capture lands in meta.json before registration — fetch decoupled
I8  Files named per convention: arxiv {id}-{slug}.pdf, biorxiv {slug-from-doi}.pdf
```

## Violation signatures

```
V1  PDF in catalog failing `file` / %PDF magic check
V2  Row id diverging from domain/subdomain/filename
V3  sqlite3/bash writing findings.db (DB access outside .rb)
V4  Burst requests to export.arxiv.org ("Rate exceeded." trigger)
V5  Work without task-todo entry, or task without task-report
V6  Registration before meta.json exists
```

## Audit

Semantic drift or `file` sweep checks predicate state. Any violation marks the
work incomplete until restored. Violations discovered feed task-audit/ records.
