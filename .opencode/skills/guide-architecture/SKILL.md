---
name: guide-architecture
description: Use this skill when deciding which layer to use for .opencode/ content — it recommends the correct layer for creating or modifying patterns, terms, illustrations, skills, commands, and rules
state-profile: stateless
related: ["SKL.PROPOSE.MCP", "RUL.USE.LOCAL.MCP"]
patterns: ["PAT.META.LAYER.TRIGGER", "NEX.TOOL.SEQUENCE", "PAT.PATTERN.VS.TERM", "PROT.TOOL.DEFINITION", "PROT.TOOL.HOOKS", "PROT.SKILL.STATECLASS", "REF.LIB.DIRECTORY.LAYER", "REF.LIB.PURITY.BOUNDARY"]
terms: ["IDENTITY.RULE", "IDENTITY.SKILL", "IDENTITY.COMMAND", "IDENTITY.PATTERN", "IDENTITY.TERM", "TERM.ABSTRACTION", "IDENTITY.PROTOCOL", "TERM.APOLOGIA", "IDENTITY.MCP", "TERM.OPENCODE.PLUGIN"]
---
**Procedure**

When adding new content to `.opencode/`, determine the layer. Query existing entities using `patlib_search` (mcp-patlib) during each check — avoid manual file inspection per `RUL.USE.LOCAL.MCP`. Before creating new patterns, terms, or protocols, search existing abstractions first. Abstractions surface formal models (automata theory, type theory, λ-calculus) that inform and validate the design — they provide precise vocabulary and generalize across multiple entity types:

1. **Universal truth or aphorism** that must apply every session? → **Rule** — write to `rules/yamls/*.yaml`
2. **Formal mathematical or computational definition** with symbolic notation and inference rules? → **Abstraction** — write to `abstractions/ABS.*.md` (see `SKL.AUDIT.ABSTRACTION`)
3. **Technical subsystem contract** with enforcement rules, status, and priority? → **Protocol** — write to `protocols/PROT.*.md` (see `SKL.AUDIT.PROTOCOL`)
4. **Design decision justification** explaining why a choice was made? → **Apologia** — write to `apologias/APO.*.md` (see `SKL.AUDIT.APOLOGIA`)
5. **Defines WHAT something IS** — description, reference, related concepts? → **Term** — write to `terms/TERM.*.md` with backmatter YAML (see `SKL.AUDIT.TERM`)
6. **Walks through an INSTANCE** — single-instance walkthrough of a pattern or protocol, concrete named entities? → **Illustration** — write to `illustrations/ILL.*.md` with frontmatter YAML (see `X`)
7. **Prescribes HOW something should be done** — principle, enforcement, tags? → **Pattern** — write to `patterns/PAT.*.md` with frontmatter YAML (see `SKL.AUDIT.PATTERN`)
9. **Reusable multi-step procedure** with auto-detect triggers or state? → **Skill** — write to `skills/*/SKILL.md` with state-profile frontmatter (see `PROT.SKILL.STATECLASS`)
10. **User-initiated directed slash workflow** (`/command`)? → **Command** — write to `commands/*.md` with `commands/yamls/*.yaml` registry (see `SKL.FORMAT.COMMAND`)
11. **Discrete stateless executable step** the LLM calls directly, persistent state excluded? → **Custom IPC Tool** — write to root `tools/*.ts` only, using `@opencode-ai/plugin` pattern (see `PROT.TOOL.DEFINITION`)
12. **Lifecycle hook, behavior interception, or environment injection** — callable tool excluded; modifies opencode behavior instead? → **Plugin** — write to `plugins/*.ts` with named export and hooks object (see `PROT.TOOL.HOOKS`)
13. **Persistent service** needing DB access, filesystem I/O, or network access across calls? → **MCP Server** — write to `tools/*/index.ts` with `StdioServerTransport` (see `REF.LIB.PURITY.BOUNDARY`)

**Gotchas**

**Layer behavior**

- Pattern in 2+ commands — extract to a skill or rule once
- Skills query DBs — use DB queries or relative paths, hardcoded paths excluded
- Commands require user initiation — rules and skills load automatically

**Custom IPC tools**

- Import from `_lib/` only — cross-tool imports excluded
- One direction per tool — read OR write. Split both-dir tools into separate files
- `crashOnError()` at top of `execute()` — see `REF.LIB.DIRECTORY.LAYER`

**Skills**

- `state-profile` in frontmatter — see `PROT.SKILL.STATECLASS` for values
- MCP servers live inside `tools/<server-name>/index.ts` — subdirectory of tools/; sibling placement excluded
- MCP servers use stdio transport by default; add Streamable HTTP only when multi-client access is required
- MCP servers follow purity/impurity separation — extract formatting to pure `_lib/` modules, keep DB/FS in impure modules
- Patterns, illustrations, protocols, and terms use `PAT.PATTERN.VS.TERM` heuristic: `protocol:` → protocol; `principle:` → pattern; `illustration:` → illustration; `reference:` → term
- Protocols and patterns both have `status` and `priority` — protocols define contracts between systems, patterns prescribe principles for one system
- Abstractions are exempt from `PROT.LLM.SPECIFICATION` — pure definitions, behavioral instructions excluded
- An apologia differs from terms and patterns — it justifies a decision already made. Terms define, patterns prescribe
- Plugins that register tools via `tool:` hook need a companion skill — see `PROT.TOOL.HOOKS` §1
- Custom IPC tools belong in root `assembler/` only — subprojects use Shebang CLI, MCP, or Plugin
- Custom IPC tools and plugin-registered tools share the same tool namespace — plugin tools override built-in tools of the same name
- Use `patlib_search` to query existing entities when evaluating the layer decision
- Abstractions skipped during design — new pattern/term/protocol duplicates a formal concept encoded in abstractions. Search abstractions first — formal models exist before behavioral rules.
- Entity directories (patterns, terms, protocols, abstractions, apologias, rules, skills, commands) belong at root only — subprojects reference them; local hosting excluded. Create new entities at root scope per `REF.META.ENTITY.ROOT`
- Subproject receives its own `.db` when domain data needs queryable persistence across sessions per `REF.SCHEMA.DATABASE.OWNERSHIP` — flat files suffice for ephemeral or configuration data
- Subproject structure follows tiered convention per `REF.META.PROJECT.STRUCTURE` — mandatory tools/, lib/, AGENTS.md, opencode.json; schemas/ required when `.db` exists; package.json required when external dependencies exist
- Every tool is a morphism per `PROT.TOOL.MORPHISM` — shared objects in lib/, proprietary objects in the tool file; LLM/Architect composes; identity declared via `// @toolclass`

**Layer reference**

| Layer | File location | Activation | Backend | Purity |
|-------|--------------|------------|---------|--------|
| Rule | `rules/yamls/*.yaml` | Proactive (auto-loaded) | None | Metadata only |
| Abstraction | `abstractions/ABS.*.md` | Queried | None | Pure definition |
| Protocol | `protocols/PROT.*.md` | Queried | DB + files | Dual (body + metadata) |
| Apologia | `apologias/APO.*.md` | Queried | DB + files | Dual (body + metadata) |
| Term | `terms/TERM.*.md` | Queried | DB + files | Dual (body + metadata) |
| Illustration | `illustrations/ILL.*.md` | Queried | DB + files | Dual (body + metadata) |
| Pattern | `patterns/PAT.*.md` | Queried | DB + files | Dual (body + metadata) |
| Skill | `skills/*/SKILL.md` | Reactive (trigger-detect) | `skill.db` | Instructions |
| Command | `commands/*.md` | User-initiated (`/`) | None | Instructions |
| Plugin | `plugins/*.ts` | Startup (auto-loaded) | `@opencode-ai/plugin` | Event hooks |
| Custom IPC Tool | `tools/*.ts` | Called by agent | `_lib/` modules | IO |
| MCP Server | `tools/*/index.ts` | Subprocess (stdio) | `_lib/`, DB, FS | IO orchestration |

**Rules**

- **Layer decision** — follow procedure steps 1-13 in order. Skip irrelevant layers; first match wins
- **Abstractions first** — search `read-selection --type abstractions` before creating patterns, terms, or protocols. Formal models exist before behavioral rules
- **Design discussions** — when user presents a structural question, walk four frames: problem (what breaks?), solution (what choice resolves it?), workflow (execution steps?), conclusion (what changed?). Complete each frame before next. Problem frames conclusion; conclusion references problem
- **Positive framing** — layer guidance uses positive instructions (what TO do). Negative framing reserved for gotchas only
- **patlib_search primary** — prefer `patlib_search` (mcp-patlib) over `read-selection` for entity queries per `RUL.USE.LOCAL.MCP`
