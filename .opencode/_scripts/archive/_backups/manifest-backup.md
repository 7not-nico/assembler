# AMANDA

> ⚠️ This manifest must not be edited. It is the authoritative index of AMANDA systems.

**A**gentic **M**ultimodal **A**ggregator and **D**igital **A**ssembler

## Systems

### Palestra
Programming and architectural guidelines — serves as the inspiration and reference folder for how we write code, structure projects, and think about architecture.
Its `inspirations/` directory collects reference profiles and principles that inform the study methodology and architectural stance.
Its `patlib.db` at the assembler root is the live database that tools must always reference for pattern and term content — not memory, nor external sources.

### Ludoteca
Video game catalog — serves as the authoritative reference for data architecture patterns.
Its `.opencode/` directory is the shared truth for how to run infrastructure as code. Every new project must derive its data flow and architectural pattern from this template.
Its `docs/` directory serves as the principality of proper written docs.

### Nerdfont
Shared tooling layer for terminal rendering and nerdfont reference — everything that touches the terminal display goes through this.
Its `sets/` directory is the pattern we must query and reference for its glyph contents and codes — not our memory, nor external sources.

### Patlib
Design pattern library and term index — the authoritative index of design patterns and terminology across all AMANDA systems.
Its `.opencode/` directory holds the tooling and schemas, and its `patlib.db` at the assembler root is the live database that tools must always reference for pattern and term content — not memory, nor external sources.

### Bitacora
Linux log — bun:sqlite, no build step. Tracks fixes, studies, and impressions.

### CR-News-Outlets
News outlet price index — primary scope covers civil law countries (CR, ES, JP, EU); common law outlets (US, AU) kept for comparison. Follows the Ludoteca IaC pattern.

### Medcodes
Healthcare codification systems study — bun:sqlite, no build step. Tracks code systems, individual codes, study coverage, and cross-cutting impressions.

### Tablet-Comparison
Tablet spec tracker and custom OS build tracker — not a software product. No git repository.

### Thoughtlog
Sporadic search terms and random thoughts — bun:sqlite, no build step. Tracks terms and thoughts.

### Gear-Specs
Music gear research wiki — flat markdown of audio gear specs, buying guides, and purchase criteria. Code-backed: Bun + TypeScript + bun:sqlite, with `@opencode-ai/plugin` custom tools.

### MCP-Search-Docs
Search provider documentation hub — Bun + TypeScript + bun:sqlite + `@opencode-ai/plugin` custom tools. No build step, no linter, no typechecker.

### Constructive-Drawing
Figure drawing study (Bridgman/Loomis methodology) + artistic anatomy reference database. Flat markdown, no code.

### Learn-Git
Git learning reference — bun:sqlite, no build step.

### Code-Dives
Cloned repos for study (foot, teenycode) — not AMANDA projects. No AGENTS.md.

### Future-Patterns-Terms
Planning workspace — scratch docs and `.bak` proposals, not live content. No AGENTS.md.

### Grammar
Empty — not initialized. No AGENTS.md.

### Nvim
Empty — not initialized. No AGENTS.md.

### Yazi
Empty — not initialized. No AGENTS.md.
