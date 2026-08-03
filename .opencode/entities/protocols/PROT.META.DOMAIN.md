---
id: PROT.META.DOMAIN
title: "Protocol Domain Convention"
source: NEX.META.PROPOSAL
related: []
summary: "Every protocol must declare its enforcement domain in its ID. Domains are drawn from a canonical set. Rules are specific, generalized, and example-free."
protocol: "Protocol ID follows PROT.{DOMAIN}.{TOPIC}. DOMAIN drawn from canonical set. Rules state principles without concrete examples. Body passes LLM spec audit before sync."
enforcement: Accord
status: active
priority: 1
tags: [meta, protocol, convention, naming]
---

Every protocol belongs to one enforcement domain. The domain is the first segment after `PROT.`.

## Protocol

1. **Domain prefix required** — first segment after `PROT.` names enforcement layer. Domain must be one of: `ABSTRACTION`, `APOLOGIA`, `COGNITION`, `COMMAND`, `CONCEPT`, `CONTENT`, `DEFINITION`, `ILLUSTRATION`, `INVESTIGATION`, `LIB`, `LINGUISTIC`, `MCP`, `META`, `MAXIM`, `PATTERN`, `PERSON`, `PLUGIN`, `RULE`, `SCHEMA`, `SEARCH`, `SKILL`, `TERM`, `TOOL`.

2. **Rules state principles** — each numbered rule is an actionable directive. Vague or aspirational language excluded.

3. **No concrete examples in rules** — parenthetical illustrations, sample values, and specific instances excluded. Principle alone must be self-evident.

4. **LLM spec compliance required before sync** — protocol body must pass the LLM spec contract at 100/100.

5. **Examples deferred to gotchas** — concrete antipatterns and redirects belong in the gotchas table only.

## Gotchas

- `PROT.DB.SCHEMA` instead of `PROT.SCHEMA.DB.SCHEMA`: Use `SCHEMA` — conventions about schema structure (Domain outside canonical set)
- Example inside a numbered rule: Move instance to gotchas table (Parenthetical instance or sample value)
- Rule with vague language: Replace with actionable directive (Aspirational wording, lacking actionable directive)
- Spec audit below 100: Fix violations before sync (Violation from spec audit)
- Domain prefix omitted: Insert domain: `PROT.{DOMAIN}.{TOPIC}` (ID starts with `PROT.{TOPIC}` with no domain)
- Two domains for one protocol: Pick the enforcement domain; subject area irrelevant (ID includes multiple domain segments)
- `CONTENT` protocol absent: Create `PROT.CONTENT.{TOPIC}` — governs visible documentation conventions (Project `.md` files outside `.opencode` lack governance)

## Enforcement

Code review. The domain prefix is validated against the canonical set. Rules are checked for concrete examples. The LLM spec contract runs before each sync.

## Applicability

All protocol files within the AMANDA assembler ecosystem — every `.md` file in `.opencode/protocols/`.

## See also

- `PROT.META.DOMAIN` — this protocol
