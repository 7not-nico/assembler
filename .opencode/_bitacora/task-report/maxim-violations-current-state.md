# Maxim Violations — Current State

Which maxims are violated by the current state of the project.

## Violated Maxims

### MAX.ORTHOGONALITY — One Thing Per Tool

| Rule | Status | Details |
|------|--------|---------|
| Each tool does exactly one thing | ⚠️ Partial | `search-vectors.ts` has 3 modes (vector, keyword, hybrid). But it's disabled. |
| Tools import from shared lib only | ✅ | All active tools import from `_lib/` only |
| Adding a tool adds one file | ✅ | All tools are single files |
| Read and write: separate tools | ✅ | RECG (read) vs TRNS (write) separated |

### MAX.DRY — Single Source of Truth

| Rule | Status | Details |
|------|--------|---------|
| Frontmatter is authoritative | ✅ | All entities use frontmatter |
| DB is queryable replica | ✅ | write-sync syncs frontmatter → DB |
| One .md file per entity | ✅ | Each entity is one file |
| No duplicate logic | ⚠️ Violation | 12 `_lib/` modules orphaned but not cleaned up (~716 LOC dead code). The logic is single-source but has no consumers. |

### MAX.CODE.LAYERS — Dependency Rings

| Rule | Status | Details |
|------|--------|---------|
| Lib files declare purity at line 1 | ✅ | All 43 `_lib/` modules have `// purity:` |
| Pure files import from pure only | ✅ | Verified — no IO in pure modules |
| Tools declare @toolclass at line 1 | ✅ | All active tools have it at line 1 |
| Lib imports only from same or inward ring | ⚠️ To verify | Need to check each module's imports against its declared purity |

### MAX.ENTITY.ONTOLOGY — Entity Nature

| Rule | Status | Details |
|------|--------|---------|
| Tools are morphisms (imperative shell) | ✅ | All active tools export `default tool({...})` |
| Objects (lib) are passive | ✅ | `_lib/` modules are imported, never import tools |
| Morphisms compose externally | ✅ | No tool calls another tool internally |
| Dependencies via purity/depends-on | ⚠️ Partial | Some `_lib/` modules may need depends-on updates |

### MAX.STALL.ENGINE — Never Block Runtime

| Rule | Status | Details |
|------|--------|---------|
| Decompose into parallel batches | N/A | No batch operations currently active |
| Runtime responsiveness priority | N/A | Not applicable with all vector tools disabled |

### MAX.SYNC.STALE.CLEANUP

| Rule | Status | Details |
|------|--------|---------|
| Stale rows cleaned on sync | ✅ | write-sync handles stale cleanup |
| No stale data in active tables | ✅ | Verified in reports |

### MAX.CATALYST.FOR.CHANGE — Ship Smallest Useful

| Rule | Status | Details |
|------|--------|---------|
| Ship smallest useful version | ⚠️ Not applied | Created full `search-vectors.ts` (3 modes) instead of shipping keyword-only first |
| 80% today beats 100% next quarter | ❌ Violated | Tools were disabled instead of shipped in minimal plugin-compliant form |

## Unviolated Maxims (Compliant)

| Maxim | Status |
|-------|--------|
| MAX.BROKEN.WINDOW | ✅ Compliant — violations are documented and tracked |
| MAX.ENTITY.DISCERNIBILITY | ✅ Compliant — entity IDs follow naming convention |
| MAX.ENTITY.RECLASSIFY | ✅ Compliant — new ANT.* patterns created for anti-patterns |
| MAX.KNOWLEDGE.CLASSIFICATION | ✅ Compliant |
| MAX.PROGRAMMING.DELIBERATELY | ✅ Compliant |
| MAX.BUN.ONLY | ✅ Compliant |
| MAX.PLAYWRIGHT.STANDARD | ✅ Compliant |
| MAX.PROTOTYPE.TO.LEARN | ✅ Compliant |
| MAX.REFACTOR.EARLY.OFTEN | ⏳ Pending refactoring of audit tools |
| MAX.SAGE.ONLY | ✅ Compliant |
| MAX.STALL.ENGINE | ✅ Compliant (no active batch ops) |
| MAX.BATCH.PROCESS | ✅ Compliant (no active batch ops) |

## Summary

| Status | Count |
|--------|-------|
| Fully compliant | 10 maxims |
| Partial violation | 3 maxims (DRY, ENTITY.ONTOLOGY, CATALYST.FOR.CHANGE) |
| Active violation | 1 maxim (ORTHOGONALITY — search-vectors 3 modes) |
| To verify | 1 maxim (CODE.LAYERS ring imports) |

## Action Items

1. **MAX.ORTHOGONALITY** — Split search-vectors into 3 tools (keyword-search, vector-search, hybrid-search) if revived, or keep as single tool with modes (acceptable per RECG class).
2. **MAX.DRY** — Remove orphaned `_lib/` modules (716 LOC dead code) or mark them for future revival.
3. **MAX.CATALYST.FOR.CHANGE** — Future tool creation: ship keyword-only first, add vector/hybrid later.
4. **MAX.CODE.LAYERS** — Audit all `_lib/` import graphs to verify ring compliance.
