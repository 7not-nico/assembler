---
id: TEMPLATE.CLI
title: CLI Entity Template — External Tool Knowledge Entry
layer: cli
purpose: "Bootstraps any external CLI tool entity: 5-section bullet entry, frontmatter, references."
naming: "{SUBJECT}.md in .opencode/entities/cli/ — ID CLI.{SUBJECT}"
tags: [template, cli, entity, tool, bootstrap]
status: active
---
<!-- CLI entity template — one file per external tool per the cli entity group.
     Destination: .opencode/entities/cli/CLI.{SUBJECT}.md.
     ID: CLI.{SUBJECT} — uppercase dot-separated; {SUBJECT} = tool name (PANDOC, RIPGREP).
     Ground source of truth: this template lives in _templates/.
     Fact verification precedes writing: search covers creator, origin year, language, core features.
     Prose register: BULLET.template.md governs the body — junction bullets, one fact per line,
     subject opens, active finite verbs, no bold in bullets. DECLARATIVE.template.md governs the
     register — present-tense finite verbs, root nouns, verbs state behavior, no -ed verb forms.

     Five-section contract — each section holds one distinct job, bullets chain, logical flow:
     1. Identity   — definition, creator, origin year, language
     2. Function   — core operation, flags, modes, behavior
     3. Usage      — invocation, common patterns, workflow integration
     4. Design     — internal mechanism, architecture, engine
     5. Ecosystem  — adoption, influence, alternatives, license
     Sections flow: What → Does → Use → Works → Sits. No job repeats across sections. -->

## Identity

- {Name} — {one-line definition}; {creator with language note}, with the first release in {year}
- The name combines {origin note} to signal its {scope or focus}

## Function

- {Name} {performs its core operation}
- It {key capability 2}
- It {key capability 3}

## Usage

- Developers run `{name} {typical invocation}` to {purpose}
- {Secondary usage pattern}
- {Workflow integration note}

## Design

- {Name} {internal mechanism or architecture}
- {Engine or backend note}

## Ecosystem

- {Adoption note}
- {Influence or lineage note}
- {Alternatives note}

---
id: CLI.{SUBJECT}
title: {Name}
type: external
source: COG.COMPUTER.SCIENCE
precedes: []
tags: {tag1, tag2, tag3}
reference:
  - title: "{Official Docs}"
    url: {url}
  - title: "{Source Repository}"
    url: {url}
  - title: "{Manual or Deep Dive}"
    url: {url}
---
