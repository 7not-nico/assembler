**Bootstrap-DB Pipeline** — four-step sequential process for initializing a DB-backed project: domain definition, entity identification, property/schema specification, and optional tool scaffolding. Each step consumes the previous step's output manifest. Steps 1-3 are handled by the bootstrap-db skill; step 4 is handled by the scaffold-tools skill. Step 4 is optional — schema-only projects stop at properties.

---
id: TERM.BOOTSTRAP.PIPELINE
title: Bootstrap-DB Pipeline
source: assembler
tags: [bootstrap, pipeline, scaffolding, schema, workflow]
terms: []
patterns: [PAT.TOOL.GENERATION, PAT.GENERATED.COMPLIANCE]
related: []
reference:
  - title: bootstrap-db skill
    url: file:.opencode/skills/bootstrap-db/SKILL.md
  - title: scaffold-tools skill
    url: file:.opencode/skills/scaffold-tools/SKILL.md
  - title: db-domain command
    url: file:.opencode/commands/db-domain.md
  - title: db-entities command
    url: file:.opencode/commands/db-entities.md
  - title: db-properties command
    url: file:.opencode/commands/db-properties.md
---