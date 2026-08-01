---
id: PAT.META.TRIGGER
title: Activation Model — Proactive Rules, Reactive Skills
source: NEX.TOOL.CHOICE
summary: Rules activate proactively as session instructions; skills activate reactively by trigger or invocation.
morphism: SGNL — rules auto-load every session to shape agent behavior before tasks begin. Skills lie dormant until a matching scenario or explicit call invokes them. Choose the activation model that fits the content's role.
enforcement: Convention
tags: [architecture, design, convention, activation, rules, skills, opencode]
status: active
priority: 3
---

Rules load every session as proactive instructions. Skills await reactive trigger or invocation.

## Rules

- **Proactive** content (universal truths, session-wide conventions, always-on gates) → **Rule**
- **Reactive** content (conditional procedures, multi-step workflows, scenario-specific logic) → **Skill**
- A rule must be meaningful in every session — if it's conditional, it's a skill
- A skill must have a detectable trigger — if it's always relevant, it's a rule
- Default to skill when unsure: a skill can be invoked on demand, but a rule cannot be silenced

## Applicability

Any `.opencode/` architectural decision — creating new rules or skills, evaluating existing content for layer fit, onboarding contributors to the activation model distinction.

## See also

- ILL.META.TRIGGER.CHAIN — rule vs skill activation walkthrough
- IDENTITY.RULE
- IDENTITY.SKILL
- RUL.REQUIRE.FOUNDATIONS
- RUL.QUERY.PATLIB.CONTEXT
- SKL.GUIDE.ARCHITECTURE
