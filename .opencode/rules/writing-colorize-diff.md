Each proposed change presents as a rule with description, scope, composes with, and a colorized diff block.

Scope: block-level. Applies to every proposed change during review.

Format:

```c
**{Entity}** — {brief description of change}

**Description:** {what changes and why}
**Scope:** {file:line-range}
**Composes with:** {reference IDs governing this change}

```
```diff
-before line
+after line
```

Composes with `RUL.WRITING.CONVENTION` — one of 22 writing conventions.
