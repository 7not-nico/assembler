---
description: Scan .opencode/tools/*.ts files for // @toolclass annotations and generate tools.md manifest
subtask: true
---

Generate tool manifest for `$ARGUMENTS`

1. Verify tool files exist under `.opencode/tools/` — each must have `// @toolclass <CODE>` at line 1
2. List all `.ts` files under `.opencode/tools/` — exclude `node_modules`
3. For each file, read line 1 — extract class code if it matches `^// @toolclass (RECG|TRNS|GENR|SGNL)$`, flag as unclassified if no annotation found
4. Read the tool's `description` field from the `tool({...})` block for context
5. Generate `.opencode/manifests/tools.md` with the full manifest
6. Report count of classified tools and any unclassified files

**Output**

```yaml
# Tools manifest — generated from `// @toolclass` annotations

tools:
  - name: $TOOL_NAME
    class: $CLASS_CODE
    description: $DESCRIPTION
```

```
{project}/.opencode/
└── manifests/
    └── tools.md
```
