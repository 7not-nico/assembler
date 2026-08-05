---
id: PATTERN.RECORD.FIND.SEARCH
title: Record Find Search — Regex Across Kinds, Status Attached
layer: pattern/
purpose: "A find tool scans record names and contents across all kinds by regex, attaching each hit's status — the record set is searchable as one corpus."
naming: record-find-search.md
tags: [pattern, morphism, find, search, regex, record, bitacora]
status: active
---
# RECORD-FIND-SEARCH.md

**Layer:** pattern/
**Naming:** `record-find-search.md` — code morphism, reusable structure.
**Composes with:** `pattern/record-kind-taxonomy.md`; derived from `study/` + `fixture/` proof.

## Morphism

A find tool scans record names and contents across all `task-{kind}/` folders by regex, attaching each hit's status — the entire record set is searchable as one corpus from the bitacora root.

## Structure

```text
find {topic-regex} →
    for folder in task-{audit,plan,reference,report,stdout,survey,todo}:
        for file in folder/*:
            name match OR content match →
                status: todo → ^Status: line
                        report → ^Timestamp: line
                print "{folder} {basename}  [{status}]"
```

Invariant: every record is reachable by name or content; the search spans all kinds in one pass; the status attaches from the record's own metadata line; a no-match run prints nothing and exits clean.

## Verification

Find a topic present in a report body — the report path prints with its timestamp; find a topic present only in a todo name — the todo prints with its status; find a nonexistent topic — no output, clean exit.

## Instance

Root `.opencode/_bitacora/bitacora-find.sh` (2026-08-05) — name+content scan across 7 folders with status extraction; the codex flow has no find tool — an open edge the dive reports reference by hand.
