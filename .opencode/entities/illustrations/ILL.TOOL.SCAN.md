---
id: ILL.TOOL.SCAN
title: "Audit Procedure — Inventory, Validate, Cross-Reference, Report"
source: PROT.TOOL.DEFINITION
summary: "Walkthrough of running an audit on a pattern file: inventory all pattern files, validate frontmatter fields, check cross-references resolve, detect duplicate IDs, report violations per file."
illustration: "An audit-pattern run inventories 38 .md files, checks each for required fields (id, title, summary, principle, tags), resolves cross-references against patlib.db, detects zero duplicates, reports 1 violation in a file with missing tags."
illustrates: [NEX.TOOL.SEQUENCE]
tags: audit,walkthrough,validation,procedure,workflow
related: [PAT.META.ENTITY.LIFECYCLE]
---
## Rationale

Every entity type needs validation independent of runtime behavior. The audit sequence is uniform — inventory, check fields, verify cross-references, detect duplicates, report per-entity violations, summarize with score — adapting only the specific field checks per entity type.

An `audit-pattern` run checks all 38 pattern files for structural compliance. The audit procedure follows five uniform steps: inventory, structural checks, cross-reference check, duplicate check, report.

## Walkthrough

### Step 1: Inventory

Enumerate all `PAT.*.md` files in `.opencode/patterns/`. Result: 38 files found.

```
$ ls .opencode/patterns/*.md | wc -l
38
```

### Step 2: Structural checks per file

For each of the 38 files, validate required fields:

```yaml
file: PAT.NEW.CONVENTION.md
- id: present ✓
- title: present ✓
- summary: present ✓
- principle: present ✓
- tags: MISSING ✗
- status: present ✓
- priority: present ✓
```

One violation found: `PAT.NEW.CONVENTION.md` has a missing `tags:` field.

### Step 3: Cross-reference check

Extract all entity IDs from each file's `related:` and `## See also` sections. Resolve each against `patlib.db`:

```
PAT.NEW.CONVENTION.md references:
  - REF.META.NAMING.SCHEMA → FOUND ✓
  - PROT.META.DOMAIN → FOUND ✓
  - REF.META.RENAME.REGISTRY → FOUND ✓
  - TERM.NONEXISTENT → MISSING ✗
```

One unresolved reference found: `TERM.NONEXISTENT` has no matching entity.

### Step 4: Duplicate ID detection

Query all pattern IDs from the DB. Check for duplicates:

```
SELECT id, COUNT(*) as c FROM patterns GROUP BY id HAVING c > 1
→ zero rows returned ✓
```

Zero duplicates detected across all entity types.

### Step 5: Report and summarize

```
Audit complete: patterns
  Files scanned: 38
  Field violations: 1 (PAT.NEW.CONVENTION.md: missing tags)
  Cross-reference violations: 1 (TERM.NONEXISTENT unresolved)
  Duplicate IDs: 0
  Score: 36/38 files clean (94.7%)
  Result: PASS (threshold 80%)
```

Each violation is reported with `file:line` format. The summary provides pass/fail count and compliance score.

## Audit sequence diagram

```
Inventory ──▶ Structural checks ──▶ Cross-reference ──▶ Duplicate check ──▶ Report
   │               │                     │                   │               │
   └── 38 files    └── 1 violation       └── 1 unresolved   └── 0 dups     └── 94.7%
```

## Key insight

The audit sequence is identical across all entity types. Only the field validations differ per type. The six audit skills (audit-pattern, audit-term, audit-tool, etc.) implement the same template with type-specific field checks. Every audit produces a per-entity violation list and a summary compliance score.

## See also

- `NEX.TOOL.SEQUENCE` — the audit procedure this illustrates
- `PAT.META.ENTITY.LIFECYCLE` — audit transitions CONFIRMED to DIRTY
- `audit-pattern`, `audit-term`, `audit-rule`, `audit-tool`, `audit-skill`, `audit-term` — existing audit skills
