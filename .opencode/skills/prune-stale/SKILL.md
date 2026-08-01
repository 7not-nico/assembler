---
name: prune-stale
description: Use this skill when removing stale DB entries — it finds entries with no corresponding source file after renames or deletions and removes them
state-profile: stateful-writer
related: ["SKL.STAGE.CREATE"]
patterns: ["PAT.META.ENTITY.LIFECYCLE"]
---
**Procedure**

When cleaning up after a rename or deletion:

1. Inventory — for each entity type, list all DB entries via `read-selection --limit 999`
2. Compare — for each DB entry, check if the corresponding source file exists
3. Report — list stale entries (DB row exists, file absent) by type
4. Confirm — if stale entries found, propose removal to the user
5. Execute — for each confirmed stale entry, delete the DB row and verify 404 via `read-projection`
6. Summary — report count of entries pruned per type

**Gotchas**

- Confirm file absence before DB deletion — double-check paths. Row deletion with existing file excluded
- `write-sync` is append-only — stale entry cleanup excluded. This skill fills that gap
- Terms use lowercase `{id}.md` in filename; skills use `{name}/SKILL.md` directory pattern — check paths carefully
- After pruning, run `write-sync` for the affected type to ensure consistency
- The reverse direction (files without DB entries) is resolved by running `write-sync` — no separate detection needed

**Rules**

- Require user confirmation before any deletion — propose to user, wait for approval, then execute
- Verify file absence before DB deletion — double-check paths
- Report proposed deletions before executing
- Confirm 404 on `read-projection` after each deletion
