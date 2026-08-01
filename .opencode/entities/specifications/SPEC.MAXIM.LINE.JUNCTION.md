**Maxim Line Junction** — every line in a maxim categorization section is a junction. Four notational choices convey structural semantics: `-` for emphasis, `;` for exception, `,` for qualification, and ordinal line order for precedence.

## Rationale

Structural-preference (`RUL.WRITING.CONVENTION`) prefers structured formats for multi-element content. Line-junction notation encodes relational semantics — emphasis, exception, qualification, precedence — directly into formatting. Formatting replaces explanatory prose for relationships the structure already expresses.

The `-` emphasis marker replaces generic list bullets with a semantic affordance. The `;` exception marker exempts the right side from the left side's rule — asymmetric, the left states the rule, the right states what falls outside it. The `,` qualification marker adds a condition or restriction to the left content. The top→bottom chain replaces manual "first, then" prose sequences.

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

---
id: SPEC.MAXIM.LINE.JUNCTION
title: Maxim Line Junction — Notation Semantics and Application
source: assembler
summary: "Every line in a maxim categorization section is a junction. Four notational choices convey structural semantics: dash for emphasis, semicolon for exception, comma for qualification, and ordinal line order for precedence."
specifies: Line-junction notation for categorization sections
tags: [maxim, notation, line-semantics, convention, specification]
status: active
---
