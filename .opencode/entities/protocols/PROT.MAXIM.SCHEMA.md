---
id: PROT.MAXIM.SCHEMA
title: Maxim Identity — Aphoristic Principle Entity
source: NEX.META.PROPOSAL
summary: Schema, frontmatter, body sections, and line-junction conventions for maxim files
protocol: "Every maxim file uses principle: frontmatter, omits concrete examples, and encodes a universal design principle in generalized terms. The categorization section uses line-junction notation: - for emphasis, ; for exception, , for qualification, ordinal lines for precedence. Every line is a junction."
reference: SPEC.MAXIM.LINE.JUNCTION
enforcement: Formality
status: active
priority: 2
tags: [maxim, entity, identity, schema, convention, architecture, line-semantics]
---

## Protocol

1. Every maxim file contains a `principle:` frontmatter field stating the core aphorism as a single declarative sentence.

2. Maxim body uses generalized, example-free language. Concrete names, scores, paths, and specific instances belong in the paired illustration.

3. Every maxim carries a `source:` frontmatter field attributing the origin when the principle comes from external work (`INSP.PRAGMATIC`, `INSP.WIKIPEDIA`, etc.).

4. Every maxim carries an optional `reference:` frontmatter field pointing to a `REF.*` entity that provides detailed specification of the maxim domain model.

5. **Categorization section** — the first body section after the principle statement. Header is domain-specific, chosen per maxim to name what the maxim categorizes. Describes the categorical structure the maxim operates on. Lines in this section follow line-junction notation.

6. **Line-junction notation** (categorization section only):
   - Every line in the categorization section is a junction — carries structural semantics through markers and ordinal position
   - `-` at line start marks emphasis on the junction content
   - `;` within a line marks an exception — the right side exempts the left. Asymmetric: left states the rule, right states what falls outside it
   - `,` within a line qualifies — adds a condition or restriction to the left content
   - Line order (top→bottom) encodes ordinal precedence — line N precedes line N+1
   - Junction forms take priority over prose for structural content
   - Categorization uses positive assertion — state what exists, describe what belongs

7. Body provides a `## Rules` section with corollaries — actionable consequences that derive from the categorization.

8. Body provides a `## Applicability` section with generalized usage guidance.

9. `## See also` always links the paired `ILL.*` illustration that carries concrete instances.

10. Examples in a maxim body indicate missing paired illustration. Extract concrete instances to an ILL.* file; keep the principle in the maxim.

11. **Entity relationship vectors** — maxims (and all entities) use exactly one directional entity-to-entity field. `precedes` points inward to entities the current entity grounds — the only directional vector. `source` is cross-ring provenance anchor (inward to inner ring), not a relationship vector. `related` is undirected same-ring connection. `preceded_by` is not a declared frontmatter field — its inverse relationship to `precedes` is derivable and must not be stored.

12. **Maxim orthogonality** — maxims are orthogonal per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY (Axiomatic group, Ring 0). A maxim body must not state or imply that it composes with, depends on, or extends another maxim. `## See also` navigation links to other maxims are permitted — they are reader references, not dependency claims.

## Gotchas

- Maxim contains concrete example: Extract to `ILL.{DOMAIN}.{TOPIC}` — illustration carries concrete instances (Named plugin, file path, or score in body)
- Maxim lacks `source:` attribution: Add attribution per REF.META.REFERENCE.AUTHORITY (Source is assembler. Principle originates externally.)
- Maxim lacks categorization section: Add categorization section — Model, Groups, Natures, or domain-specific header (Body starts with Rules)
- Categorization section uses prose where junctions suffice: Rewrite as junction lines with `-`, `;`, and ordinal line order (Content uses full sentences for structural relationships)
- Exception on separate lines: Merge to single line — `A; B` means A exempts B (Left and right of `;` split across lines)
- Maxim-Principle mismatch: Reclassify to PAT with same body content (ID is MAX with pattern body format (examples, scores))
- Maxim declares preceded_by: Replace with `source` for grounding concept, use `precedes` for inward direction (preceded_by field exists in frontmatter or derivation rule)
- Maxim states composes with: Remove — maxims are orthogonal; `## See also` for navigation is sufficient (Body contains "Composes with MAX.*" or similar dependency language)

## Enforcement

Code review. New maxim creation checks: (1) `principle:` exists and is declarative, (2) body has no concrete named references, (3) `source:` attributes external origin, (4) categorization section present with line-junction notation, (5) no `preceded_by` field present in frontmatter, (6) body contains no "composes with" or dependency language linking to other maxims. Existing maxims grandfathered. New violation detection only.

## Applicability

All `.opencode/maxims/` files with `MAX.` prefix. The protocol applies to new maxim creation and existing maxim refactoring. Line-junction notation applies only to the categorization section — Rules and Applicability use conventional prose.

## See also

- `IDENTITY.MAXIM` — maxim entity identity
- `SPEC.MAXIM.LINE.JUNCTION` — line-junction notation specification
- `REF.META.NAMING.SCHEMA` — naming rules for MAX prefix
- `SPEC.ENTITY.DISTINCTION.BOUNDARY` — pattern vs protocol boundary; maxim extends the taxonomy
- `REF.META.REFERENCE.AUTHORITY` — source attribution conventions
- `PROT.META.IDENTITY` — entity identity meta-protocol (metadata + body pattern)
- `PROT.RULE.SCHEMA` — rule identity protocol
