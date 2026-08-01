---
id: NEX.META.CANVAS
title: "Decision Framework — Structured Design Reasoning"
source: assembler
summary: "Every architectural decision is framed as: problem, solution, workflow, conclusion."
composition: "A decision is only complete when stated as four explicit sections that close the loop from problem to resolution."
enforcement: Convention
related: []
tags: [decision, reasoning, architecture, framework, workflow]
status: active
priority: 3
---

A decision is only complete when stated as four explicit sections that close the loop from problem to resolution.

## Rules

- Four sections always: problem, solution, workflow, conclusion
- Problem must be stated before any solution is proposed
- Each section must complete before moving to the next
- Workflow: execution steps only — concrete actions; solution restatement excluded
- Conclusion references the problem — closes the loop
- Mention alternatives briefly in the solution section; force single choice

## Applicability

Any design discussion — architectural change, tool creation, naming decision, or structural refactor.

## See also

- ILL.META.DECISION.WALK — four-section decision framework walkthrough
- SKL.GUIDE.DECISION
- MAX.PROGRAMMING.DELIBERATELY.PRACTICE
- REF.META.PROJECT.TOPOLOGY
