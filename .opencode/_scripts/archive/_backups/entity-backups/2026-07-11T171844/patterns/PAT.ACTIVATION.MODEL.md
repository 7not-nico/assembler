---
id: PAT.ACTIVATION.MODEL
title: Activation Model — Proactive Rules, Reactive Skills
source: assembler
summary: Rules activate proactively as session instructions; skills activate reactively by trigger or invocation.
principle: Rules auto-load every session to shape agent behavior before tasks begin. Skills lie dormant until a matching scenario or explicit call invokes them. Choose the activation model that fits the content's role.
enforcement: Convention
tags: [architecture, design, convention, activation, rules, skills, opencode]
patterns: []
terms: [TERM.RULE, TERM.SKILL]
status: active
priority: 3
---

Rules load every session as proactive instructions. Skills await reactive trigger or invocation.

## Context

The `.opencode/` architecture has two primary behavioral layers — rules and skills. Both influence agent behavior through fundamentally different activation models.

**Rules** are *proactive* — loaded automatically every session via `opencode.json` instructions, they shape how the agent approaches *every* task before it begins. A rule cannot be silenced mid-session.

**Skills** are *reactive* — registered in patlib but dormant until activated by trigger detection (LLM recognizes a matching scenario) or explicit invocation (`skill load`). A skill can be ignored if its trigger never fires.

Confusing these models causes:
- A procedural workflow encoded as a rule → floods every session with irrelevant instructions
- A universal principle encoded as a skill → never activates unless explicitly loaded

The fix: match the activation model to the content's scope and cadence.

## Rules

- **Proactive** content (universal truths, session-wide conventions, always-on gates) → **Rule**
- **Reactive** content (conditional procedures, multi-step workflows, scenario-specific logic) → **Skill**
- A rule must be meaningful in every session — if it's conditional, it's a skill
- A skill must have a detectable trigger — if it's always relevant, it's a rule
- Default to skill when unsure: a skill can be invoked on demand, but a rule cannot be silenced

## Applicability

Any `.opencode/` architectural decision — creating new rules or skills, evaluating existing content for layer fit, onboarding contributors to the activation model distinction.

## See also

- TERM.RULE
- TERM.SKILL
- RUL.REQUIRE.FOUNDATIONS
- RUL.QUERY.PATLIB.CONTEXT
- SKL.GUIDE.ARCHITECTURE
