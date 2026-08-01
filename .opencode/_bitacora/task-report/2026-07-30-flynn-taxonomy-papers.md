# Task Report — Flynn Taxonomy Paper Acquisition

Timestamp: 2026-07-30T20:29:09Z
Project: `_findings` (paper catalog) + root assembler
Task: acquire papers on Flynn taxonomy, register in findings.db

## What was done

1. **Paper set identified** — canonical Flynn taxonomy corpus:
   - Flynn 1966, "Very High-Speed Computing Systems", Proc. IEEE 54(12):1901–1909, DOI 10.1109/PROC.1966.5273
   - Flynn 1972, "Some Computer Organizations and Their Effectiveness", IEEE Trans. Computers C-21(9):948–960, DOI 10.1109/TC.1972.5009071
   - Duncan 1990, "A Survey of Parallel Computer Architectures", Computer 23(2):5–16, DOI 10.1109/2.44900
   - Extension candidate: "A Taxonomy for Computer Architectures", Computer 1988, DOI 10.1109/2.86786 (not acquired — paywalled)

2. **Existing holdings verified** — `_findings/simd-architectures/` already held Flynn 1972 (13pp) and Duncan 1990 (12pp); both valid PDFs. DB rows present but with file_size=0 / journal empty (registered via older scan path; data-quality artifact).

3. **Flynn 1966 acquired** — curl from safari.ethz.ch (Wikipedia-linked open-access PDF): `_findings/simd-architectures/flynn-1966-very-high-speed-computing-systems.pdf`, 9 pages, 982,128 bytes, `file`-verified.

4. **Registration tool created** — `_findings/.opencode/tools/papers-add.ts` (TRNS class): reusable CLI for registering any downloaded PDF with explicit metadata. Prevents recurrence of forgot-`initDB` and wrong-domain-from-path failures (RUL.WORKFLOW.AUTOMATE.BEFORE.FIX).

5. **Lib gap fixed** — `registerPaper` predated enriched schema (02-enriched.sql); dropped topic/source/doi/published_at/journal → NOT NULL crash on `papers.topic`.
   - `lib/types.ts`: `RegisterArgs` + optional `topic`, `source`, `doi`, `published_at`, `journal`
   - `lib/register.ts`: forward with safe defaults (`topic ?? domain`, `source ?? detectSource`, `?? ""` for the rest)
   - Existing callers (arxiv_register, arxiv_pipeline) unaffected — optional fields.

6. **Flynn 1966 registered** — via `papers-add.ts`: id `simd-architectures/flynn-1966-very-high-speed-computing-systems.pdf`, domain/subdomain `simd-architectures`/`classic`, topic `simd-architectures`, source openaccess, DOI/journal/published_at populated.

## Verification

- `findings_search` "Flynn" → 3 papers (1966, 1972, Duncan 1990)
- DB row: file_size=982128, doi=10.1109/PROC.1966.5273, journal=Proceedings of the IEEE, published_at=1966-12-01 ✓
- All 3 PDFs valid on disk (file + pdfinfo)

## Decisions made

- Option A fix (new CLI tool + lib forwarding) over one-off script — tool prevents recurrence.
- Lib fix with safe defaults rather than lazy initDB — preserves entry-point-inits convention across 38 call sites.
- topic defaults to domain — matches existing rows where topic == domain.

## Open edges

- Flynn 1972 / Duncan 1990 rows lack file_size and journal in DB (files valid on disk). Optional backfill via papers-add rerun (idempotent upsert) or papers-enrich.
- 1988 extension paper (DOI 10.1109/2.86786) not acquired — IEEE/ACM paywalled; requires CAPTCHA gate handling per RUL.WORKFLOW.CAPTCHA.GATE.
- papers-add.ts not yet registered in any AGENTS.md tool table (auto-discovered via `.opencode/tools/`).

## Todo state summary

- [x] Identify Flynn taxonomy paper set (1966, 1972, extensions)
- [x] Acquire Flynn 1966 'Very high-speed computing systems' PDF
- [x] Verify acquired PDFs (file, pdfinfo)
- [x] Register new papers in findings.db
- [x] Report summary of acquired set

## Flow test (append — 2026-07-30)

Full pipeline tested end-to-end after acquisition: query → verify → register → embed → semantic search.

| Step | Result |
|------|--------|
| `findings_search` / `findings_get` "Flynn" | 3 papers resolve |
| `papers-query` detail + tag filter | all 18 fields incl. source metadata |
| `papers-add` guards (missing args, missing file, bad content) | usage/errors, exit 1 |
| `papers-add` idempotent upsert | 1 row, no duplicate |
| `papers-embed --domain simd-architectures` | 5 embedded, 395 total embeddings |
| `papers-semantic-search` "Flynn taxonomy SISD SIMD MISD MIMD" | Flynn 1972 (92.5%), Duncan 1990 (75.2%), Flynn 1966 (63.6%) top 3 |

### Bugs found and fixed during flow test

1. **`papers-embed.ts` `--domain` filter NULL-bind** — SQL built `WHERE domain = ?` but `.all()` passed no parameter → NULL bind, filter always returned 0 rows. Fixed: `.all(domainFilter)` in the parameterized branch. Pattern scan confirms no other occurrences.
2. **`@xenova/transformers` resolution gap** — findings `.opencode/node_modules` lacked the scope; only root `.opencode/node_modules` had it. AGENTS.md convention "Deps via root symlink" not in place. Fixed: symlink `_findings/.opencode/node_modules/@xenova` → root. Embed verified (384-dim). Context7 confirms modern replacement `@huggingface/transformers` (same `pipeline` API) for future migration.

### Open edges (updated)

- 1988 Skillicorn paper — **RESOLVED**: open-access mirror acquired at `_findings/simd-architectures/skillicorn-1988-taxonomy-computer-architectures.pdf` (12pp OCR'd copy, registered + embedded, #3 semantic). computer.org/ACM originals paywalled at $36.
- `@xenova/transformers` symlink consistent with findings AGENTS.md "Deps via root symlink" convention; consider `@huggingface/transformers` migration.
- Flynn 1972 / Duncan 1990 rows backfilled (file_size, journal, published_at, source; Duncan DOI corrected to 10.1109/2.44900).

### Corpus (final)

| Paper | DOI | Embed rank |
|-------|-----|-----------|
| Flynn 1966, "Very High-Speed Computing Systems" | 10.1109/PROC.1966.5273 | #4 |
| Flynn 1972, "Some Computer Organizations and Their Effectiveness" | 10.1109/TC.1972.5009071 | #1 (89.2%) |
| Duncan 1990, "A Survey of Parallel Computer Architectures" | 10.1109/2.44900 | #2 (71.9%) |
| Skillicorn 1988, "A Taxonomy for Computer Architectures" | 10.1109/2.86786 | #3 (63.3%) |

### Transformers.js migration (append — 2026-07-30)

`@xenova/transformers` v2 → `@huggingface/transformers` v4.2.0 (Context7-verified, same `pipeline` API).

- Root `.opencode/package.json`: added `@huggingface/transformers ^4.2.0` (npm `latest` verified); `@xenova` later fully removed — `_disabled/embedder-onnx.ts` migrated to `@huggingface/transformers`, npm pruned (11 packages), stale root dir + findings symlink deleted. No code references remain.
- Root `.opencode/_lib/embed.ts`: import + depends-on comment updated.
- Findings `.opencode/lib/embedder.ts`: type import + lazy `await import()` + comments updated.
- Symlink: `_findings/.opencode/node_modules/@huggingface` → root (deps convention).
- Tests: root `vector()` 384-dim, `batch()` 3×384; findings `embed()` 384-dim; `papers-semantic-search` end-to-end OK — rankings preserved (89.2% → 89.8% query-side drift, same model `Xenova/bge-small-en-v1.5`).
- Stored embeddings (396) unaffected; same model → identical vectors.

### Open edges (final)

- **Dasgupta 1990, "A Hierarchical Taxonomic System for Computer Architectures"** (Computer 23(3):64–74, DOI 10.1109/2.50273) — NOT acquired. Extends Skillicorn's scheme with chemical-notation formulas. **Confirmed closed-access via Unpaywall (`is_oa: false`) and Semantic Scholar (`openAccessPdf.status: CLOSED`)**; ACM DL / IEEE Xplore / CSDL paywalled, no mirror exists. Requires purchase or institutional access. Deliberately not bypassed.
- `papers-{add,embed,enrich,prune,record}` in findings AGENTS.md tool table (done).

### Companion acquisition (append — 2026-07-30)

**Amdahl 1967, "Validity of the Single Processor Approach to Achieving Large Scale Computing Capabilities"** — acquired via ETH safari mirror (Berkeley copy failed; ETH succeeded), 4pp, 287,328 B, file-verified. Registered + embedded via `papers-add`: `simd-architectures/amdahl-1967-single-processor-approach.pdf`, DOI 10.1145/1465482.1465560, AFIPS SJCC 1967. Semantic rank #1 (85.4%) for "parallel speedup sequential bottleneck Amdahl". Corpus now 5 papers: Flynn 1966, Flynn 1972, Duncan 1990, Skillicorn 1988, Amdahl 1967.

