---
id: ILL.META.DECISION
title: "Decision Framework — Four-Section Design Reasoning"
source: PROT.META.IDENTITY
summary: "Walkthrough of the decision framework applied to a cross-project import question: should ludoteca import directly from category-theory's lib?"
illustration: "A design question (cross-project import) runs through the four-section framework: problem (shared schema drift), solution (extract to root _lib/), workflow (extract, import, test), conclusion (projects remain independent)."
illustrates: [NEX.META.CANVAS]
tags: decision,walkthrough,reasoning,architecture,framework
related: [REF.META.PROJECT.TOPOLOGY, MAX.PROGRAMMING.DELIBERATELY.PRACTICE]
---
## Rationale

Design discussions skip from problem to solution without articulating the reasoning between them. The four-section framework (problem → solution → workflow → conclusion) forces each section to complete before the next begins — preventing premature commitment to solutions and ensuring decisions are traceable.

A design discussion emerges: should `ludoteca` import directly from `category-theory/lib/` to reuse a shared schema? Following the decision framework forces structured reasoning before any code change.

## Walkthrough

### Section 1: Problem

Schema definitions in `ludoteca` and `category-theory` both define a `Game` type with overlapping fields. When one project updates its schema, the other silently drifts. No shared definition exists.

### Section 2: Solution

Extract the shared `Game` schema to `assembler/.opencode/_lib/schemas/game.ts`. Both projects import from the root shared lib instead of cross-project imports. Cross-project import path is excluded.

Alternatives considered:
- Copy schema between projects: rejected — drift guaranteed
- Cross-project import (`ludoteca` → `category-theory/lib/`): rejected — violates REF.META.PROJECT.TOPOLOGY modularity
- Shared schema in root `_lib/`: chosen — single authoritative definition

### Section 3: Workflow

1. Create `assembler/.opencode/_lib/schemas/game.ts` — exports `Game` type and validation function
2. Update `ludoteca/lib/game.ts` — imports from `../../_lib/schemas/game` instead of defining locally
3. Update `category-theory/lib/game.ts` — same import change
4. Remove local `Game` type definitions from both projects
5. Run both project test suites — confirm no regressions

### Section 4: Conclusion

The shared schema in root `_lib/` eliminates schema drift between ludoteca and category-theory. Both projects import from the same file. Cross-project import excluded. The modularity constraint from REF.META.PROJECT.TOPOLOGY is preserved.

## Framework in practice

| Section | Purpose | In this decision |
|---------|---------|-----------------|
| Problem | What breaks | Schema drift between two projects |
| Solution | What resolves it | Shared schema in root `_lib/` |
| Workflow | Steps to execute | Extract, update imports, remove locals, test |
| Conclusion | What changed | Cross-project drift eliminated; modularity preserved |

## Key insight

The framework prevents premature commitment by ordering reasoning: problem → solution → workflow → conclusion. Each section completes before the next begins. The workflow section contains concrete actions only — no solution restatement. The conclusion references the problem, closing the loop.

## See also

- `NEX.META.CANVAS` — the decision framework this illustrates
- `REF.META.PROJECT.TOPOLOGY` — modularity principle; constrains cross-project imports
- `MAX.PROGRAMMING.DELIBERATELY.PRACTICE` — deliberate over accidental design
- `SKL.GUIDE.DECISION` — skill that implements this pattern
