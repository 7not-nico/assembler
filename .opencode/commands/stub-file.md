---
description: Scaffold a content stub .md file with frontmatter or backmatter following patlib format
subtask: true
---

Scaffold a stub for `$ARGUMENTS`

Run from inside a content directory. `question` tool sequentially:

1. **Context** — URL, concept reference, or brief description
2. **Frontmatter or backmatter?** — pattern (frontmatter) or term (backmatter). See `SPEC.ENTITY.DISTINCTION.BOUNDARY` for entity classification.
3. **Entity ID?** — derives filename (lowercase, join with dots, `.md`)

**Frontmatter** — pattern format:

```
---
id: 
title: 
source: {inferred}
tags: {inferred}
node_type: 
---
```

**Backmatter** — term format:

```
{body text}

---
id: 
title: 
source: {inferred}
related: {inferred}
tags: {inferred}
reference: 
---
```
