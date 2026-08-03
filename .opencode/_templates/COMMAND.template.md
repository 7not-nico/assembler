---
id: TEMPLATE.COMMAND
title: Command Template — Two-File Verb-Domain Bootstrap
layer: commands
purpose: "Bootstraps any command: YAML registry + MD step file, verb-domain naming, guided composition."
naming: "{verb}-{domain}.md + yamls/{verb}-{domain}.yaml"
tags: [template, command, bootstrap, registry]
status: active
---
<!-- Command template — two files per command per PROT.COMMAND.RULE.
     Destination: .opencode/commands/{verb}-{domain}.md AND .opencode/commands/yamls/{verb}-{domain}.yaml.
     ID: CMD.{VERB}.{DOMAIN} — uppercase dot-separated; filename kebab-case, verb segment matches.
     Guided composition per SPEC.DOCUMENT.COMPOSITION.GUIDED — the document prescribes its steps. -->

# {verb}-{domain}.md

---
description: {one-sentence present-tense summary of what the command does}
subtask: true
---

{Verb} for `$ARGUMENTS`

1. {step — one directive, atomic, in execution order}
2. {step — one directive, atomic, in execution order}
3. {step — one directive, atomic, in execution order}
4. {step — one directive, atomic, in execution order}

**Report:** {include only when validation forms part of the workflow}

- PASS — {pass condition}
- WARN — {warn condition}
- FAIL — {fail condition}

# yamls/{verb}-{domain}.yaml

```yaml
id: CMD.{VERB}.{DOMAIN}
title: {Human-Readable Title}
description: {one-sentence summary — matches the step-file description}
source: {PROJECT-NAME}
tags: [{tag1},{tag2},{tag3}]
related: [{ENTITY.ID}]
created: {YYYY-MM-DD}T{HH:MM:SS}.000Z
modified: {YYYY-MM-DD}T{HH:MM:SS}.000Z
```
