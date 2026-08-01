# Region: China

**Date:** 2026-07-22
**Language:** Chinese, English
**Status:** PASS

## Queries
1. `AI论文质量筛选工具 学术论文过滤平台 人工智能论文质量评估 arxiv噪声`
2. `中国AI论文质量评估 学术不端检测工具 论文筛选 site:edu.cn OR site:ac.cn`

## Sources Fetched

| Source | Institution | Type | Key Content |
|--------|-------------|------|-------------|
| arXiv-Paper-Quality-Filter (henrypan1993) | Individual | tool | CCF-based AI paper filtering; RPA-crawled arxiv; matches accepted/publication status |
| Arxiv-Insight-Sentinel (liftkkkk) | Individual | tool | Daily arxiv scoring by research interest; LLM rates 0-10; Top 10 digest |
| paper_daily (deadpoppy) | Individual | tool | Multi-source (arXiv, OpenAlex, S2, CrossRef, PwC); 5D scoring; academic value LLM judge |
| Hermes4ArXiv (LEtorpedo) | Individual | tool | GitHub Actions daily tracking; 5-star scoring; email digests |
| Paper Insight (imagist13) | Individual | tool | Conference paper screening; code/task/metrics/baseline extraction |
| Citation Assistant (ZhangNy301) | Individual | tool | S2 API + CCF/JCR ranking; multi-dimensional quality scoring; BibTeX generation |
| AI Paper Summary (SJeffZhang) | Individual | platform | Daily bilingual paper system; multi-source crawling; 8-class scoring; Focus/Watching tiers |
| KynixInHK/arxiv-daily-researcher | Individual | tool | Dual-LLM weighted scoring; deep PDF analysis; 7-dimension extraction; trend analysis |
| FanBroWell/AI-paper-reviewer | Individual | tool | 10-dimension review framework; 4-level red flag system; NeurIPS/ICML focused |
| cnki.ac.cn (CNKI) | Government | platform | China's national academic database; plagiarism detection; AIGC detection |
| AIGC-CHECK (checkaigc.ac.cn) | Government | tool | Official AIGC detection system; supports 15+ Chinese LLMs; ISTIC-backed |
| 文察-综合察验 (Wencha) | Wanfang Data | platform | Multi-factor academic integrity: text similarity, image reuse, AIGC risk, citations |
| 基于多维特征的AI生成期刊论文 (kmf.ac.cn) | Academic | paper | 8-dimension AIGC detection framework; dual verification method |
| AiReview (Shanghai) | Academic | tool | LLM-based systematic review platform (SIGIR 2025) |

## PASS/WARN/FAIL
- Query 1: PASS — 10 results, 6+ relevant (many open-source tools)
- Query 2: PASS — 10 results, 7+ relevant (government/academic systems well covered)

## Gaps
- Most Chinese filtering tools are individual GitHub projects, not institutional
- CNKI is dominant but closed/proprietary
- AIGC detection systems are policy-driven (government mandate)
- Few tools handle cross-language (Chinese + English) filtering
