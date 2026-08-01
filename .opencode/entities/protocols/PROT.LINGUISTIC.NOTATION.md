---
id: PROT.LINGUISTIC.NOTATION
title: Lambda-Linguistics — subject.verb Notation Convention
source: NEX.META.CANVAS
summary: Actions and thoughts expressed as dot-separated subject-verb pairs instead of full prose phrases.
protocol: Every action has a single authoritative subject.verb representation.
enforcement: Formality
related: []
tags: [convention, notation, communication, code-style, writing, naming, rules]
status: active
priority: 2
---

Every action and thought is expressed as `subject.verb` instead of a full prose phrase. Single-action references stand alone; multi-step chains use arrow notation: `db.query → file.write → icon.replace`.

## Rules

- Every action must reduce to a single `subject.verb` representation
- Multi-step chains use `→` between steps — prose connectors for narrative only
- Fall back to single-action references when no chain is needed
- Stay within one convention per action reference — lambda-linguistics throughout or prose throughout
- The subject is the entity performing the action; the action is a bare verb
- `db.query → .write → .validate` (domain-zero anaphora) is legal within the same chain

## Applicability

Applies to agent instructions, command files, rule documents, and any communication within the AMANDA project where action brevity is desired. Does not apply to end-user-facing documentation or explanatory prose.

## See also

- `ILL.LINGUISTIC.LAMBDA.NOTATION` — walkthrough of converting prose to lambda notation
- `COG.LINGUISTIC.LAMBDA.NOTATION`
- rules/domain-zero-anaphora.md
- rules/gapping.md
- rules/expletive-deletion.md
