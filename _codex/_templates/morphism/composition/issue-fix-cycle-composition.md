---
id: MORPHISM.COMPOSITION.ISSUE.FIX.CYCLE
title: Issue-Fix Cycle Composition — Document to Commit
layer: morphism/composition/
purpose: "An issue composes through a fixed cycle: document (todo+reference), backup, fix, test, commit, close — the same six steps every tool fix follows."
naming: issue-fix-cycle-composition.md
tags: [morphism, composition, issue, fix, cycle, backup]
status: active
---
# ISSUE-FIX-CYCLE-COMPOSITION.md

**Layer:** morphism/composition/
**Naming:** `issue-fix-cycle-composition.md` — code morphism, reusable structure.
**Composes with:** `morphism/backup-before-edit.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

An issue composes through a fixed six-step cycle — document (todo + reference), backup, fix, test, commit, close — so every tool fix follows the same recoverable, recorded path.

## Composition

```text
step 1  document  bitacora-todo {topic} + task-reference issue record
step 2  backup    _backup/{ts}-{topic}/  (morphism: backup-before-edit)
step 3  fix       edit the canonical tool — cite the schema, never hardcode
step 4  test      reproduce the original failure + regression cases
step 5  commit    templates:|instantiator: prefix, cite the issue
step 6  close     check the todo items [x] — record the outcome
```

Invariant: documentation precedes the fix; the backup precedes the edit; the test reproduces the original failure before and after; the commit cites the issue; the close marks the record done.

## Verification

Replay any fix from the session: the todo exists, the `_backup/{ts}-{topic}/` restore point exists, the failing case passes after the fix, the commit message names the tool, the todo is `[x]`.

## Instance

The three fixes (2026-08-05) — verify-archive multi-console (`0499a9f`), mGBA log-level (`91a31ee`), browse console valid-list (`8ea2bc5`) — each followed document → backup → fix → test → commit → close with records in `_bitacora/`.
