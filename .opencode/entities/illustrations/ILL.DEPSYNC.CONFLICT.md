---
id: ILL.DEPSYNC.CONFLICT
title: "Dep Sync Resolve — Version Conflict Diagnosis"
source: PROT.LIB.CONTRACT
summary: "Walkthrough of diagnosing and resolving a shared dependency version conflict across nested .opencode/ directories."
illustration: "js-yaml version mismatch between root and subproject .opencode/ causes obscure runtime errors. Parent shadows child. Fix by aligning major versions."
illustrates: [PAT.DEPENDENCY.SYNC.RESOLVE]
tags: depsync,version,conflict,walkthrough,diagnosis,resolution
related: [REF.TOOL.NODE_MODULES.SHARED, REF.LIB.DIRECTORY.LAYER]
---
## Rationale

Root `.opencode/package.json` specifies `js-yaml` v5. A subproject `.opencode/package.json` specifies `js-yaml` v4. Running `write-sync` produces obscure binding errors. Bun resolves modules upward — the root v5 shadows the subproject v4.

## Walkthrough

1. Run the diagnosis command to check which version is actually loaded:

```
bun -e "import {load} from 'js-yaml'; console.log(typeof load)"
```

Output: `function` matches the root specifier. Bun resolves from the subproject directory upward — the parent `node_modules/` wins.

2. Grep both `.opencode/package.json` files for the shared dependency name:

```
grep js-yaml .opencode/package.json subproject/.opencode/package.json
```

The root specifies v5, the subproject specifies v4. Major versions diverge.

3. Choose the correct target version. The root v5 is the correct version — it provides strict YAML 1.2 parsing that matches the project's conventions. The subproject must align upward.

4. Update the subproject `package.json` to match the root major version:

```json
"dependencies": {
  "js-yaml": "^5.0.0"
}
```

5. Delete both lockfiles to clear stale pins. Bun lockfiles pin old versions even after `package.json` edit.

```
rm node_modules/.bun.lock subproject/node_modules/.bun.lock
```

6. Run `bun install` in every affected `.opencode/` directory. Then run `read-validate` to verify the fix.

## Key insight

Parent shadowing is Bun's design — it walks upward through the directory tree. Identical major versions prevent accidental shadowing. Lockfiles pin old versions even after `package.json` edits — delete them before reinstall when versions conflict. Grep both sides before changing any shared dependency.

## See also

- `PAT.DEPENDENCY.SYNC.RESOLVE` — nested dependency sync pattern
- `REF.TOOL.NODE_MODULES.SHARED` — shared node_modules convention
- `REF.LIB.DIRECTORY.LAYER` — library symlink convention
