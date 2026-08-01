---
id: ILL.CLI.ACQUIRE
title: "CLI to MCP — Paper Acquisition Workflow Walkthrough"
summary: "Walkthrough of the findings subproject paper acquisition workflow — traces the two-phase rhythm of PRE.CLI.TO.MCP through aspect-specific CLI tools, shared logic components, and eventual MCP declaration."
illustration: "The paper acquisition workflow began as three aspect-specific CLI tools, extracted shared logic into lib/ components, kept one scaffolding tool standalone, then composed the workflow aspects into the mcp-acquire MCP server — same deps, same components."
illustrates: [PRE.CLI.TO.MCP]
tags: cli,mcp,walkthrough,workflow,acquisition,findings
source: PROT.TOOL.MODEL
related: [PRE.BUN.ONLY.RUNTIME, SKL.PROPOSE.TOOL, SKL.PROPOSE.MCP]
---
## Context

The findings subproject needs a paper catalog: search arxiv, download PDFs, register metadata in a local SQLite DB. Before `PRE.CLI.TO.MCP` existed, this workflow was ad-hoc — manual curl, manual `INSERT`, no shared modules. This walkthrough traces the refactored workflow from first principle through MCP declaration.

Prerequisites:
- `PRE.CLI.TO.MCP` — the maxim this illustrates
- `PRE.BUN.ONLY.RUNTIME` — all tools use Bun runtime
- `findings/.opencode/` — target subproject structure
- `findings/.opencode/tools/mcp-acquire/` — the MCP server result

## Walkthrough

### Step 1: Identify the workflow

Per rule 1, the workflow is identified before tooling begins. The paper acquisition workflow has three distinct operations:

- Search arxiv by query
- Download a PDF from a URL (with fallback when curl fails)
- Register a local PDF in findings.db with metadata

These are not domains — they are **aspects** of the same acquisition workflow.

### Step 2: Carve aspects into separate CLI tools

Per rule 2, each CLI tool determines exactly one aspect. Three tools created, one per aspect:

```
findings/.opencode/tools/acquire-search.ts  → arxiv search (one aspect)
findings/.opencode/tools/acquire-download.ts → PDF download  (one aspect)
findings/.opencode/tools/acquire-register.ts → DB registration (one aspect)
```

Each is a standalone `bun run` entry point. `acquire-search.ts` parses the arxiv Atom XML response directly — no shared logic yet. `acquire-download.ts` inlines its own curl + Playwright logic. `acquire-register.ts` imports `lib/db` and performs an upsert.

No tool spans multiple aspects (rule 9 — each determines exactly one concern).

### Step 3: Extract shared logic components

Per rule 4, as soon as a second tool needs the same logic, shared components are extracted into `.opencode/lib/`.

`acquire-search.ts` contains arxiv Atom XML parsing — self-contained. `acquire-download.ts` needs Playwright browser management, which already exists in `lib/browser.ts`. The download + fallback logic is extracted into `lib/acquire-download.ts`:

```
findings/.opencode/lib/acquire-search.ts   — arxiv API query + XML parse + formatEntries
findings/.opencode/lib/acquire-download.ts  — downloadPaper(): curl → %PDF check → Playwright fallback
```

Each shared logic component has a single responsibility. `acquire-search.ts` handles search and formatting. `acquire-download.ts` handles download with fallback. Both are importable by any tool or MCP.

### Step 4: Scaffolding tool stays standalone

Per rule 7, not every tool becomes an MCP aspect. A scaffolding tool `acquire-ping.ts` exists to test download endpoints independently:

```typescript
// acquire-ping.ts — scaffolding tool, never MCP'd
// Tests whether a given URL returns a PDF or blocks the request
const result = await fetch(url)
console.log(result.status, result.headers.get("content-type"))
```

This tool tests ideas — which repos block curl, which serve PDF inline vs attachment. It is a scaffolding tool, remains standalone CLI, never composed into the MCP.

### Step 5: Declare the MCP server

Per rule 5, the MCP is declared only after the shared logic components are composable and exercised via CLI.

`findings/.opencode/tools/mcp-acquire/index.ts` imports the same shared logic components and deps:

```typescript
import { downloadPaper } from "../../lib/acquire-download"
import { arxivSearch, formatEntries } from "../../lib/acquire-search"
import { upsertPaper } from "../../lib/query"
```

Per rule 8, it uses the same `package.json` dependencies — `@modelcontextprotocol/sdk`, `zod`, `playwright-core`.

Per rule 6, the MCP composes workflow aspects — not every tool. `acquire_pipeline` wires search → download → register into one MCP call. The scaffolding `acquire-ping` is absent:

| MCP tool | Composes | Aspect |
|----------|----------|--------|
| `acquire_search` | `arxivSearch` + `formatEntries` | Search |
| `acquire_download` | `downloadPaper` | Download |
| `acquire_register` | `upsertPaper` | Register |
| `acquire_pipeline` | search → download → register | Complete workflow |

### Step 6: Retain CLI tools for iteration

Per rule 6, CLI tools are retained. When a new paper source is added (e.g., Semantic Scholar API), the developer iterates on `acquire-search.ts` as a CLI tool — quick `bun run` cycles. Only after the aspect logic stabilizes does the MCP get updated to include the new search source.

## Key insight

The two-phase rhythm is not a one-time design-then-implement sequence. It is a living cycle: new workflow aspects are carved at the CLI level during iteration, tested with scaffolding tools, extracted into shared logic components, and only the stable workflow subset is formalized via MCP. The MCP is the declaration layer; the CLI tools are the proving ground.

## References

1. Hu, Wang, Peng et al. "Evaluating LLM-Based 0-to-1 Software Generation in End-to-End CLI Tool Scenarios." 2026. `stud/cli-to-mcp/2604.06742v2.pdf` — CLI tool generation validates tool-as-endpoint paradigm
2. Coleman, Griswold, Mitchell. "Do Cloud Developers Prefer CLIs or Web Consoles?" 2022. `stud/cli-to-mcp/2209.07365v1.pdf` — CLI-first validated as developer preference
3. Chi, Qi, Cui et al. "AgentMeter: Evaluating Model-CLI Matching for CLI-Based Local Task-Solving Agents." 2026. `stud/cli-to-mcp/2606.21140v1.pdf` — CLI as agent/interface boundary
4. Milosevic, Rabhi. "Architecting Agentic Communities using Design Patterns." 2026. `stud/cli-to-mcp/2601.03624v3.pdf` — design patterns for composable architectures (unification phase)
5. Wagner, Deissenboeck. "Abstractness, specificity, and complexity in software design." 2017. `stud/cli-to-mcp/1709.01304v1.pdf` — abstraction levels map to CLI (concrete) → MCP (abstract)
6. Li, Maheshwari, Voelker. "User-Centered Design with AI in the Loop: A Case Study of Rapid UI Prototyping." 2025. `stud/cli-to-mcp/2507.21012v1.pdf` — rapid prototyping before formalization
7. Kamburjan, Hähnle. "Prototyping Formal System Models with Active Objects." 2018. `stud/cli-to-mcp/1810.02470v1.pdf` — prototyping before formal declaration parallels CLI→MCP
8. Bjarnason, Lang, Mjöberg. "An Empirically Based Model of Software Prototyping." Springer, 2023. `stud/cli-to-mcp/springer-prototyping-model.pdf` — open-access model of prototyping practices; validates the prototyping-first phase
9. Wu. "An Exploratory Study of V-Model in Building ML-Enabled Software." 2023. `stud/cli-to-mcp/2308.05381v4.pdf` — prototyping-to-production pipeline mirrors separation-then-unification
10. Castellanos, Vergnaud, Borde, Derive, Pautet. "Formalization of Design Patterns for Security and Dependability." ACM, 2013. `stud/cli-to-mcp/acm-design-pattern-formalization.pdf` — formalizes patterns as model transformations; maps to MCP-as-formalization phase

## See also

- `PRE.CLI.TO.MCP` — the maxim this illustrates
- `PRE.BUN.ONLY.RUNTIME` — Bun runtime rule governing all tools
- `findings/.opencode/tools/mcp-acquire/index.ts` — the MCP server resulting from this workflow
- `findings/.opencode/lib/acquire-search.ts` — shared logic component: arxiv search
- `findings/.opencode/lib/acquire-download.ts` — shared logic component: PDF download with fallback
- `stud/cli-to-mcp/` — 10 papers on CLI tool design, modularity, prototyping, and formalization (incl. Springer open-access and ACM)
