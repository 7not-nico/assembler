---
id: PAT.LAMBDA.LINGUISTICS
title: Lambda-Linguistics — subject.action Notation Convention
source: assembler
summary: Actions and thoughts expressed as dot-separated subject-verb pairs instead of full prose phrases.
principle: Every action has a single authoritative subject.action representation.
enforcement: Convention
tags: [convention, notation, communication, code-style, writing, naming, rules]
status: active
priority: 2
---

Every action and thought is expressed as `subject.action` instead of a full prose phrase. Single-action references stand alone; multi-step chains use arrow notation: `db.query → file.write → icon.replace`.

## Context

Prose descriptions of actions waste tokens and obscure intent. "The database query runs and then writes to a file" becomes `db.query → file.write`. This is lambda-linguistics — named after the lambda calculus convention of dot-separated method chains. It's used across all AMANDA agent instructions, rules, and commands where action brevity is desired.

## Rules

- Every action must reduce to a single `subject.action` representation
- Multi-step chains use `→` between steps, not prose connectors
- Fall back to single-action references when no chain is needed
- Never mix full prose with lambda-linguistics in the same action reference
- The subject is the entity performing the action; the action is a bare verb
- `db.query → .write → .validate` (domain-zero anaphora) is legal within the same chain

## Applicability

Applies to agent instructions, command files, rule documents, and any communication within the AMANDA project where action brevity is desired. Does not apply to end-user-facing documentation or explanatory prose.

## See also

- TERM.LAMBDA.LINGUISTICS
- rules/domain-zero-anaphora.md
- rules/gapping.md
- rules/expletive-deletion.md
