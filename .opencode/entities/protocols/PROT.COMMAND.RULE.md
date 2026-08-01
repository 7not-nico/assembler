---
id: PROT.COMMAND.RULE
title: "Command Convention — Verb-Domain Naming and Structure"
source: NEX.TOOL.CHOICE
related: [PROT.META.COMPOSITION]
summary: "Every command follows verb-domain naming (CMD.{VERB}.{DOMAIN}). Commands have two files: a YAML registry in commands/yamls/ for metadata and an .md step file in commands/ for execution steps."
protocol: "Every command must have a YAML registry at commands/yamls/{name}.yaml with fields id, title, description, source, tags, related. Every command must have a step file at commands/{name}.md with frontmatter (description, subtask) and numbered steps."
enforcement: Formality
status: active
priority: 3
tags: [command, convention, naming, structure, workflow]
---

Every command follows verb-domain naming with two-file structure: YAML registry for metadata, .md step file for execution steps.

## Protocol

1. **Follow verb-domain naming** — command IDs use `CMD.{VERB}.{DOMAIN}` format. Examples: `CMD.ANCHOR.WORKFLOW` (verb: anchor, domain: workflow), `CMD.ACQUIRE.ASSET` (verb: acquire, domain: asset). FILE names use kebab-case: `anchor-workflow.md`, `acquire-asset.yaml`.

2. **Maintain a YAML registry** — every command has a registry file at `commands/yamls/{name}.yaml` with fields: `id` (CMD.ID), `title` (human-readable), `description` (one-sentence summary), `source` (project name), `tags` (array, minimum 3), `related` (array of patlib entity IDs), `created` (ISO timestamp), `modified` (ISO timestamp).

3. **Maintain a step file** — every command has an execution file at `commands/{name}.md` with frontmatter (`description:`, `subtask: true`) and a body of numbered steps. Format governed by `format-command` skill.

4. **Register the YAML file base name** — the YAML file name without extension matches the step file name without extension. Both use kebab-case derived from the verb-domain ID: `CMD.CREATE.TERM` → `create-term.yaml` and `create-term.md`.

5. **Commands are guided compositions** — commands prescribe their own execution sequence within the document per the guided composition framework. They belong to the guided composition framework per `REF.META.ENTITY.FRAMEWORK`.

6. **Keep steps atomic** — each step is a single directive. Steps compose sequentially. Step order is execution order.

### Naming rules

- Every command ID must match `CMD.{VERB}.{DOMAIN}` — uppercase dot-separated segments
- Filename must match `{verb}-{domain}.md` — lowercase hyphen-separated
- The first segment of the ID (verb) must match the first segment of the filename (verb)
- `x`/`z` prefixes concatenate to their segment — one unit per combined prefix+segment
- Repeated domain segments collapse into acronyms
- Source is always `assembler` for first-party commands
- `SKL.AUDIT.COMMAND` enforces this convention — run it after creating any command

## Gotchas

- Command missing YAML registry: Create YAML registry with all required fields (`commands/yamls/` has no file matching a `commands/*.md` file)
- Command missing step file: Create step file with frontmatter and numbered steps (`commands/*.md` has no file matching a `commands/yamls/*.yaml` file)
- YAML registry missing required field: Add all required fields (Fields absent from id, title, description, source, tags)
- YAML registry and step file name mismatch: Rename one to match — YAML and .md FILE names must match (`create-term.yaml` paired with `create-term.md` (correct); `create-term.yaml` paired with `new-term.md` (incorrect))
- Step file body contains prose paragraphs instead of numbered steps: Convert to numbered steps per `format-command` skill (Body uses `##` headers or paragraphs)

## Applicability

All commands in `.opencode/commands/` and `.opencode/commands/yamls/` across root and subproject levels.

## Enforcement

`read-validate` verifies YAML registry fields and step file structure. `audit-command` (when available) verifies verb-domain naming, two-file pairing, and format compliance.

## See also

- `REF.META.ENTITY.FRAMEWORK` — entity framework classification
- `PROT.META.COMPOSITION` — document composition pattern
- `format-command` — skill for formatting command step files
- `PROT.SKILL.PROFILE` — state classification for skills (sister protocol)
