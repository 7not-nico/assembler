# naming-conventions.md

**Layer:** reference/
**Purpose:** naming ruleset for knowledge-project files — per-layer patterns, rationale, exceptions.

## Layer naming patterns

```
format/     {NAME}.md                     e.g. frontmatter.md
precept/    {action}-{domain}.md          e.g. prefer-official-reference.md
procedure/  {action}-{domain}.md          e.g. research-wiki.md
research/   {topic}-{source}.md           e.g. configuring-wiki.md
concept/    {topic}.md                    e.g. config-hierarchy.md
note/       ch{NN}-{topic}.md             e.g. ch03-configuring.md
bitacora/   {NNN}-{description}.md        e.g. 001-wiki-study.md
glossary/   {term}.md                     e.g. dispatcher.md
schema/     {name}.sql                    e.g. registry.sql
script/     {action}-{subject}.rb         e.g. push-registry.rb
reference/  {name}.md                     e.g. conventions.md
fixtures/   ch{NN}-{aspect}.{ext}         e.g. ch01-basic.conf
practice/   {NNN}-{exercise}.md           e.g. 001-binds-drill.md
```

## Rationale per pattern

```
ch{NN}- prefix     ordering — natural sort places chapters in study order
{action}-{domain}  composability — precept and procedure share domain name
{topic}-{source}   traceability — research capture maps to its source page
{term}.md          atomicity — one term per file, filename is the term
{name}.sql/.md     lowercase single word — registry table, conventions file
{NNN}- prefix      sequence — bitacora and practice ordered by session/exercise
```

## Naming rules

```
1. lowercase throughout — no CamelCase, no UPPERCASE in filenames
2. hyphen-separated words — never underscores in layer filenames
3. filename is the identity — content heading must match filename
4. no version in filename — version lives in the Source header
5. no dates in filename — dates live in the Source header (bitacora NNN = sequence)
6. one atomic unit per file — one rule, one term, one concept, one chapter
```

## Exceptions

```
documented in reference/exceptions.md — naming overrides with reason + scope
example: schema filename uses underscore when project name has hyphens
         (mise-docs → mise_docs.sql) — SQL identifier cannot contain hyphens
```

## Governs

```
all files across the 13-layer chain
enforced by scaffold-knowledge.sh generation + manual audit
```
