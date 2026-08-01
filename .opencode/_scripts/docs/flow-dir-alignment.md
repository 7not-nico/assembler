# Directory Path Alignment — Fixing `_lib/paths.ts` vs Actual Entity Dirs

## Problem

`_lib/paths.ts` hardcoded directory names that didn't match the actual `entities/` directory names. This broke `write-sync` for BIO, CHEM, ML, and TAX entity types — the sync tool looked for files in directories that didn't exist.

Earlier workaround created 5 symlinks (`biological→biology`, `chemical→chemistry`, `ml→machine-learning`, `refs→references`, `taxonomy→taxonomies`) to bridge the gap. These were wrong — the fix belongs in `paths.ts`, not in filesystem aliases.

## Survey

`_scripts/survey/dir-path-alignment/s01-audit-dirs.rb` — audits all 26 entity directories against their expected `paths.ts` constant, detecting mismatches and symlinks.

## Fix

### Step 1: Delete 5 symlinks

```bash
rm .opencode/entities/biological
rm .opencode/entities/chemical
rm .opencode/entities/ml
rm .opencode/entities/refs
rm .opencode/entities/taxonomy
```

`refs` was spurious — `paths.ts` already said `"references"` which matched the dir.

### Step 2: Fix 4 lines in `_lib/paths.ts`

| Line | Constant | Before | After |
|------|----------|--------|-------|
| 24 | `BIO_DIR` | `"biological"` | `"biology"` |
| 25 | `CHEM_DIR` | `"chemical"` | `"chemistry"` |
| 41 | `TAXONOMY_DIR` | `"taxonomy"` | `"taxonomies"` |
| 42 | `ML_DIR` | `"ml"` | `"machine-learning"` |

### Step 3: Verify sync

```bash
bun -e "
  const { initDB } = require('./.opencode/_lib/db.ts');
  const { syncAll } = require('./.opencode/_lib/sync.ts');
  const db = initDB();
  const result = syncAll(db, 'all');
  db.close();
  console.log(result);
"
```

Output: `Synced ... 5 bios, 3 taxons, 1 ml entity ...` — paths resolved correctly.

The MCP `write-sync` tool has the old paths cached in process memory. It loads corrected `paths.ts` after session restart.

## Result

All 26 directories under `entities/` are real directories. Zero symlinks. Zero mismatched paths.

| Dir | paths.ts constant | Status |
|-----|-------------------|--------|
| `biology/` | `BIO_DIR` | ✓ |
| `chemistry/` | `CHEM_DIR` | ✓ |
| `machine-learning/` | `ML_DIR` | ✓ |
| `taxonomies/` | `TAXONOMY_DIR` | ✓ |
| `references/` | `REFS_DIR` | ✓ (was already correct) |

## Cross-reference

- `_lib/paths.ts` — hardcoded entity directory paths
- `_lib/sync.ts` — uses paths constants for filesystem scanning
- `_scripts/_rb/paths.rb` — Ruby side uses dynamic `Dir.children` (unaffected)
- `_scripts/survey/dir-path-alignment/s01-audit-dirs.rb` — audit script
