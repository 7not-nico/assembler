---
description: Scaffold a content stub .md file with frontmatter or backmatter following patlib format
---

Scaffold a content stub for $ARGUMENTS

Run from inside a content directory. Create a single stub `.md` file following the YAML patterns established in assembler projects.

Use the `question` tool sequentially:

1. **Context** — share a link or explain what this stub is for (URL, concept reference, or brief description)
2. **Frontmatter or backmatter?** — entity definition (top `---`) or note/free-form (bottom `---`)?
3. **Entity ID?** — used to derive filename

Derive filename from ID: lowercase all segments, join with dots, append `.md`. Format: `{generality}-{subset}.md`.

Write the stub to the current working directory.

**If frontmatter** — pattern format, fields in this exact order:

```
---
id: 
title: 
source: {inferred}
{inferred}: {inferred}
tags: {inferred}
node_type: 
---

```

**If backmatter** — term format, body text above, metadata below, fields in this exact order:

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

**Voice** — authoritative, concise, present tense, declarative. Bold for format choices, em-dashes for elaboration.
