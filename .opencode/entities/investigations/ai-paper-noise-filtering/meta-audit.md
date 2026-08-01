# Investigation: AI Paper Noise Filtering & Top Papers Indexers

**Date:** 2026-07-22
**Method:** `/xresearch-geo` — 5 regions
**Status:** COMPLETE

---

## Fundamentals

The volume of AI research has outpaced any individual's capacity to keep pace. arXiv alone receives ~30,000 submissions/month (Paper Espresso, 2026). Organization Science reports a 42% submission increase post-ChatGPT with writing quality declining 1.28 SD (Gartenberg, 2026). Two distinct problem areas emerge:

1. **Noise filtering:** Automated tools to screen, score, and rank papers by relevance/quality
2. **Paper indexers:** Platforms that curate, organize, and surface high-impact research

---

## Top Papers Indexers (Global)

| Platform | Source | Coverage | Key Feature | Region |
|----------|--------|----------|-------------|--------|
| **Semantic Scholar** (S2AG) | Allen AI | 205M papers, 121M authors | AI-generated TLDR; citation graph; free API | US |
| **Papers With Code** (PwC/LPWC) | Community | 400K ML papers | Code links; benchmarks; RDF KG (8M triples) | Global |
| **ResearchScope** | Independent | 100K+ CS papers | 6-signal scoring (0-10); venue recommender | US/Global |
| **Paper Espresso** | Community | 13K trending papers | LLM topic labeling; trend lifecycle analysis | US/EU |
| **Scholar Inbox** | Academic | 800K user ratings | Active learning; personalized recs; open dataset | EU |
| **Hugging Face Daily Papers** | HF | ~2-3% of arXiv | Community curation; upvote-sorted | US |
| **CiNii Research** | NII Japan | 180M items | Japanese academic integration; data matching | JP |
| **KISTI ScienceON** | KISTI Korea | National | Korean academic portal; patents + journals | KR |
| **Naver Academic** | Naver | National | Korean academic search engine | KR |
| **Baidu Scholar** | Baidu | National | Chinese academic search; linked to J-STAGE | CN |
| **CNKI** | Government CN | National | China's primary academic database | CN |
| **arXiv Daily.tech** | Independent | Multi-source | Bilingual (ZH/EN); focus/watching tiers | CN |
| **AIPapers.ai** | Commercial | Daily arxiv | 49-field metadata; vector search | Global |
| **arxlens** | Commercial | Curated | AI-reviewed feed; challenge threads | US |
| **Scopus AI** | Elsevier | 30K+ journals | Vector search + LLM summaries; citation-verified | Global |

---

## Noise Filtering Tools (By Region)

### US/UK/English-Western

| Tool | Method | Key Metric | Cost |
|------|--------|------------|------|
| Paper-Screening-Agent | LLM scoring (1-10) + tiered routing | 200+ concurrent | API costs |
| arXiv Radar | pgvector + BM25 hybrid (RRF) | Self-hosted | Free (Docker) |
| arxiv-sanity-lite | SVM + embedding similarity | Citation-agnostic | Free |
| Daily-Papers | Gemini 4-dimension scoring (0-100) | Free API | Free |
| OpenReviewer | Multi-agent pipeline (15 agents) | Evidence-driven | API costs |

### China

| Tool | Method | Key Metric | Cost |
|------|--------|------------|------|
| arXiv-Paper-Quality-Filter | CCF-based matching + keyword filter | RPA-crawled | Free |
| Arxiv-Insight-Sentinel | LLM scoring (0-10) + interest profile | Top 10 digest | ~¥0.1-0.3/run |
| paper_daily | 5D scoring (relevance × timeliness × impact × novelty × academic) | SQLite persistent | API costs |
| Hermes4ArXiv | 5-star scoring; 5 analysis dimensions | GitHub Actions | Free |
| Citation Assistant | S2 + CCF/JCR + H-index multi-dim scoring | CLI tool | Free |
| AI-paper-reviewer | 10-dimension review framework; 4 red flags | Prompt toolkit | Free |

### EU

| Tool | Method | Key Metric | Cost |
|------|--------|------------|------|
| LLMSurver | Multi-LLM consensus | Recall >98.8% | Free (browser) |
| MetaScreener | 4-model ensemble + CCA calibration | 95-97% sensitivity | API costs |
| ASReview | Active learning (researcher-in-the-loop) | 95% workload reduction | Free (open-source) |
| AISysRev | LLM screening + OpenRouter | 100-300 papers/min | Free |
| TiAb Review Plugin | LLM batch + ML active learning | WSS@95: 48.7-87.3% | Free (Chrome ext) |
| Agentic Paper Review | Multi-agent (Specialist/Editor/Judge) | Domain-agnostic | API costs |

### India

| Tool | Method | Key Metric | Cost |
|------|--------|------------|------|
| ScholarVault | 18-point conference forensic audit | 12 sec audit; 847 flaglist | Free/Gold ₹399/mo |
| Aletheia-Probe | Multi-source predatory detection | Hybrid DB + pattern analysis | Free (open-source) |
| UGC-CARE (discontinued) | Journal whitelist (1474 journals) | Replaced by suggestive params | Free |

### Japan/Korea

| Tool | Method | Key Metric | Cost |
|------|--------|------------|------|
| PatentNoiseFilter | 3-module ML + user-precision optimization | Targeted patent noise | Commercial |
| AutoEXP | Multi-agent LLM paper search | Named entity coverage | Research |
| Japanese LLM corpus filter | N-gram perplexity filtering | Web corpus quality | Research |

---

## Quality Gate Frameworks

| Framework | Scope | Dimensions |
|-----------|-------|------------|
| AIGC-CHECK (CN) | AIGC detection | 15+ Chinese LLM models; text analysis |
| 文察-Wencha (CN) | Academic integrity | Text similarity, image reuse, AIGC, citations, authors |
| Tessa TES Framework (EU) | Paper trustworthiness | 200 variables; Transparency/Explainability/Significance (TES) |
| Scholix (EU) | Pre-submission review | Methodology (CONSORT/STROBE/PRISMA); stats; citations |
| UGC Suggestive Parameters (IN) | Journal quality | 9 parameters: ISSN, review policy, domain, ethics |
| ResearchScope Scoring (US) | Paper quality | Recency × Novelty × Citations × Institution × Completeness |

---

## Predatory Publishing Detection

| Tool | Region | Coverage | Method |
|------|--------|----------|--------|
| ScholarVault | India | 847+ flagged conferences | 18-point forensic audit |
| Aletheia-Probe | Global | DOAJ + Beall + OpenAlex + Kscien | Hybrid curated DB + pattern analysis |
| UGC-CARE | India | 1474 journals (discontinued) | Protocol-qualified + Scopus/WoS indexed |
| AJPC System | Global | 833 predatory + 1213 legitimate | ML + TF-IDF diff scores |
| CNKI Academic Misconduct | China | National database | Text similarity + AIGC detection |

---

## By-Region Summary

| Region | PASS/WARN/FAIL | Total Sources | Distinct Tools | Key Gap |
|--------|---------------|---------------|----------------|---------|
| US/UK | PASS | 15 | 10 | Multilingual filtering absent |
| China | PASS | 14 | 10 | Most are individual GitHub projects; fragmented |
| EU | PASS | 15 | 10 | Systematic review focus; general filtering sparse |
| Japan/Korea | PASS | 14 | 5 | Patent filtering dominates; AI paper filtering nascent |
| India | PASS | 11 | 4 | Predatory journals focus; no arxiv filtering tools |

---

## Source Audit

| Category | Count | Ratio |
|----------|-------|-------|
| Academic (.edu/.ac.*/.org-academic) | 45 | 65% |
| Commercial (.com/.io) | 15 | 22% |
| Government (.gov/.ac.cn/.go.jp) | 5 | 7% |
| Open-source (GitHub) | 4 | 6% |

Academic equivalent replacements: 3 commercial sources replaced with .edu/.ac.* equivalents.
Commercial ratio: 22% — within threshold (<30%), compilation unblocked.

---

## Key Researchers by Region

| Researcher | Institution | Region | Focus |
|------------|-------------|--------|-------|
| Markus Flicke | Academic | EU | Scholar Inbox; personalized recommendations |
| Michael Färber | KIT | DE | Linked Papers With Code; RDF KG |
| Claudine Gartenberg | Wharton | US | AI impact on peer review; empirical journal analysis |
| Md Kishor Morol | Independent | IN | ResearchScope; CS research intelligence |
| Aleksi Huotala | Academic | EU | AISysRev; LLM screening |
| Yuki Kataoka | Academic | JP | TiAb Review Plugin; browser-based ML screening |
| Ming Zhang | Academic | CN | OpenNovelty; LLM novelty assessment |
| Tirthankar Ghosal | IIT Bombay | IN | Multimodal scope detection; AI peer review |

---

## Gaps

1. **Cross-platform unification** — No single tool aggregates scores from all major indexers
2. **Multilingual filtering** — Most tools filter English only; Chinese/Japanese/Korean papers in arxiv are under-served
3. **Quality metric standardization** — Each tool uses proprietary scoring; no benchmark dataset exists
4. **Real-time arxiv triage** — Tools exist but none combines citation-aware + topic-aware + venue-aware filtering in one pipeline
5. **China's open-source fragmentation** — Many individual GitHub tools; no dominant platform like Semantic Scholar
6. **India arxiv filtering vacuum** — No India-specific arxiv filtering tool; effort focused on predatory journals
7. **Post-ChatGPT quality decline** — Organization Science study shows systemic decline; tools to detect AI-written papers are early-stage
8. **AIGC detection reliability** — CNKI AIGC detection has "low accuracy, high variance, weak sensitivity" (周濛, 2024)
