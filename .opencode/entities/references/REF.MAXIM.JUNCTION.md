---
id: REF.MAXIM.JUNCTION
title: "Line-Junction Notation — Semantics and Application"
source: PROT.MAXIM.SCHEMA
related: [REF.META.NAMING.SCHEMA, REF.META.ENTITY.FRAMEWORK]
ref: "Every line in a categorization section is a junction. `-` marks emphasis; `,` qualifies; `;` exempts. Line order encodes derivation chain. These conventions compose structural meaning directly into line layout."
tags: [maxim, notation, line-semantics, convention]
---

Every line in a maxim categorization section is a junction. Four notational choices convey structural semantics: `-` for emphasis, `;` for exception, `,` for qualification, and ordinal line order for precedence.

## Rationale

Structural-preference (`RUL.WRITING.CONVENTION`) prefers structured formats for multi-element content. Line-junction notation encodes relational semantics — emphasis, exception, qualification, precedence — directly into formatting. Formatting replaces explanatory prose for relationships the structure already expresses.

The `-` emphasis marker replaces generic list bullets with a semantic affordance. The `;` exception marker exempts the right side from the left side's rule — asymmetric, the left states the rule, the right states what falls outside it. The `,` qualification marker adds a condition or restriction to the left content. The top→bottom chain replaces manual "first, then" prose sequences.

## Comparison with alternative notations

| Notation | Precedence | Exception | Qualification | Emphasis | Prose overhead |
|----------|-----------|-----------|---------------|----------|----------------|
| Line-junction | Ordinal line order | `;` on same line | `,` on same line | `-` at line start | Minimal |
| HTML-style dl/dt/dd | Explicit nesting | Multiple dt per dl | CSS class | CSS class | Schema required |
| Indented outline | Depth-based | Comma in text | Comma in text | Bold/italic | Mixed with prose |
| Code block (YAML) | Key order in YAML | Inline array `[a, b]` | Inline condition | Key-value | Tooling-reliant |

Line-junction sits between prose and formal schema — relational semantics without tooling dependencies.

## Operators

- **`-`** — emphasis. Marks the line as a carrier of semantic weight. At line start.
- **`,`** — qualifies. The right side adds a condition or restriction to the left. `A, B` means A as qualified by B.
- **`;`** — exempts. The right side exempts the left side. Asymmetric — `A; B` means A applies except when B. The left states the rule; the right states what falls outside it.

## Junction rule

Every line in a categorization section is a junction. Lines without `-`, `;`, or `,` are still junctions — they carry ordinal precedence through line order alone. The choice of line break is itself a semantic act: what belongs on one line belongs together; what belongs on separate lines belongs apart.

## Edge cases

**Line with multiple markers** — multiple markers on one line: `- Plural nouns; except sciences, when naming directories`. Emphasis first, then exception, then qualification. The markers nest: `- [emphasized rule]; [exception], [qualification]`.

**Single-item category** — a categorization section with one junction line. Ordinal precedence is vacuous when only one item exists. Emphasis still applies. Example: `## Domain` with one line `- Mathematics — SageMath only.`

**Nested categories** — hierarchical relationships use indented sub-lines. Sub-lines inherit the parent position in the precedence chain and establish their own internal precedence. Indentation provides the depth dimension.

**Mixed junction and prose** — some categorization sections have categorical lines plus a paragraph of context. Junction priority places lines first. Prose follows after the final junction line.

## Evolution

Line-junction notation emerged from recognized patterns in existing maxims. KNOWLEDGE.CLASSIFICATION used ordinal rings with implied precedence. CODE.LAYERS used grouping layers. ENTITY.DISCERNIBILITY used segments in order. STALL.ENGINE used model parameters as junctions. These maxims expressed precedence structurally without naming the convention. Line-junction formalizes this implicit convention into explicit semantics.

## See also

- `PROT.MAXIM.SCHEMA` — maxim structure protocol; line-junction rules live there
- `RUL.WRITING.CONVENTION` — structural-preference composes with line-junction notation
- `RUL.POSITIVE.FRAMING` — no-negation rule extends into line-junction
- `REF.META.NAMING.SCHEMA` — segment-based precedence parallels ordinal line precedence
