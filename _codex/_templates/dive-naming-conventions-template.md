---
id: TEMPLATE.DIVE.NAMING.CONVENTIONS
title: Dive Naming Conventions Template — Codex Dive File Patterns
layer: reference/
purpose: "Naming ruleset for codex dive files — per-layer patterns, template naming, exceptions."
naming: dive-naming-conventions.md
tags: [template, naming, conventions, codex]
status: active
---
# dive-naming-conventions.md

**Layer:** reference/
**Purpose:** naming ruleset for codex dive files — per-layer patterns, template naming, exceptions.

## Dive layer naming patterns

```
mcp/        {server}/                       e.g. patlib/
invariant/  {domain}-{constraint}.md        e.g. source-pristine.md
guideline/  {layer}.md                      e.g. invariant-layer.md
scripts/    {action}-{domain}.sh            e.g. fetch-rom.sh
precept/    {action}-{domain}.md            e.g. verify-qalc.md
backup/     {repo}-src/ + {repo}-binary-{YYYYMMDD}-{HHMMSS} + study-monoliths/
study/      {domain}-{concern}.md           e.g. gb-cpu-sm83.md
concept/    {concept}.md                    e.g. event-driven-timing.md
fixture/    {action}-{domain}-test.{ext}    e.g. probe-headers-test.sh
pattern/    {morphism}.md                   e.g. browser-acquisition-pipeline.md
procedure/  {action}-{domain}.md            e.g. acquire-gb-rom.md
template/   *-template.md                   (see template naming below)
_bitacora/  {YYYYMMDD}-{HHMMSS}-{topic}.md  e.g. 20260802-063915-codex-templates-improve.md
```

## Template naming patterns

```
*-template.md                layer or convention template    e.g. study-template.md
precept-{action}-template.md dive precept template          e.g. precept-verify-qalc-template.md
atomic-script-template.sh    atomic bash script template
schema-template.sql          SQL schema template
push-script-template.rb      Ruby registry-push template
fixtures-template/           fixtures directory template
```

The `precept-{action}-` prefix separates the dive precept template from the generic `precept-template.md`. Both carry the `*-template.md` suffix.

## Rationale per pattern

```
{action}-{domain}   composability — precept, procedure, fixture, and script share one domain name
{domain}-{concern}  atomicity — study files split one concern per file
{YYYYMMDD}-{HHMMSS} ordering — bitacora files sort chronologically; the timestamp serves as identity
{repo}-src/         traceability — the copy anchors the change inventory
```

## Naming rules

```
1. filenames stay lowercase — CamelCase and UPPERCASE stay excluded
2. layer filenames use hyphens — underscores stay excluded
3. filename = identity — the content heading matches the filename
4. the timestamp prefix belongs in _bitacora/ — {YYYYMMDD}-{HHMMSS}- on todos, reports, stdout logs
5. one atomic unit per file — one rule, one concern, one concept, one harness
6. template files carry the *-template suffix — the source of form; instantiation happens in the dive
```

## Exceptions

```
documented in reference/exceptions.md — naming overrides with reason + scope
example: backup binaries carry a timestamp without a leading prefix (repo-binary-{ts})
```

## Governs

```
all files across the codex dive chain (mcp/ → procedure/)
enforced by dive AGENTS.md structure + copy-templates.sh propagation
```
