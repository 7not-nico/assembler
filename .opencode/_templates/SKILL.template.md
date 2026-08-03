---
id: TEMPLATE.SKILL
title: Skill Template — Categorical Junction Bootstrap
layer: skills
purpose: "Bootstraps any skill SKILL.md: canonical frontmatter, categorical headings, junction bullets."
naming: SKILL.md at any project root
tags: [template, skill, bootstrap, junction]
status: active
---
# {PROJECT-NAME} skill — SKILL.md

<!-- SKILL template — one file per skill directory, per PROT.SKILL.SCHEMA.
     Destination: .opencode/skills/{action}-{domain}/SKILL.md.
     Ground source of truth: this template lives in _templates/.
     Frontmatter per PROT.SKILL.SCHEMA Rule 9: name (matches directory), description
     (starts with "Use this skill when"), state-profile (one of five per PROT.SKILL.PROFILE),
     nexus (optional, one NEX.* entity). Canonical body sections: Trigger, Procedure, Gotchas.
     Register: BULLET.template.md governs the body — categorical headings, junction bullets,
     one fact per line, no bold in bullets, no md tables. IMPERATIVE.template.md governs the
     register — verb-first directives, positive framing, one action per step.
     Description IS the trigger per PROT.SKILL.SCHEMA Rule 7; the Trigger section states the
     operational load condition. -->

name: {action}-{domain}
description: Use this skill when {trigger condition} — {one sentence on what it covers}
state-profile: {stateless|stateful-reader|stateful-writer|stateful-auditor|hybrid}
nexus: NEX.{DOMAIN}.{ASPECT}

## Trigger

- Load this skill when {operational load condition}.
- It activates when {matching task description}.

## Procedure

- {Action} — {object or target} — {outcome}
- {Action} — {object or target} — {outcome}
- {Action} — {object or target} — {outcome}
- {Action} — {object or target} — {outcome}

## Gotchas

- {Antipattern} — {positive redirect: what TO do instead}
- {Antipattern} — {positive redirect: what TO do instead}
- {Antipattern} — {positive redirect: what TO do instead}

<!-- Variants:
     DISPATCHER — skills that route to mode sub-skills use ref/{mode}.md (per-mode route) +
     nested skill/{aspect}/SKILL.md per PROT.SKILL.SCHEMA Rule 9.
     REF FILE   — per-mode or per-language reference files use ref/{mode}.md with MODE or
     LANGUAGE shape. Model: playwright-dispatcher, semantic-dispatcher, knowledge-languages. -->
