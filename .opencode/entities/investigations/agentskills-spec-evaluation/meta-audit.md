---
id: MANIFEST.AGENTSKILLS.SPEC.EVALUATION
title: Agentskills.io Skill Format Evaluation
summary: Compare agentskills.io specification against the assembler project's skill format across structural completeness, discoverability, maintainability, and real-world usefulness. Single-source evaluation of five agentskills pages (specification, best practices, evaluating skills, optimizing descriptions, using scripts).
tags: [skill, format, specification, audit, evaluation, compartment]
tables: [Fundamentals, Meta-analyses, By Region, Gaps]
---

**agentskills spec frees body content but lacks state-awareness; our format enforces structure but over-prescribes** — agentskills mandates only `name`+`description` frontmatter with zero body restrictions, while our `audit-skills` enforces Trigger/Procedure/Rules/Gotchas sections that fail low-value reference-table skills. agentskills brings superior tooling (trigger evals, assertion-based evals, description optimization loops) that we lack entirely. Its missing `state-profile` is a genuine gap for agent routing. Neither format is strictly better — they serve different design philosophies (guideline vs enforcement).

---

## Fundamentals

### agentskills specification

| Field | Required | Constraints | Our equivalent |
|-------|----------|-------------|----------------|
| `name` | Yes | 1-64 chars, lowercase+hyphens, must match parent dir | Same |
| `description` | Yes | 1-1024 chars, include trigger keywords | Same — no trigger-optimization loop |
| `license` | No | Short name or bundled file ref | None |
| `compatibility` | No | 1-500 chars, environment requirements | None |
| `metadata` | No | Arbitrary key-value map | We use separate `state-profile` field |
| `allowed-tools` | No (experimental) | Space-separated tool permission strings | None |
| Body content | No restrictions | Recommend split >500 lines / >5000 tokens | Rigid: Trigger/Procedure/Rules/Gotchas |

### Key philosophy difference

| Dimension | agentskills | Our format |
|-----------|-------------|------------|
| **Spec scope** | Minimal — says what's mandatory | Extended — `state-profile` added |
| **Body rules** | "No format restrictions" | `audit-skills` enforces 4 required sections |
| **Validation** | `skills-ref validate` CLI (frontmatter only) | Custom `audit-skills` tool (frontmatter + body sections) |
| **Best practices** | Separate docs — not enforced | Fused into audit — violation = failure |
| **Dir structure** | `SKILL.md` + optional `scripts/`, `references/`, `assets/` | `SKILL.md` only — no `scripts/`, `references/`, or `assets/` |
| **Progressive disclosure** | Metadata at startup → body on activate → refs on demand | Not leveraged — audit loads full file |

### Value Propositions

agentskills claims the format delivers three values. Assessment:

| Value | agentskills | Our format |
|-------|-------------|------------|
| Domain expertise | ✅ Free body → any specialized knowledge | ✅ Sections enforce structure, but Overhead for reference-only skills |
| Repeatable workflows | ✅ Best practices define gotchas/templates/checklists | ✅ Trigger/Procedure/Gotchas aligns |
| Cross-product reuse | ✅ Supported by 40+ tools (Junie, Gemini CLI, Claude Code, Copilot, Cursor, OpenCode) | ❌ Only works in our agent |

Originally developed by Anthropic and released as an open standard.

### Section rigidity trade-off

**agentskills approach**: spec says nothing about body structure. Best practices *recommend* Gotchas sections, templates, checklists — but they're guidance, not requirements.

```
spec: minimal (name + description required, body free)
best-practices: advisory (gotchas, templates, checklists recommended but optional)
validation: frontmatter only (skills-ref validate)
```

**Our approach**: `audit-skills` enforces Trigger/Procedure/Rules/Gotchas as required sections. A reference-table-only skill that needs zero procedure gets 4 violations.

```
spec: extended (name + description + state-profile required, body has section requirements)
best-practices: fused into enforcement (audit fails on missing sections)
validation: full file (frontmatter + body sections)
```

---

## Meta-analyses

| ID | Analysis | Key finding | Our status | Priority |
|----|----------|-------------|------------|----------|
| MA.BODY.FREEDOM | Body Section Enforcement Trade-off | agentskills body freedom allows reference-table and workflow skills to coexist without audit friction. Our rigid section enforcement adds overhead for pure-reference skills | audit-skills fails reference-only skills (4 violations) | high |
| MA.DESC.PRINCIPLES | Description Writing Principles | agentskills prescribes 4 principles: imperative phrasing, focus on user intent, err on pushy side, concise <1024 chars. Our descriptions are static, no principles applied | No writing principles or iterative refinement | medium |
| MA.DESC.OPT | Description Trigger Eval Loop | 20 queries (8-10 should-trigger, 8-10 should-not), vary phrasing/explicitness/detail/complexity, near-misses, 3 runs each, threshold 0.5, train/val ~60/40, loop ≤5 iterations. skill-creator automates. We have none | No trigger testing or optimization loop | medium |
| MA.EVAL.FRAMEWORK | Eval Framework — Test + Grade | agentskills provides full pipeline: evals.json, assertions with concrete evidence, grading.json, blind LLM comparison, benchmark.json with with/without/delta. We have nothing | No test cases, assertions, or grading | low |
| MA.EVAL.PATTERNS | Eval — Pattern Analysis | 5 analysis patterns: remove always-pass, investigate always-fail, study pass-with-skill, tighten inconsistent runs, check outliers | No eval data to analyze | low |
| MA.EVAL.HUMAN | Eval — Human Review + Iteration | feedback.json with actionable feedback. 5-step loop: signal→LLM→revise→rerun→grade→review. Guidelines: generalize, keep lean, explain why, bundle | No human review or iteration | low |
| MA.PROGRESSIVE | Progressive Disclosure Advantage | agentskills three-tier loading (metadata→body→refs) minimizes context footprint. Our audit loads full SKILL.md on activation with no references/ directory | Full file loaded at activation | medium |
| MA.STATE.PROFILE | State Profile Advantage | Our state-profile field (stateless, stateful-reader, stateful-writer, stateful-auditor, hybrid) tells agent whether skill maintains state. agentskills has no equivalent | Unique advantage — keep field | high |
| MA.SCRIPT.ALIGNMENT | Script Patterns Alignment | Strong alignment on inline deps, --help, no prompts, structured output, data/diag separation, idempotency, dry-run, exit codes, safe defaults. Minor gaps: Ruby bundler/inline, predictable output size handling, compatibility field for prereqs | Strong alignment — small gaps | low |
| MA.BP.PATTERNS | Best Practices Patterns | agentskills recommends 6 instruction patterns: gotchas (highest-value), templates, checklists, validation loops, plan-validate-execute, bundling scripts. We use gotchas and bundling only | Partial — gotchas + bundling only | medium |
| MA.BP.SOURCES | Source Material Synthesis | agentskills lists 5 concrete artifact types for skill synthesis: runbooks/style guides, API specs/configs, code review/issue trackers, git history/patches, failure cases. We have no equivalent pipeline | Skills from scratch or task extraction only | medium |
| MA.BP.REFINEMENT | Real-Execution Refinement | agentskills prescribes execute→revise loop: run against real tasks, read execution traces, feed back. 3 waste causes: vague instructions, inapplicable, too many options. We create once, rarely revise | No systematic refinement or trace diagnosis | medium |

### Spec Comparison

| Criterion | agentskills | Our format | Verdict |
|-----------|-------------|------------|---------|
| Frontmatter name | ✅ 1-64 chars, lowercase+hyphens | ✅ Same | Match |
| Frontmatter description | ✅ 1-1024 chars | ✅ Same, no length enforcement | Slight edge agentskills |
| State awareness | ❌ None | ✅ `state-profile` field | Our edge |
| Body section requirements | ❌ None — free form | ❌ Rigid 4-section enforcement | Neither optimal |
| Scripts directory | ✅ `scripts/` referenced | ❌ Skill dir flat | agentskills edge |
| Refs directory | ✅ `references/`, `assets/` for on-demand loading | ❌ None | agentskills edge |
| Progressive disclosure | ✅ Metadata→Body→Refs | ❌ All loaded at once | agentskills edge |
| Validation tooling | ✅ `skills-ref validate` | ✅ Custom `audit-skills` | Match |
| Description optimization | ✅ Systematic eval loop | ❌ Static description | agentskills edge |
| Output evaluation | ✅ Assertions + baselines + benchmarks | ❌ None | agentskills edge |

### Recommendation: section flexibility tiers

| Tier | Skills | Section requirement |
|------|--------|---------------------|
| `reference` | Pure lookup — tool tables, API signatures | No sections required |
| `procedure` | Multi-step workflow — step-by-step instructions | Procedure + Gotchas recommended |
| `full` | Complex domain — process, rules, gotchas | All 4 sections |

---

## By Region

### Specification

| Source | Section | Key content | URL |
|--------|---------|-------------|-----|
| SPEC.MAIN | Specification | Required: name (1-64 chars, lowercase+hyphens, matches dir) + description (1-1024 chars). Optional: license, compatibility (1-500 chars), metadata (key-value), allowed-tools (experimental, space-separated). Dir: SKILL.md + optional scripts/, references/, assets/. Progressive disclosure: metadata (~100 tokens) → body (<5000 tokens) → refs on demand. File refs: relative, one level deep. Validation: skills-ref CLI | https://agentskills.io/specification |

### Best Practices

| Source | Section | Key content | URL |
|--------|---------|-------------|-----|
| BP.MAIN | Best Practices | Start from real expertise: extract from hands-on tasks or synthesize from project artifacts (runbooks, API specs, code reviews, git history, failure cases). Refine with real execution: read execution traces, not just outputs; 3 root causes of wasted time: vague instructions, inapplicable instructions, too many options without default. Context: add what agent lacks, omit what it knows; coherent units; moderate detail; progressive disclosure. Calibrate: specificity to fragility; defaults not menus; procedures over declarations. Patterns: gotchas, templates, checklists, validation loops, plan-validate-execute, bundling scripts | https://agentskills.io/skill-creation/best-practices |

### Evaluating Skills

| Source | Section | Key content | URL |
|--------|---------|-------------|-----|
| EVALS.MAIN | Evaluating Skills | Test cases: prompt + expected + optional files; start 2-3, vary, edge cases, realistic context. Workspace: iteration-N/eval-name/with_skill|without_skill/outputs/ + timing.json + grading.json. Assertions: verifiable pass/fail with evidence. Grading: PASS/FAIL + concrete evidence; blind LLM comparison. Benchmark: with/without/delta pass_rate/time/tokens (mean+stddev). Pattern analysis (5): remove always-pass, investigate always-fail, study pass-with-skill, tighten inconsistent, check outliers. Human review: feedback.json with actionable feedback. Loop: signal→LLM→revise→rerun→grade→review; stop when satisfied | https://agentskills.io/skill-creation/evaluating-skills |

### Optimizing Descriptions

| Source | Section | Key content | URL |
|--------|---------|-------------|-----|
| DESC.MAIN | Optimizing Descriptions | 4 writing principles: imperative phrasing, focus on user intent, err on pushy side, concise (<1024 chars). 20 queries: vary phrasing/explicitness/detail/complexity. Near-misses for should-not. Test 3x each, trigger rate threshold 0.5. Train/val ~60/40 split, proportional mix. Loop: evaluate both → identify train failures → revise (narrow/broaden/generalize/restructure) → repeat ≤5 iterations. Select best by validation pass rate. skill-creator Skill automates | https://agentskills.io/skill-creation/optimizing-descriptions |

### Script Patterns

| Feature | agentskills | Our usage |
|---------|-------------|-----------|
| Inline deps (PEP 723) | ✅ `# /// script` + `uv run` | Same with Bun |
| Ruby bundler/inline | ✅ `bundler/inline` with `gemfile do` | Not used |
| Version pinning | ✅ `@1.0.0` for reproducibility | ✅ `@` in Bun imports |
| `--help` output | ✅ Required | ✅ Yes |
| No interactive prompts | ✅ Hard requirement | ✅ Yes |
| Helpful error messages | ✅ Required | ✅ Yes |
| Structured output (JSON) | ✅ Delimited formats preferred | ✅ Yes |
| Separate data/diagnostics | ✅ stdout data, stderr diag | ✅ Yes |
| Predictable output size | ✅ Summary default, `--offset`/`--output` for large | Not implemented |
| Complex→script migration | ✅ Move complex commands into tested scripts | ✅ Sometimes |
| Compatibility field | ✅ Prerequisites in frontmatter | Not used |
| Idempotency | ✅ Recommended | ✅ Yes |
| Dry-run support | ✅ For destructive ops | ✅ Yes |
| Exit codes | ✅ Meaningful codes documented | ✅ Yes |
| Safe defaults | ✅ Explicit confirm flags | ✅ Yes |

---

## Gaps

| ID | Gap | Severity | Impact |
|----|-----|----------|--------|
| GAP.DESC.OPT | No description trigger-eval loop — skills may not activate when needed or may trigger when irrelevant | high | Skills unreliable activation; no way to measure or improve trigger accuracy |
| GAP.SECTION.RIGIDITY | audit-skills enforces Trigger/Procedure/Rules/Gotchas for all skills including pure-reference | high | Reference-table skills get 4 violations for unnecessary prose sections |
| GAP.EVAL.FRAMEWORK | No eval framework — cannot measure whether skill improves output quality or by how much | medium | No quantitative basis for skill improvement decisions |
| GAP.PROGRESSIVE | No progressive disclosure — full SKILL.md loads on activation with no references/ directory | medium | Context bloat for large skills; no way to load detail on demand |
| GAP.DESCRIPTION.LENGTH | No hard limit on description length — agentskills enforces 1024 chars | low | Risk of bloated descriptions wasting context at startup |

### Summary of recommendations

| Change | Priority | Effort |
|--------|----------|--------|
| Relax `audit-skills` to not require sections for reference-only skills | High | Low — add `type: reference` to frontmatter |
| Adopt agentskills frontmatter as base + keep `state-profile` as optional metadata | High | Medium — rewrite `audit-skills` |
| Keep `state-profile` but make optional (fits agentskills `metadata` field) | High | Low — move field |
| Add description trigger-eval loop | Medium | High — requires tooling |
| Adopt progressive disclosure — split large skills into `references/` | Medium | Medium — convention change |
| Add eval framework (assertions, baselines) | Low | High — nice-to-have |
