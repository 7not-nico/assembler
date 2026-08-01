---
name: prune-stale
description: Remove stale DB entries that no longer have corresponding source files after renames or deletions
state-profile: stateful-writer
related: [SKL.STAGE.CREATE, PAT.ENTITY.LIFECYCLE]
---
**Trigger** — after renaming or deleting any pattern, term, rule, or skill file

**Procedure**

When cleaning up after a rename or deletion:

1. Inventory — for each entity type, list all DB entries via `read-selection --limit 999`
2. Compare — for each DB entry, check if the corresponding source file exists
3. Report — list stale entries (DB row exists, file does not) by type
4. Confirm — if stale entries found, propose removal to the user
5. Execute — for each confirmed stale entry, delete the DB row and verify 404 via `read-projection`
6. Summary — report count of entries pruned per type

**Gotchas**

- Only delete DB rows whose source files have been confirmed absent — never delete a row whose file exists
- `write-sync` is append-only — it does not clean stale entries. This skill fills that gap.
- Terms use lowercase `{id}.md` in filename; skills use `{name}/SKILL.md` directory pattern — check paths carefully
- After pruning, run `write-sync` for the affected type to ensure consistency
- The reverse direction (files without DB entries) is resolved by running `write-sync` — no separate detection needed

**Rules**

- Never delete without user confirmation
- Verify file absence before DB deletion — double-check paths
- Report proposed deletions before executing
- Confirm 404 on `read-projection` after each deletion
