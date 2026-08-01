---
id: ILL.COMMAND.WORKFLOW
title: "Command Registry — YAML and Step File Creation"
source: PROT.COMMAND.RULE
summary: "Walkthrough of creating a new command with verb-domain naming — YAML registry for metadata, .md step file for execution steps."
illustration: "A new validate-terms command follows verb-domain naming: CMD.VALIDATE.TERMS. Two files: validate-terms.yaml (registry) and validate-terms.md (steps)."
illustrates: [PROT.COMMAND.RULE]
tags: command,registry,walkthrough,workflow,yaml
related: [PROT.COMMAND.RULE, REF.META.NAMING.SCHEMA]
---
## Rationale

Inconsistent command naming (domain-verb, verb-domain, domain-noun, single-word) makes commands unpredictable. Verb-domain ordering establishes a single pattern — action before subject — so every command reads as "do this to that." `CMD.{VERB}.{DOMAIN}` and `{verb}-{domain}.md` ensure ID and filename are discoverable from either angle.

The system needs a command to validate term files for structural compliance. The command follows the verb-domain convention: verb = validate, domain = terms. ID: `CMD.VALIDATE.TERMS`.

## Walkthrough

1. Infer verb and domain from the task. Verb: `validate`. Domain: `terms`. ID: `CMD.VALIDATE.TERMS`.

2. Create the YAML registry at `commands/yamls/validate-terms.yaml`:

```yaml
id: CMD.VALIDATE.TERMS
title: Validate Terms
description: Validate term files for structural compliance
source: assembler
tags: [validate, terms, compliance, audit, workflow]
related: [SKL.AUDIT.TERM, PROT.TERM.SCHEMA]
created: 2026-07-21T000000.000Z
modified: 2026-07-21T000000.000Z
```

3. Create the step file at `commands/validate-terms.md`:

```md
---
description: Validate term files for structural compliance
subtask: true
---

Validate terms for `$ARGUMENTS`

1. Run `read-validate` to check all term files for structural compliance
2. Report violations with file path and field name
3. Exit with non-zero code if any violations found
```

4. Verify the YAML file name without extension matches the step file name — both use `validate-terms`. Run `write-sync commands` to register the command in patlib.

## Key insight

The verb-domain naming convention makes the command discoverable from either angle — find all "validate" commands, or find all "terms" domain commands. The two-file separation keeps metadata parseable and steps readable. YAML for tool consumption; markdown for agent reading.

## See also

- `PROT.COMMAND.RULE` — verb-domain naming convention
- `PROT.COMMAND.RULE` — abstract command conventions
- `REF.META.NAMING.SCHEMA` — naming convention
- `SKL.FORMAT.COMMAND` — command step file formatting
