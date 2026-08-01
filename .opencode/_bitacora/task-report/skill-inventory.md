# AMANDA Skill Inventory

65 skills across `.opencode/skills/`. State profiles: stateless (instruction-only), stateful-reader (reads DB/files), stateful-writer (writes DB/files), stateful-auditor (reads+reports), hybrid (multi-phase).

---

## Anchored Skills (per-task defaults)

| Skill | State | Dir | Purpose |
|-------|-------|-----|---------|
| compose-web | stateless | `compose-web/` | parallel-search → Context7 → Playwright → mcp-log-search pipeline |
| report-outcomes | stateless | `report-outcomes/` | Writes conclusions, errors, walkthroughs, todo per MAX.ATOMIC.CONCERN |
| use-playwright-core | stateless | `use-playwright-core/` | Browser nav, click, type, screenshot, tab mgmt |
| knowledge-ruby | stateless | `knowledge-ruby/` | Ruby functional programming — reads `knowledge/` atomic files |
| read-maxims-protocols | stateless | `read-maxims-protocols/` | Read all MAX.* then PROT.* before every task |

---

## Acquisition

| Skill | State | Dir | Procedure |
|-------|-------|-----|-----------|
| SKL.ACQUIRE.ACM | hybrid | `acquire-acm/` | Navigate ACM DOI → click download → waitForEvent → saveAs → file-verify → register |
| SKL.ACQUIRE.PAPERS | hybrid | `acquire-papers/` (backup) | Generic curl → Playwright fallback → file-verify → organize to findings/ |

---

## Auditing (stateful-auditor)

| Skill | State | Dir | Checks |
|-------|-------|-----|--------|
| SKL.AUDIT.ABSTRACTION | stateful-auditor | `audit-abstraction/` | ABS.*.md — backmatter 5 fields, ID `ABS.`, bold opening, tags≥3, refs≥3 |
| SKL.AUDIT.APOLOGIA | stateful-auditor | `audit-apologia/` | APO.*.md — frontmatter id/title/source/tags/related, ID `APO.`, tags≥3 |
| SKL.AUDIT.COMMAND | stateful-auditor | backup | commands/yamls/ — verb-domain YAML compliance |
| SKL.AUDIT.CROSSREF | hybrid | `audit-crossref/` | Full cross-region research audit — sweep regions → fetch → compile manifest/schema/seed |
| SKL.AUDIT.INVESTIGATION | stateful-auditor | `audit-investigation/` | Investigation meta-audit.md — YAML 5 fields, bold opening, ## sections, schemas/ dir |
| SKL.AUDIT.MAXIM | stateful-auditor | `audit-maxim/` | MAX.*.md — 9 frontmatter fields, bullet-only body, ## Rules/Applicability/See also |
| SKL.AUDIT.NEXUS | stateful-auditor | `audit-nexus/` | NEX.*.md — 10 frontmatter fields, em-dash title, composition field, tags≥3 |
| SKL.AUDIT.PATTERN | stateful-auditor | backup | PAT.*.md — structural and semantic compliance |
| SKL.AUDIT.PROTOCOL | stateful-auditor | `audit-protocol/` | PROT.*.md — 9 frontmatter fields, 6 body sections, 3:1 positive ratio |
| SKL.AUDIT.RULE | stateful-auditor | backup | rules/yamls/ — YAML structural compliance |
| SKL.AUDIT.SKILL | stateful-auditor | backup | skills/ — SKILL.md format compliance |
| SKL.AUDIT.TERM | stateful-auditor | backup | terms/ — structural and semantic compliance |
| SKL.AUDIT.TOOL | stateful-auditor | `audit-tool/` | .ts files — export default tool, crashOnError, import _lib/, @toolclass, read/write sep |
| SKL.AUDIT.UMBRELLA.TERMS | stateful-auditor | backup | Shared prefix terms — bidirectional links, flat hierarchy, enumeration |

---

## Bootstrapping & Scaffolding

| Skill | State | Dir | Purpose |
|-------|-------|-----|---------|
| SKL.BOOTSTRAP.DB | stateful-writer | `bootstrap-db/` | New DB project → define domain/groupings/entities/properties → scaffold tools → verify |
| SKL.SCAFFOLD.TOOLS | hybrid | `scaffold-tools/` | Generate lib/, tools/, AGENTS.md from manifests + schema |

---

## Classification

| Skill | State | Dir | Purpose |
|-------|-------|-----|---------|
| SKL.CLASSIFY.TOOL | hybrid | `classify-tool/` | Classify .ts tool by automata model (RECG/TRNS/GENR/SGNL) via I/O table |
| SKL.CATEGORIZE.PAPERS | hybrid | `categorize-papers/` | Move PDFs to findings/{domain}/{subdomain}/ → reindex → prune stale → verify |

---

## Orchestration & Research

| Skill | State | Dir | Purpose |
|-------|-------|-----|---------|
| SKL.ORCHESTRATE.RESEARCH | hybrid | `orchestrate-research/` | /xsearch (single) or /xresearch-geo (cross-region); synthesizes, logs, deduplicates |
| SKL.ORGANIZE.PAPERS | hybrid | `organize-papers/` | Classify → curl/PW acquire → file-verify → place → report |
| SKL.SEARCH.GEO | hybrid | `search-geo/` | Per-region search (Exa) → fetch → synthesize → source audit (commercial ratio ≤30%) → compile manifest |
| SKL.STUDY.FOUNDATIONS | hybrid | `study-foundations/` | Foundations → decompose → /xresearch-geo → academic-source check |
| SKL.SEARCH.PAPERS | stateless | `search-papers/` | arxiv-search tool → present results → optional download |
| SKL.SEARCH.PATTERNS | stateless | `search-patterns/` | patlib_search → vector hybrid → keyword → read-projection for patterns |
| SKL.SEARCH.PROTOCOLS | stateless | `search-protocols/` | patlib_search → vector hybrid → keyword → read-projection for protocols |
| SKL.SEARCH.MAXIMS | stateless | `search-maxims/` | patlib_search → vector_search → patlib_get for maxims (Ring 0) |
| SKL.SEARCH.NEXUS | stateless | `search-nexus/` | patlib_search → vector_search → read-projection for nexus compositions |

---

## Proposal (detect → propose → create → sync)

| Skill | State | Dir | Purpose |
|-------|-------|-----|---------|
| SKL.PROPOSE.COMMAND | hybrid | `propose-command/` | Infer verb-domain → check glob + patlib → write .md + .yaml → write-sync |
| SKL.PROPOSE.INVESTIGATION | hybrid | `propose-investigation/` | Infer topic → check existing → search-geo → write meta-audit + schema + seed → audit |
| SKL.PROPOSE.MCP | hybrid | `propose-mcp/` | Detect persistent-service need → architecture layer check → design purity structure → write server → stdio smoke test |
| SKL.PROPOSE.PATTERN | hybrid | `propose-pattern/` | Entity classification → check patlib → write PAT.*.md → write-sync |
| SKL.PROPOSE.PROTOCOL | hybrid | `propose-protocol/` | Entity classification → check patlib → write PROT.*.md → write-sync |
| SKL.PROPOSE.RULE | hybrid | `propose-rule/` | Infer ID → check patlib → write .yaml + .md → write-sync |
| SKL.PROPOSE.TERM | hybrid | `propose-term/` | Entity classification → check patlib → write TERM.*.md → write-sync |
| SKL.PROPOSE.TOOL | hybrid | `propose-tool/` | Infer tool name → determine automaton class → write .ts → read-validate |
| SKL.VET.PROPOSAL | hybrid | `vet-proposal/` | Problem statement → entity type → existence → quality → orthogonality → verdict |

---

## Reference Skills (stateless, MCP tool references)

| Skill | Dir | Purpose |
|-------|-----|---------|
| SKL.USE.CONTEXT.SEVEN | `use-context-seven/` | Context7 MCP — resolve library ID → query docs |
| SKL.USE.ENTITY.AUDIT | `use-entity-audit/` | mcp-entity-audit — entity_audit_all/file by path |
| SKL.USE.EXA | `use-exa/` | Exa MCP — semantic web search, clean markdown fetch |
| SKL.USE.PARALLEL.SEARCH | `use-parallel-search/` | Parallel Search MCP — multi-query search + page fetch |
| SKL.USE.PATLIB | `use-patlib/` | mcp-patlib — search, get, validate entities |
| SKL.USE.PLAYWRIGHT.AI.MODE | `use-playwright-ai-mode/` | Google AI Mode (udm=50) — navigate → snapshot → chat → extract |
| SKL.USE.PLAYWRIGHT.CORE | `use-playwright-core/` | Navigation, click, type, screenshot, tab management, form fill |
| SKL.USE.PLAYWRIGHT.DEBUG | `use-playwright-debug/` | browser_run_code, evaluate, console, asserts, trace, video, PDF |
| SKL.USE.PLAYWRIGHT.NETWORK.STORAGE | `use-playwright-network-storage/` | Mock routes, cookies, localStorage, sessionStorage, auth state |
| SKL.USE.PLAYWRIGHT.VISION | `use-playwright-vision/` | Mouse coordinates — click/drag/move/wheel for canvas/custom UI |
| SKL.USE.SPEC.AUDIT | `use-spec-audit/` | mcp-spec-audit — spec_audit_file/text against PROT.LLM.SPECIFICATION |
| SKL.VALIDATE.SPEC | stateful-reader | `validate-spec/` | spec_audit_file → 5 manual checks → merge → compliance score |

---

## Analysis & Reasoning

| Skill | State | Dir | Purpose |
|-------|-------|-----|---------|
| SKL.QUANTITATIVE.REASONING.ANALYSIS | hybrid | `reason-quantitative/` | Scope quantities → model relationships → reason → check → communicate |
| SKL.VERBAL.REASONING.ANALYSIS | hybrid | `reason-verbal/` | Survey → extract → map structure → infer → evaluate → synthesize |
| SKL.JUDGE.SEMANTIC | hybrid | `judge-semantic/` | Extract noun phrases → query patlib → classify Exact/Overlap/Related/Distinct → verdict |

---

## Maintenance

| Skill | State | Dir | Purpose |
|-------|-------|-----|---------|
| SKL.PRUNE.STALE | stateful-writer | `prune-stale/` | Inventory DB → compare files → report stale → confirm → delete → verify 404 |
| SKL.STAGE.CREATE | stateful-writer | `stage-create/` | Plan multi-entity → vet each → create one at a time → sync + audit each → cross-ref pass → final audit → prune |
| SKL.REFACTOR.SKILL | hybrid | `refactor-skill/` | Read SKILL.md → check agentskills criteria → add trigger/procedure/gotchas/rules → remove voice/example |
| SKL.FORMAT.COMMAND | stateless | `format-command/` | Frontmatter (description, subtask: true) → action entry → numbered steps → report table → code block |
| SKL.QUERY.NERDFONT | stateful-reader | `query-nerdfont/` | Query nerdfont DB for icon names/codepoints — no training memory, no external refs |

---

## Guidance

| Skill | State | Dir | Purpose |
|-------|-------|-----|---------|
| SKL.GUIDE.ARCHITECTURE | stateless | `guide-architecture/` | Layer decision tree: Rule → Abstraction → Protocol → Apologia → Term → Illustration → Pattern → Skill → Command → Tool → Plugin → MCP |
| SKL.GUIDE.REASONING | stateless | `guide-reasoning/` | MAX.* → SPEC.* → IDENTITY.* → PROT.* — consult in order |
| SKL.GUIDE.WEB | hybrid | `guide-web/` | modern-web-guidance@latest CLI — search guides → retrieve → adapt with browser support policy |
| SKL.GUIDE.MAXIMS.PROTOCOLS | stateless | `read-maxims-protocols/` | Maxims first (Ring 0 philosophy), protocols second (contracts), then proceed |

---

## State Profile Summary

| Profile | Count | Skills |
|---------|-------|--------|
| stateless | 22 | compose-web, report-outcomes, use-playwright-core, knowledge-ruby, read-maxims-protocols, search-papers, search-patterns, search-protocols, search-maxims, search-nexus, format-command, guide-architecture, guide-reasoning, use-context-seven, use-entity-audit, use-exa, use-parallel-search, use-patlib, use-playwright-ai-mode, use-playwright-core, use-playwright-debug, use-playwright-network-storage, use-playwright-vision, use-spec-audit |
| hybrid | 22 | acquire-acm, audit-crossref, categorize-papers, classify-tool, guide-web, judge-semantic, orchestrate-research, organize-papers, propose-command, propose-investigation, propose-mcp, propose-pattern, propose-protocol, propose-rule, propose-term, propose-tool, refactor-skill, scaffold-tools, search-geo, stage-create, study-foundations, vet-proposal |
| stateful-auditor | 8 | audit-abstraction, audit-apologia, audit-investigation, audit-maxim, audit-nexus, audit-protocol, audit-tool |
| stateful-reader | 2 | query-nerdfont, validate-spec |
| stateful-writer | 3 | bootstrap-db, prune-stale, stage-create |
