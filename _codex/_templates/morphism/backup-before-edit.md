---
id: MORPHISM.BACKUP.BEFORE.EDIT
title: Backup Before Edit — Timestamped Restore Point
layer: morphism/
purpose: "Before any edit, copy the originals into _backup/{YYYYMMDD}-{HHMMSS}-{topic}/ — the pre-edit state is a named, dated restore point the chain's backup layer realizes."
naming: backup-before-edit.md
tags: [morphism, backup, restore, edit, timestamp]
status: active
---
# BACKUP-BEFORE-EDIT.md

**Layer:** morphism/
**Naming:** `backup-before-edit.md` — code morphism, reusable structure.
**Composes with:** `morphism/close-report-handoff.md`; derived from `study/` + `fixture/` proof.

## Morphism

Before any edit, the original files copy into `_backup/{YYYYMMDD}-{HHMMSS}-{topic}/` — a named, dated restore point that realizes the chain's backup layer: the pre-edit state is recoverable, and a failed edit reverts to the exact original.

## Structure

```text
TS=$(date +%Y%m%d-%H%M%S)
mkdir -p "_backup/$TS-{topic}"
cp -a {files...} "_backup/$TS-{topic}/"
# ... edit ...
# on failure: cp -a "_backup/$TS-{topic}/" back
```

Invariant: the backup precedes the edit; the dir names the topic and the timestamp; the copy is verbatim (cp -a); a mangled edit reverts from the restore point — never from memory.

## Verification

Back up, edit, and deliberately corrupt a file — the restore point returns the exact pre-edit bytes; the timestamp distinguishes successive backups of the same files; the backup lives under `_backup/` beside the tree.

## Instance

The session's fixes (2026-08-05) — 5 restore points: shell-refactor, mcp-verify-fix, mgba-trace-fix, browse-console, shell-schema. The sed-mangled citation paths were restored from `20260805-151257-shell-schema` and re-applied cleanly — the backup caught a real failure.
