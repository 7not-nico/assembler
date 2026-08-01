---
id: PAT.DECISION.FRAMEWORK
title: "Decision Framework — Structured Design Reasoning"
source: assembler
summary: "Every architectural decision is framed as: problem, solution, workflow, conclusion."
principle: "A decision is only complete when stated as four explicit sections that close the loop from problem to resolution."
enforcement: Convention
tags: [decision, reasoning, architecture, framework, workflow]
patterns: [PAT.PROGRAMMING.DELIBERATELY, PAT.ASSEMBLER.ARCHITECTURE]
terms: []
status: active
priority: 3
---

A decision is only complete when stated as four explicit sections that close the loop from problem to resolution.

## Context

Design discussions often skip between problem and solution without articulating the intermediate reasoning. The Decision Framework forces each section to complete before the next begins: what breaks (problem), what choice resolves it (solution), what steps execute it (workflow), and what changed (conclusion). This prevents premature commitment to solutions and ensures decisions are traceable. The `SKL.GUIDE.DECISION` skill implements this pattern.

## Rules

- Four sections always: problem, solution, workflow, conclusion
- Problem must be stated before any solution is proposed
- Each section must complete before moving to the next
- Workflow is execution steps — not a restatement of the solution
- Conclusion references the problem — closes the loop
- Mention alternatives briefly in the solution section, but force one choice

## Applicability

Any design discussion — architectural change, tool creation, naming decision, or structural refactor.

## See also

- SKL.GUIDE.DECISION
- PAT.PROGRAMMING.DELIBERATELY
- PAT.ASSEMBLER.ARCHITECTURE
