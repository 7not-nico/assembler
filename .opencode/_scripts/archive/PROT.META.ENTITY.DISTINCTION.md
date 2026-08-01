---
id: PROT.META.ENTITY.DISTINCTION
title: "Entity Distinction — Protocol, Pattern, Maxim, Illustration"
source: NEX.META.ENTITY.PROPOSAL
summary: "Three principle entities (protocol, pattern, maxim) use generalized terms only. Concrete named references belong solely in illustrations."
protocol: "Protocol, pattern, and maxim bodies use generalized terms only. Concrete names, paths, scores, and specific instances belong in the paired illustration."
enforcement: Convention
status: active
priority: 2
tags: [entity, classification, architecture, convention, writing]
related: [PROT.MAXIM.SCHEMA]
---

Three passive principle entity types use generalized terms only. Concrete named references belong in illustrations alone. This protocol covers the PROT/PAT/MAX/ILL boundary.

## Protocol

### Content boundary

1. **Protocol body uses generalized terms only** — plugin names, file paths, scores, and concrete evaluations belong in illustrations.

2. **Pattern body uses generalized terms only** — concrete names, file paths, and specific instances belong in the paired illustration.

3. **Maxim body uses generalized terms only** — concrete examples belong in the paired illustration.

4. **Illustration body names specific entities** — every illustration references at least one concrete file, protocol ID, or code path. An illustration without named references requires reclassification.

5. **Protocol uses `protocol:` frontmatter field** — the single declarative sentence encodes the core contract. Pattern and maxim use `principle:` frontmatter field. Illustration uses `illustration:` and `illustrates:` frontmatter fields.

6. **Same-topic pairs cross-reference in See also** — when a principle entity and its illustration share a domain, each lists the other in See also. The link is bidirectional.

### Decision tree

- Technical contract with enforcement → Protocol
- Design principle with corollary rules → Pattern
- Universal truth with external origin → Maxim
- Concrete walkthrough of a principle entity → Illustration
- Both abstract rules AND concrete examples → Principle entity + Illustration

### Comparison

Protocol: `PROT.*` prefix, `protocol:` field, Contract + enforcement content, excludes concrete examples, body sections (Protocol, Rationale, Gotchas, Enforcement, Applicability), sources `assembler`, enforces via Tool or Convention, may reference ILL.*.
Pattern: `PAT.*` prefix, `principle:` field, Principle + rules content, excludes concrete examples, body sections (Context, Rules, Applicability), sources `assembler`, enforces via Convention, must reference ILL.*.
Maxim: `MAX.*` prefix, `principle:` field, Categorization + corollaries content, excludes concrete examples, body sections (Categorization, Rules, Applicability), sources external (INSP.*), enforces via Convention, must reference ILL.*.
Illustration: `ILL.*` prefix, `illustration:` + `illustrates:` fields, step-by-step content, requires concrete examples, body sections (Context, Walkthrough, Key insight), sources `assembler`, no enforcement, references illustrated entity.

## Gotchas

- Protocol contains concrete plugin name: Move named content to illustration. Keep abstract rule in protocol. ("auto-sync watches term file edits" in body)
- Protocol or pattern contains concrete file path: Move to illustration. Express operation abstractly. (".opencode/plugins/auto-sync.ts" in body)
- Maxim contains concrete name: Move to paired illustration. Maxim body is principle plus corollaries only. (Plugin name, file path, or score in body)
- Illustration lacks named reference: Add at least one concrete name, path, or ID. (Generic walkthrough with zero specific entities)
- Principle entity lacks paired illustration: Create paired illustration to hold the concrete walkthrough. (Pattern or maxim with no ILL.* in See also)

## Enforcement

`entity-audit` (mcp-entity-audit) checks protocol and pattern bodies for concrete plugin names and file paths. Violations indicate content belonging in a paired illustration. Entity IDs (`PAT.*`, `PROT.*`, etc.) in bodies are generalized cross-references — permitted.

`read-validate` confirms frontmatter field matches directory — `protocol:` for PROT.*, `principle:` for PAT.* and MAX.*, `illustration:` for ILL.*.

PRs introducing concrete names to protocol, pattern, or maxim files are flagged for extraction to the paired illustration.

## Applicability

All PROT.*, PAT.*, MAX.*, and ILL.* entities across all projects. The boundary applies to new entity creation and refactoring of existing mixed-content files.

## See also

- `PROT.MAXIM.SCHEMA` — maxim entity schema and no-examples rule
- `TERM.MAXIM` — definition of the maxim entity type
- `REF.META.ENTITY.FRAMEWORK` — executable entity classification
- `REF.META.REFERENCE.AUTHORITY` — entity reference type by entity type
- `ILL.META.DISTINCTION.DECIDE` — decision tree walkthrough for entity type
- `PROT.ILLUSTRATION.SCHEMA` — illustration entity schema
