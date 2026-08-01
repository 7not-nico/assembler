---
id: ILL.PROTOCOL.STRUCTURE
title: "Protocol File Structure — Frontmatter, Body, Abstract Rules"
source: PROT.META.IDENTITY
summary: "Walkthrough of creating a new protocol file using PROT.META.IDENTITY frontmatter fields, body sections, and content rules."
illustration: "A new protocol PROT.LIB.CACHE.POLICY uses 9 frontmatter fields with correct formats, 5 body sections (Protocol, Gotchas, Enforcement, Applicability, See also), all rules per PROT.META.IDENTITY."
illustrates: [PROT.META.IDENTITY]
tags: protocol,walkthrough,schema,frontmatter,structure
related: [PROT.META.IDENTITY, REF.META.NAMING.SCHEMA]
---
## Rationale

A new protocol `PROT.LIB.CACHE.POLICY` follows PROT.META.IDENTITY structure: 9 frontmatter fields, 5 body sections, content rules.

## Walkthrough

### Step 1: Frontmatter fields

Every protocol uses these fields:

```yaml
---
id: PROT.LIB.CACHE.POLICY
title: "Cache Policy — TTL-Based Invalidation Convention"
source: assembler
summary: "One-sentence description of the cache policy contract."
protocol: "Every cached value carries a TTL annotation. Readers check TTL before serving cached data. Writers set TTL on write."
enforcement: Tool
status: active
priority: 3
tags: [cache, policy, lib, convention, performance, ttl]
---
```

| Field | Value | Rule applied |
|-------|-------|-------------|
| `id` | `PROT.LIB.CACHE.POLICY` | `PROT.{DOMAIN}.{NAME}` uppercase dot-separated |
| `title` | `"Cache Policy..."` | `"Name — Subtitle"` with em-dash |
| `source` | `assembler` | First-party |
| `summary` | One sentence | Single concise description |
| `protocol` | Declarative contract | Three sentences, positive instructions |
| `enforcement` | `Tool` | One of Tool, Convention, or Review |
| `status` | `active` | One of active, draft, deprecated |
| `priority` | `3` | Integer 1–5 |
| `tags` | `[cache, policy, ...]` | Inline array, 3+ tags |

### Step 2: Body sections

Six standard sections in this order:

```
## Protocol     — Positive instructions, schema, scope narrowing
## Rationale    — Design reasoning
## Gotchas      — Antipatterns paired with positive redirects (recommended)
## Enforcement  — Out-of-prompt compliance
## Applicability — When this applies + scope boundaries
## See also     — Related entities
```

### Step 3: Content requirements

- Protocol section uses predominantly positive instructions (3:1 positive ratio per PROT.LLM.SPECIFICATION)
- Gotchas pairs every violation with a positive redirect
- Enforcement moves deterministic checks out of prompt into a tool
- Tags use inline array `[tag1, tag2, tag3]` with comma separators
- Protocol body states general contracts; concrete named references belong in paired illustrations

### Step 4: Abstract rules redirect

Abstract governance rules (frontmatter purpose, LLM spec compliance, body section rationale) are delegated to `PROT.META.IDENTITY`. This pattern documents concrete field values and formats.

## Key insight

A protocol file carries two layers of rules: concrete field formats (this pattern) and abstract governance (PROT.META.IDENTITY). The split keeps the concrete reference focused on exact values, while the abstract layer covers when and why. Both patterns are referenced in every new protocol PR.

## See also

- `PROT.META.IDENTITY` — the protocol identity pattern this illustrates
- `PROT.META.IDENTITY` — abstract governance rules for protocols
- `REF.META.NAMING.SCHEMA` — naming convention for protocol IDs
- `PROT.LLM.SPECIFICATION` — contract + gotcha framing rules
