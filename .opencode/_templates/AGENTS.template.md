---
id: TEMPLATE.AGENTS
title: AGENTS Template — Categorical Junction Bootstrap
layer: agents
purpose: "Bootstraps any project AGENTS.md: categorical headings, junction bullets, declarative register."
naming: AGENTS.md at any project root
tags: [template, agents, bootstrap, junction]
status: active
---
# {PROJECT-NAME} — Agent Instructions

<!-- AGENTS template — one file per project root, per RUL.AGENTS.STATE.
     Destination: {project-root}/AGENTS.md.
     Ground source of truth: this template lives in _templates/.
     Register: BULLET.template.md governs the body — categorical headings, junction bullets,
     one fact per line, subject opens, active finite verbs, no bold in bullets, no md tables.
     DECLARATIVE.template.md governs the register — present-tense finite verbs, root nouns.
     Format contract: each `##` heading names a categorical aspect; each `-` line states one
     junction of that category. Junctions never contradict one another. The file states only
     final absolute states — decisions and history belong in bitacora files.
     Scope contract: the file describes only its own domain and processes — no other-project
     or other-aggregator mentions. -->

## Identity

- This file serves as the agent instruction file for the {PROJECT-NAME}.
- It instantiates the delegation environment per {IDENTITY-REFERENCE}.
- It states final absolute states per {STATE-RULE}.
- It stands self-contained per {SELF-CONTAINED-SPEC}.

## Domain

- {PROJECT-NAME} explores {DOMAIN}.
- It produces {ARTIFACT}.
- It documents {FINDINGS}.

## Structure

- {DIRECTORY} holds {CONTENT} per {TOPOLOGY-SPEC}.
- {DIRECTORY} holds {CONTENT}.
- {DIRECTORY} holds {CONTENT}.

## Tooling

- The project runs on {RUNTIME} and executes source directly.
- Deps live in {DEPS-FILE}.
- {DATABASE-FILE} powers the database.
- Migrations add columns per {MIGRATION-SPEC}.
- Existing tables and rows persist.
- {CONFIG-FILE} registers active servers only.
- Tools declare {TOOLCLASS-MARKER} per {TOOLCLASS-SPEC}.
- Language choice follows {ROLE-MAP} and {RING-TOPOLOGY}.
- {TOOL} provides {ROLE}.
- {TOOL} provides {ROLE}.
- {TOOL} provides {ROLE}.

## Conventions

- {ARTIFACT} uses {CONSTRAINT} always.
- {FOLDER} follows {NAMING-RULE}.
- {RECORD} lives under {RECORD-DIR}.
- {COMMAND} pipes output to {LOG-DIR}.
- {FILE} converts per {SLUG-RULE}.

## Workflow

- Records live under {RECORD-DIR}.
- {WORKFLOW-SKILL} sequences todo → log → report.
- {TODO-FILE} holds persistent task lists and begins BEFORE tasks start.
- Status updates (`- [ ]` / `- [x]`) mark progress during tasks.
- {REPORT-FILE} holds the factual record at completion: what was done, decisions, open edges, todo state summary.
- Every command pipes through {LOG-WRAPPER} {NAME} -- {COMMAND} → {STDOUT-DIR}/{TIMESTAMP}-{NAME}.log.
- The wrapper writes provenance headers only (trace-free).
- {TRACE-COMMAND} enriches stdout of commands with the exec tree when exec-level detail matters.

## Knowledge

- {LAYERS} compose in a fixed order.
- {PRECEDING-LAYER} precedes {FOLLOWING-LAYER}.
- {LAYER} holds {CONTENT}.
- {LAYER} holds {CONTENT}.
- {LAYER} holds {CONTENT}.

## Delegation

- {PROVIDER} provides {SHARED-SUBSTRATE}.
- This project owns {DOMAIN}: {OWNED-THINGS}.
- Each {CHILD-PROJECT} follows its own instructions; the agent reads them before working inside.
