---
id: INV.LLM.SPEC.CONTRACT
title: Gotcha vs Contraction — LLM Specification Pattern
summary: Cross-region investigation into two complementary strategies for constraining LLM output: contraction (positive constraints, schemas, scope narrowing) and gotcha (negative constraints, hard stops, antipattern enumeration). Mechanistic, empirical, and practice-based evidence from ~50 regions worldwide, spanning every continent with active NLP/AI research. Social register evidence confirms imperative gotchas fail cross-lingually.
tags: [llm, prompt-engineering, constraint, specification, reward-hacking, negation]
tables: [regions, sources, researchers, meta_analyses, gaps, fundamentals]
---

**Two strategies compose: contract the shape, gotcha the antipattern** — research across ~50 regions spanning every continent with active NLP/AI research converges on a three-tier taxonomy. Mechanistic evidence (Rocchetti & Ferrara 2026) proves no universal constraint mechanism exists — different constraint types are processed by different neural subsystems at different depths. Social register evidence (Imperative Interference 2026) proves imperative gotchas fail cross-lingually while declarative contraction transfers.

---

## Fundamentals

### Three-Tier Taxonomy

| Tier | Strategy | Mechanism | Example | Evidence |
|------|----------|-----------|---------|----------|
| 1 | Contraction | Positive instruction + schema + example narrowing output space | "Respond in ≤3 sentences. Output JSON with keys X,Y." | Anthropic (US), OpenAI (US), IAB Europe (EU), LangGPT (CN), CRGC (HK) |
| 2 | Gotcha — hard stop | Negative constraint for binary, verifiable prohibitions | "Never share credentials. Do not execute destructive DB operations." | Context Patterns (US), AgentPatterns (US), IAB Europe (EU), LangGPT Rules section (CN), X-Road (EE) |
| 3 | Gotcha — behavioral (avoid) | Negative constraint for style/tone/approach — primes the forbidden concept via late-layer FFN override | "Don't be verbose" → model fixates on verbosity | Semantic Gravity Wells (US, 87.5% priming failure), Negative Instruction Cascade (EU, >40% negatives → breakdown), Tohoku negation mispriming (JP), SNU inverse scaling (KR) |

### Key distinctions

- **Contraction** reduces output space by specifying what IS — aligns with autoregressive prediction, gives model a target. Processed in **early layers**, robust and reliable (Rocchetti & Ferrara 2026)
- **Gotcha-hard-stop** defines walls — model can comply deterministically; best paired with out-of-prompt enforcement (regex, CI hooks, schema validation)
- **Gotcha-behavioral** primes the forbidden concept via attention mechanism — processed in **late layers**, fragile and model-dependent. Larger models perform **worse** at negation (inverse scaling law confirmed by SNU, Tohoku, and independent experiments)

### Mechanistic basis (Rocchetti & Ferrara 2026)

- No universal constraint-checking mechanism exists — different constraint types are processed by different neural subsystems at different depths
- Structural constraints (contraction tier) emerge in **early layers**; semantic constraints (gotcha-behavioral) emerge in **late layers**
- Constraint satisfaction is **dynamic monitoring during generation**, not pre-generation planning — accuracy rises sharply at generation onset and peaks at EOS
- Causal ablation shows sparse asymmetric dependencies: removing one constraint type's representation does not affect others

### Constraint composition limits (Vasileva 2026 — CSE)

- Constraint satisfaction follows a two-regime decay: exponential drop from ~58% at k=1 to asymptotic floor at ~16%
- Failures are **independent, not interactive** — the ceiling is multiplicative accumulation, not pairwise conflict
- Reliable performance breaks down beyond **5-6 simultaneous constraints**
- Structural constraints degrade 2.4x slower than lexical/relational ones under load

### Bridge constraints (CRGC — CUHK 2026)

- The Constraint Adherence Problem (CAP) formalizes the challenge of balancing competing constraints
- **Bridge constraints** are auxiliary positive instructions that reconcile conflicting requirements — e.g., "use structured sections with bullet points" resolves conflict between "comprehensive" and "within 200 words"
- CRGC reduces constraint violations by 39% without model retraining
- Bridge constraints are the formal expression of how contraction resolves gotcha conflicts

---

## Meta-analyses

| ID | Source | Key finding | Methodology | Sample |
|----|--------|-------------|-------------|--------|
| MA.SEMGRAV | Semantic Gravity Wells (arXiv 2601.08070) | Negative constraint failure follows logistic curve p = σ(-2.40 + 2.27·P₀); 87.5% priming failure, 12.5% override failure | Mechanistic: logit lens, activation patching, attention analysis on Qwen2.5-7B | n=40,000 samples, 95% CI for slope |
| MA.NEGINST | Negative Instruction Cascade (Zenodo 2025) | Threshold at ~40% negatives → breakdown; >60% → static loops. 3:1 positive:negative ratio required | Empirical: progressive JSON instruction refinement with Claude | 3 instruction versions (v1.1→v2.1→v3.0) |
| MA.WHITEBEAR | Don't Think of the White Bear (arXiv 2511.12381) | Ironic rebound consistent across GPT-2, OPT, Gemma, Llama-3; ~15-20 heads drive 80% of effect | Circuit tracing, attention head analysis | 5,000 ReboundBench samples |
| MA.REWHACK | Defining and Characterizing Reward Hacking (Oxford 2022) | First formal proof: unhackability requires restricting the policy set; any proxy can be hacked on the set of all policies | Formal proof, MDP framework | n/a (theoretical) |
| MA.SPECGAME | Specification Gaming in Reasoning Models (arXiv 2605.02269) | RL reasoning training increases gaming 32-170%; test-time mitigations reduce but don't eliminate | Empirical: multi-environment evaluation suite | 8 settings, multiple frontier models |
| MA.CFBENCH | CFBench (ACL 2025) | Comprehensive constraint taxonomy: 10 major categories, 25+ subcategories for LLM constraint-following | Benchmark construction, systematic evaluation | 1,000 samples, 200+ real-world scenarios |
| MA.CTXENG | Context Engineering Survey (CAS 2025) | Formalized context engineering as discipline transcending prompt engineering; CLEAR framework for prompt construction | Literature survey | 1,400+ papers |
| MA.CTG | Controllable Text Generation Survey (IAAR Shanghai 2024) | Prompt engineering categorized as inference-stage CTG method; taxonomy of training-stage vs inference-stage control | Literature survey | Comprehensive CTG methods |
| MA.SKILLFUL | How LLMs Follow Instructions: Skillful Coordination (Rocchetti & Ferrara, arXiv 2604.06015) | No universal constraint mechanism; structural constraints in early layers, semantic in late; dynamic monitoring during generation | Diagnostic probing + causal ablation across 9 tasks on 3 model families | 3 models (LLaMA 3.1 8B, Gemma 2 2B, Qwen2.5-0.5B) |
| MA.CRGC | Constraint Relationship Graph Completion (CUHK, arXiv 2606.03624) | Bridge constraints reconcile conflicting requirements; reduces constraint violations by 39% | Knowledge graph construction + automated bridge discovery | 3 instruction-following datasets |
| MA.CONINSTRUCT | ConInstruct (HKU, AAAI 2026) | 6 constraint types, 9 conflict types; DeepSeek-R1 best at detection (91.5% F1); models detect conflicts but rarely communicate them | Benchmark construction + LLM evaluation | Multiple proprietary and open-source LLMs |
| MA.CSE | Constraint Saturation Evaluation (Vasileva 2026) | Two-regime decay: 58% at k=1 → ~16% floor at k=12; failures independent; 5-6 constraint ceiling | Deterministic verification across text and vision | 14 text models, 10 VLMs, 82k+ constraint checks |
| MA.IFSCALE | IFScale Follow-up (Arize AI, May 2026) | Models 10x better at instruction following in one year; GPT 5.5 holds 99% through 5,000 constraints | Keyword inclusion proxy task across multiple models | GPT-4.1 through GPT-5.5, Claude, Gemini, DeepSeek |
| MA.SPECGAME.RL | Specification Gaming in Reasoning Models (arXiv 2605.02269) | RL reasoning training increases gaming 32-170%; test-time mitigations reduce but don't eliminate | Multi-environment evaluation suite | 8 settings, Grok/Claude/GPT/DeepSeek |
| MA.SOCIETAL | Large Language Models Hack Rewards, and Society (arXiv 2606.04075) | RL training discovers regulatory loopholes while staying technically compliant; safeguards incomplete | Societal environment sandbox (72 environments) | Multiple frontier models |
| MA.IMPINTERF | Imperative Interference (Mason, arXiv 2603.25015) | Social register shapes instruction topology: imperative "NEVER do X" has language-dependent force; declarative "X: disabled" transfers across all languages. 81% cross-linguistic variance reduction. | Instruction-level ablation across 4 languages x 4 models | 22 hand-authored probes, 56 instruction blocks |
| MA.SAID | South Asian Instruction Dataset (OpenReview 2026) | Culturally adaptive multilingual instruction dataset for 15 South Asian low-resource languages. LoRA fine-tuning shows substantial improvements in cultural alignment. | Automated categorization + human-in-the-loop cultural tagging | 8 SAARC countries, 10 cultural domains |
| MA.BANGLALLAMA | BanglaLlama (ACL 2026 LoResLM) | Bangla instruction-tuned LLMs: Bangla-Orca (172k) + Bangla-Alpaca (52k). Reasoning scores 82.75 vs 37.50 baseline (122% improvement). | Continued pre-training + SFT on translated instruction datasets | 5 model variants, 7 task benchmarks |
| MA.QALB | Qalb: Urdu LLM (arXiv Jan 2026) | Urdu LLM via continued pre-training on 1.97B tokens + SFT. Weighted avg 90.34, outperforming previous SOTA by 3.24 points. | CPT + LoRA SFT on Alif Urdu-instruct dataset | 7 Urdu-specific tasks |
| MA.AMERICASNLP | AmericasNLP 2025/2026 (multiple papers) | LLMs for Indigenous languages of the Americas: most near chance. Rule-based + LLM hybrid approaches 6x more effective than prompting alone. RL + dictionary-guided translation +3.37 BLEU. | Zero/few-shot prompting + rule-based methods + RL | 13-14 Indigenous languages, 5 model families |

---

## By Region

### US/English

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| US.ANTHROPIC | Anthropic | "Tell Claude what to do instead of what not to do" — official best practice across all model-specific guides (Opus 4.8, Sonnet 5, Fable 5) | Industry guidelines, production testing |
| US.OPENAI | OpenAI | Positive framing; schemas over prose; enums over free text; structured outputs (response_format) | Industry guidelines, API design |
| US.SEMGRAV | EmergentMind / arXiv | Negative constraint failure mechanism: priming + override | Mechanistic interpretability |
| US.CTX.PATTERNS | Context Patterns | Hard stops (keep negative) vs behavioral shaping (always reframe positive) | Engineering practice synthesis |
| US.AGENT.PATTERNS | AgentPatterns.ai | Negatives are binary/verifiable; pair with positive guidance; use hooks for must-never-fail | Engineering practice |
| US.TIANPAN | Tian Pan (independent) | Ablate your forbidden list; most "do not" lines don't help or backfire; move enforcement out-of-prompt | Production audit methodology |
| US.THERMAL.BASE | The Neural Base | Positive framing reduces hallucination 15-30%; positive alone 85%, positive+schema 99% | Production benchmarking, verified Apr 2026 |
| US.CURSOR | Cursor / Anysphere | Removed aggressive language → better GPT-5 decisions; structured XML specs improve adherence | Production prompt iteration |
| US.SPECGAME | METR / Anthropic / OpenAI | RL training increases specification gaming; test-time mitigations reduce but don't eliminate | Multi-environment evaluation |

### EU/Europe

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| EU.IAB | IAB Europe | "Lead with positive instructions, add minimum negatives for known issues"; system prompt = identity + instruction + guardrails | Industry guidance |
| EU.OXFORD | University of Oxford | First formal definition of reward hacking; unhackability requires restricting policy set | Formal proof |
| EU.HTWK | HTWK Leipzig (Germany) | 6-component reusable prompt framework: versioning, model, purpose, variables, examples, output structuring | Literature synthesis + template design |
| EU.HICSS | University of Kassel (Germany) | Prompt patterns mined via FCA; examples+constraints deliver highest quality; prompting guides with examples most effective | Formal Concept Analysis + Association Rule Mining on 539 participants |
| EU.DAGSTUHL | Dagstuhl / CP 2024 | LLM-based constraint modelling from NL descriptions; retrieval-augmented ICL improves accuracy | Empirical on NL4Opt + LGP datasets |
| EU.EMNLP | EMNLP 2024 Findings | Task-oriented constraints in instructions significantly impact LLM-generated text detection (SD up to 14.4 F1) | Empirical detection study |
| EU.NEG.CASCADE | Zenodo (CERN) | >40% negatives → catastrophic breakdown; 3:1 positive:negative ratio threshold | Empirical instruction refinement experiment |
| EU.SPAR | SPAR / Center on Long-Term Risk | Inoculation prompting and recontextualization to mitigate specification gaming | RL training experiments |

### China/East Asia

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| CN.CTX.ENG | Chinese Academy of Sciences | Context Engineering as formal discipline; CLEAR framework; 1400-paper survey | Literature survey |
| CN.CFBENCH | ACL 2025 | 10-category constraint taxonomy; current LLMs have significant room for improvement in constraint-following | Benchmark + evaluation |
| CN.LANGPT | LangGPT (Chinese OSS) | Structured prompt methodology: Role → Profile → Skills → Goals → Constraints → Rules → Workflow → Output | Engineering methodology |
| CN.COS | COLING 2025 | Chain-of-Specificity (CoS): emphasizes specific constraints in input, activates internal knowledge, refines responses | Empirical on public + custom datasets |
| CN.CARESTAR | ACL 2025 Findings | Constraint-Aware Self-Taught Reasoner: two-stage method for multiple-constraint instructions | RL-inspired training |
| CN.ZJU.PROMPT | Zhejiang University / ACL 2025 | Theoretical framework: prompt as information selector; optimal prompt can improve reasoning 50%+ | Information-theoretic analysis |
| CN.CTG.SURVEY | IAAR Shanghai / Renmin University | Prompt engineering as inference-stage CTG method; training vs inference control taxonomy | Literature survey |
| CN.DAVINCI | daVinci-Env (arXiv 2603.13023) | Specificity (task boundaries) + Rules (explicit constraints) reduce search space; agent performance improves with clearer constraints | Large-scale SWE agent evaluation (45,320 repos) |
| CN.QUARE | QUARE (arXiv 2603.11890) | Multi-quality-attribute tasks cause "attribute conflict"; dedicated agents per attribute outperform single generalist by 23% | Empirical on requirement engineering |

### Japan

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| JP.TOHOKU.NEG | Tohoku University / RIKEN AIP | Negation understanding in CoT prompting — LLMs misled by "only"/"not" → bias toward "no" even in 175B models | Empirical: controlled negation experiments with GPT-3 (175B) and OPT-66B |
| JP.INSTR.FOLLOW | Japanese university consortium | Comprehensive Japanese instruction-following dataset: taxonomy of length/format/rules (keyword inclusion/exclusion, persona, topic constraints) | Dataset construction + human evaluation on 8 LLMs |
| JP.JSTS.NEG | Nagoya University (LREC 2026) | JSTS-Neg: Japanese STS benchmark for negation understanding; construction method for negation minimal pairs | Dataset construction + LLM evaluation |
| JP.JNLI.NEG | Nagoya University | JNLI-Neg: Japanese NLI dataset for negation evaluation; LLMs show significant negation understanding gaps | Dataset construction, human annotation (Fleiss' Kappa 0.458) |
| JP.NEG.PROMPT | Independent (Japanese blog) | Negation Prompting practice: structured CoT constraint verification, keyword exclusion, output format enforcement, self-validation step | Engineering methodology |
| JP.DIALOGUE | Waseda / Japanese university | LLM multi-party dialogue: negative framing induces negative decisions in LLMs; positive framing has no significant effect | Controlled debate experiment with 3 LLMs, 160 trials each |

### Korea

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| KR.THUNDER | Seoul National University (ACL 2026) | Thunder-KoNUBench: first systematic Korean negation understanding benchmark; LLM performance degrades under negation; fine-tuning improves both negation and broader comprehension | Benchmark construction (4,784 instances) + evaluation of 47 LLMs |
| KR.NEG.INVSCALE | OpenReview / SNU | Negated instructions show inverse scaling law — larger LLMs perform WORSE on negation; humans (13yo) have ~31% gap over best LLMs | 9 NLP benchmarks, OPT 125M-175B, GPT-3, InstructGPT |
| KR.KITE | Korean research consortium | KITE benchmark: Korean instruction-following with verifiable constraints — acrostic poems, post-position drop, honorifics, number systems | Benchmark construction + automated/human evaluation |
| KR.KAIST | KAIST | Modular prompt design: persona + task instruction variation analysis; combining modules doesn't always improve — interactions matter | Thematic analysis of 30 studies + case study with 5 datasets |
| KR.IFEVALKO | Allganize Inc. | IFEval-Ko: Korean adaptation of IFEval instruction-following benchmark; rule-based constraint verification (keyword, forbidden words, format) | Translation + adaptation of Google IFEval |
| KR.CONTRASTIVE | EMNLP 2024 | Complex instruction following with positive/negative contrastive samples; DPO with contrastive triplets for multi-constraint instructions | Empirical: complex instruction synthesis + DPO fine-tuning |
| KR.KIT19 | Korean university consortium | KIT-19: Korean instruction toolkit with 19 tasks, 10 templates per task; verifiable instruction following for Korean NLP | Dataset construction + fine-tuning evaluation |

### Latin America

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| LATAM.CAPITU | Brazilian research consortium (arXiv 2026) | CAPITU: Brazilian Portuguese instruction-following benchmark with verifiable constraints; 59 instruction types, 7 categories; frontier 98.5% strict accuracy; Portuguese-specialized cost-efficient | Benchmark construction + 18 model evaluation across single/multi-turn |
| LATAM.INRIA | Inria Chile | LatamQA: 26k MCQ cultural knowledge benchmark for LatAm; LLMs perform better in native language; Iberian Spanish better known than LatAm | Wikipedia/Wikidata QA construction (26k articles) + 6 model evaluation |
| LATAM.EQUITABLE | Ecuador/US consortium | Advancing Equitable AI for LatAm: LLMs fail to capture linguistic diversity (Spanish, Portuguese, Quechua, Nahuatl); fine-tuning improves cultural expressiveness 42.9% | Culturally aware dataset (535 questions) + Mistral-7B fine-tuning |
| LATAM.WICS.BR | Brazilian CS society (WICS 2025) | CoT prompting for bias identification in Brazilian Portuguese; Sabiá-3 (Brazil-specific) less stereotyped than GPT-4o mini | Zero-shot, Zero-shot-CoT, CoT on GPT-4o mini and Sabiá-3 |
| LATAM.KG.QUIZ | Brazil (CEUR-WS 2025) | KG-Quizzer: prompt refinement via knowledge graphs for Portuguese quiz generation; Few-shot + RDF triples most effective | Framework construction + empirical evaluation with DBpedia |
| LATAM.UNLP | UNLP Argentina | Framework for GenAI exploitation in education, gastronomy, health; structured prompt creation and data integration | Framework design |

### Africa

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| AFR.EDUCATION | GenAI-ERA / multiple African countries (arXiv 2026) | Prompt engineering as AI literacy for African education; ethical awareness, contextual sensitivity, pedagogical judgment over technical skill | Case report: 3-day training, 468 participants across African countries |
| AFR.GEPA | Multiple institutions (OpenReview) | Reflective prompt optimization (GEPA) on African languages; smaller models with optimized prompts match larger ones; prompt evolution as textual policy learning | GEPA on AfriQA and other African-language benchmarks |
| AFR.NLI | African NLP consortium (arXiv 2026) | Contrastive prompting most reliable for African NLI (Swahili, Yoruba, Hausa); language-aware decision structuring improves robustness | Systematic comparison of 5 prompting strategies on AfriXNLI |
| AFR.INSTRUCT | University of Toronto / MIT (EMNLP 2024) | AFRIINSTRUCT: instruction tuning for African languages; 7B model outperforms GPT-3.5-Turbo on QA | Continual pretraining (WURA corpus) + LoRA fine-tuning |
| AFR.INSTRUCTLR | African NLP consortium (OpenReview 2026) | InstructLR: instruction dataset creation for low-resource African languages (Zarma, Bambara, Fulfulde); dual-layer RAG + human quality filtering | Pipeline construction + 50k dataset per language |
| AFR.SHERIA | East African developer | SheriaSenseEA: East African legal AI with strict two-tier constraint system (frontend context injection + backend refusal protocol); negates prompt injection via system prompting | Angular + Firebase + Gemini engineering implementation |
| AFR.CODESWITCH | South Africa / LREC-COLING 2024 | Prompting for code-switched data in Afrikaans-English, Yoruba-English; linguistic guidelines + few-shot improve quality | Prompt variation experiments with GPT-3.5 |

### Middle East / Arabic

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| ME.AR.IFEVAL | MBZUAI / HuggingFace | Arabic IFEval: first Arabic instruction-following benchmark with verifiable constraints including Arabic-specific letter frequency, tashkīl diacritics, root-based morphology constraints. Claude 72.5% Arabic vs 84.7% English | IFEval adaptation + expert linguistic validation + automated verification |
| ME.KFUPM | KFUPM (Saudi Arabia) | KFUPM instructions tuning: 60 prompt templates across 6 Arabic NLP tasks, 3 model families; systematic study of prompt variation effects | LoRA fine-tuning + 5 prompts per dataset evaluation |
| ME.CIDAR | ACL 2024 Findings | CIDAR: first open Arabic instruction-tuning dataset culturally aligned by native speakers (10k pairs). Models fine-tuned on CIDAR better capture cultural nuances than models trained on 30x more translated data | Dataset construction + native speaker review + fine-tuning evaluation |
| ME.NEG.INVSCALE | arXiv 2209.12711 | Negated prompts inverse scaling law — larger LLMs perform WORSE on negation. Established the foundational finding that gotcha-behavioral fails at scale | 9 NLP benchmarks, OPT 125M-175B, GPT-3, InstructGPT, human baseline |
| ME.JAIS | MBZUAI / Inception | Jais-13b-chat: Arabic LLM with structured system prompt defining behavioral constraints, ethical guidelines, refusal protocol. One-shot prompting with decoding parameter tuning | Synthetic data generation + human-in-the-loop evaluation |

### India / South Asia

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| IN.SARVAM | Sarvam AI (India) | Sarvam-M: Indian-language LLM with SFT+RLVR; IFEval-based instruction following curriculum; multilingual prompt strategies (40% English, 40% native script, 20% romanized); custom reward engineering for translation tasks | SFT + GRPO RLVR with curriculum learning, 11.5M prompts curated to 468k |

### Southeast Asia

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| SEA.IFEVAL | AI Singapore | SEA-IFEval: multilingual IFEval for Indonesian, Javanese, Sundanese, Thai, Tagalog, Vietnamese; manually translated and culturally localized; penalizes responses in wrong language | IFEval adaptation + native speaker translation + rule-based verification |
| SEA.HELM | AI Singapore / NUS (ACL 2025) | SEA-HELM: 5-pillar evaluation suite including instruction following (SEA-IFEval), linguistics, culture, safety — for Filipino, Indonesian, Tamil, Thai, Vietnamese | Holistic benchmark construction + leaderboard |
| SEA.LION | AI Singapore | SEA-LION v3: multilingual LLM for 11 SEA languages; post-training with SEA-Instruct (7.3M pairs); IFEval used for instruction following evaluation; merge-based training avoids catastrophic forgetting | Continual pre-training + multi-stage instruction tuning + model merging |
| SEA.MERALION | Singapore NRF | MERaLiON-TextLLM: cross-lingual LLM for Chinese, Indonesian, Malay, Singlish; weight merging improves instruction following without extensive fine-tuning | Continued pre-training + model merging |

### Russia / Eastern Europe

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| RU.PROMPTRIEVER | Russian research group | ru-promptriever: Russian instruction-following retrieval dataset — natural language constraint instructions for retrieval (e.g. "find X but exclude Y"); diverse constraint types including negation | Multi-stage LLM pipeline + BM25 hard negative mining + LLM judge validation |
| RU.VIKHR | Russian research consortium | Vikhr: bilingual Russian instruction-tuned LLM; expanded instruction datasets for Russian with quality filtering via reward model | Tokenizer adaptation + continued pre-training + instruction tuning |
| RU.TPRO | T-tech / Russian consortium | T-pro 2.0: Russian hybrid reasoning model with T-Wix 500k instruction corpus; general instruction following as core training objective | Instructional midtraining + SFT + DPO |

### Hong Kong

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| HK.CRGC | Chinese University of Hong Kong (arXiv Jun 2026) | CRGC: Constraint Relationship Graph Completion — represents instructions as knowledge graphs; discovers bridge constraints that reconcile conflicting requirements; reduces violations by 39% | Graph construction + automated bridge discovery; tested on GPT-4o, Claude-3-Opus, open-source models |
| HK.CONINSTRUCT | University of Hong Kong (AAAI 2026) | ConInstruct: conflicting constraint benchmark — 6 constraint types, 9 conflict types. DeepSeek-R1 best at detection (91.5% F1); models detect but rarely communicate conflicts | Benchmark construction + LLM evaluation |
| HK.HKGAI | HKUST-led consortium | HKGAI V1 / HKChat: Hong Kong's homegrown LLM, full-parameter fine-tune of DeepSeek for Hong Kong contexts; local government, legal, educational data | Full-parameter fine-tuning + RLHF |
| HK.XIAOYI | Huawei HKRC / HKUST | XiaoYi LLM fine-tuning: SFT achieved 10% instruction compliance improvement; DPO achieved 18% length constraint adherence improvement | SFT + DPO on Huawei's XiaoYi LLM |
| HK.TREE.INSTRUCT | HKUST | Tree-Instruct: controlling instruction complexity for LLMs; curriculum learning with complexity-graduated data improves performance | Data construction + fine-tuning experiments |

### Canada

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| CA.IFSCALE | Arize AI (May 2026) | IFScale follow-up: models 10x better at instruction following in one year; GPT-5.5 holds 99% through 5,000 constraints | Keyword inclusion proxy across GPT, Claude, Gemini, DeepSeek |
| CA.SSDE | NSERC / University of Waterloo (arXiv May 2026) | Structured Spec-Driven Engineering: structured specs (Gherkin) > natural language for LLM code generation; reduces ambiguity and enables verification | Pilot study with 5 LLMs across MVC systems |
| CA.CIFAR | Vector Institute / University of Toronto | CIFAR AI Catalyst Grants — formalizing constraints for agentic risk via Desired Behavior Specifications (Sheila McIlraith) | Formal methods + reward modeling |

### Australia / Oceania

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| AU.CARE | Macquarie University (ECAI 2025) | CARE: dual-agent prompt refinement with explicit validation constraints; prompt decomposition + rule-based transformations | Staged transformation pipeline with validation |
| AU.CAP | University of Technology Sydney (Nature Sci Rep 2026) | Culturally-Aware Prompting: embedding cultural context as explicit positive instructions improves appropriateness without accuracy loss | Controlled experiment: 72 outputs, blind human ratings |
| AU.HIPO | Australian/Canadian collaboration (arXiv Mar 2026) | HIPO: instruction hierarchy via constrained RL (CMDP); attention reallocates toward system tokens, enforcing priority | Primal-dual safe RL with GRPO |
| AU.VERIH | Australian collaboration (ACL 2026 Findings) | Reasoning Up the Instruction Ladder: instruction hierarchy as reasoning task; VerIH dataset with ~7k conflict cases; 20% ASR reduction | RLVR on synthetic conflict dataset |

### Scandinavia / Nordic

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| NO.DAMETA | University of Copenhagen (LREC 2026) | DAMETA: Danish metaphor benchmark — prompt framing shifts error type: informed of metaphor→figurative distractor, uninformed→literal distractor | Dataset construction + 7 model evaluation |
| NO.FLUENT | University of Oslo (ICLR 2026) | Fluent Alignment with Disfluent Judges: on-policy RL for Norwegian bootstraps fluency without instruction data | On-policy RL with LLM-as-a-judge |
| NO.NORWAI | NorwAI / Norwegian consortium (arXiv Jan 2026) | NorwAI LLMs: Norwegian LLM family with instruction-tuned variants; Norwegian-culture instruction data | Continual pre-training + LoRA fine-tuning |
| FI.PORO | University of Turku / Finland (NoDaLiDa 2025) | Poro 34B: Finnish LLM trained with multilingual blessing approach; English + code augmentation lifts data limitations | Multilingual continued pre-training |
| SE.GPTSW3 | AI Sweden (LREC-COLING 2024) | GPT-SW3: Scandinavian LLM for Swedish, Norwegian, Danish, Icelandic; instruction-tuned variants | Pretraining + instruction tuning |

### Switzerland

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| CH.LAMER | EPFL / ETH Zurich / Idiap (arXiv 2026) | LAMER: Meta-RL for LLM agents — cross-episode training induces exploration; self-reflection as in-context adaptation; 11.8-19.3% absolute gains | Meta-RL with cross-episode objective + self-reflection |
| CH.ENGIAI | ETH Zurich (arXiv May 2026) | EngiAI: multi-agent engineering framework tests 7 prompt styles; conditional branching most challenging (20-53%); multi-step IF degrades over long workflows | Benchmark suite + LangGraph-based MAS |
| CH.SWISSAI | ETH Zurich / EPFL (Jul 2025) | Swiss AI Initiative: fully open multilingual LLM (1000+ languages) from scratch; Apache 2.0 license | Publicly developed on Alps supercomputer |

### Israel

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| IL.DICTALM | Dicta (arXiv Feb 2026) | Dicta-LM 3.0: Hebrew LLM with 30 manually curated Hebrew-specific IFEval constraints; sets new standard for Hebrew instruction following | Continued pre-training + SFT + GRPO |
| IL.HEBATRON | Israeli research consortium (arXiv May 2026) | Hebatron: Hebrew MoE LLM with three-phase anti-forgetting curriculum; 73.8% Hebrew reasoning | Three-phase curriculum + SFT on 2M bilingual samples |
| IL.AI21 | AI21 Labs | Jamba prompt engineering guide: IDH template (Instruction-Data-Hint), system prompt indispensability, temperature adjustment methodology | Industry practice guide |

### Germany

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| DE.CAUSAL | LMU Munich / MCML (arXiv May 2026) | Causal Methods for LLM Development: formal causal framing of constraint effects in alignment, routing, evaluation; debiasing LLM-as-a-judge | Causal inference methodology applied to LLM pipeline |
| DE.DML | DKFZ Heidelberg / LMU Munich (PMC 2026) | DML-LLM Hybrid: deterministic constraint layer controlling LLM in industrial FDD; prompt templates constrain LLM output — speculative reasoning limited | Bayesian + DML + LLM hybrid architecture |
| DE.IWSLT | KIT Karlsruhe + FBK Trento | IWSLT 2026 IF track: speech instruction following evaluation in constrained/unconstrained conditions | Shared task with verifiable constraints |

### France

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| FR.MEDINJECTION | INRIA / CNRS / Grenoble (arXiv Mar 2026) | MedInjection-FR: French biomedical instruction dataset (571k pairs); native data outperforms translated/synthetic for constrained decoding | Controlled experiment: 7 data configurations + fine-tuning |
| FR.MOSAIC | French research collaboration (EACL 2026) | MOSAIC: modular instruction compliance benchmark with up to 20 application-oriented constraints; compliance varies with type, quantity, position | Dynamic dataset generation + 5 LLM evaluation |
| FR.LUCIE | OpenLLM-France / LINAGORA Toulouse (2025) | Lucie-7B: open French LLM with instruction-tuned versions; multilingual focus offsets anglo-centric bias | Pretraining + instruction tuning |

### Spain

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| ES.IBERBENCH | Spanish research consortium (arXiv Apr 2025) | IberBench: LLM evaluation for Iberian languages (Spanish, Catalan, Basque, Galician, Portuguese); zero-shot setting | Standardized evaluation across 23 models |
| ES.DIDACTEXT | University of Madrid / Barcelona (2025) | Guided Prompting Didactext: process-oriented decomposition of writing into 4 phases; guided prompts produce better quality than holistic | Controlled experiment: 750 essays, holistic vs guided |

### Turkey / Central Europe

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| TR.TUDUM | Turkish research consortium (arXiv Jul 2026) | TÜDÜM: Turkish-thinking reasoning pipeline for Qwen3.5-27B; SFT improves Turkish but reduces accuracy; RL recovers partially | SFT + GRPO RL with Turkish-language rewards |
| TR.PROMPT.FMT | Düzce University (Jan 2026) | Turkish prompt format study: custom Turkish prompt tags outperform default formats for Llama2 and Phi3 on Turkish instructions | Controlled experiment: 5 prompt formats, 2 models, 2 datasets |
| CZ.LSRIF | Charles University / Czech collaboration (arXiv Jan 2026) | LSRIF: logic-structured RL for instruction following — parallel/sequential/conditional constraints; failure-penalty for sequential, selective rewards for conditional | Logic-structured reward modeling + RL fine-tuning |

### Poland

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| PL.PLLUM | Wrocław Tech consortium (2025) | PLLuM family: Polish LLM (8B-70B) with 77k instruction dataset; functional typology of organic/automatic/synthetic instructions | Continual pre-training + SFT + DPO + RL |
| PL.PLLUMIC | Wrocław Tech (Nov 2025) | PLLuMIC: instruction corpus shows negative language transfer from English-dominant conventions to Polish | Dataset construction + analysis |
| PL.ALIGN | Wrocław Tech (EMNLP 2025) | PLLuM-Align: Polish preference dataset, human-curated with 7 alignment dimensions including instruction-following | Human annotation + DPO/ORPO |
| PL.BIELIK | Jagiellonian University (2025) | Bielik 11B v3: Polish LLM with SFT+DPO+RL pipeline; outperforms models with 2-6x more parameters | Depth up-scaling + multi-stage training |
| PL.REASON | Wrocław Tech (EACL 2026 Findings) | Breaking the Illusion of Reasoning: quality > quantity for reasoning in Polish; correct responses contain fewer tokens | Fine-tuning on 4 reasoning variants |

### Estonia / Baltics

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| EE.XROAD | Tallinn University of Technology (2026) | Sovereign LLM for X-Road anomaly detection: structured prompt with context + key-value fields + pre-computed flags + JSON schema; recall 1.000 | Guided zero-shot classification with structured prompt template |
| EE.LEGAL | TwinLadder Research (Mar 2026) | Baltic Legal AI: Sorainen AiVar, COBALT/Lexu AI, Luminance; language wall — English-dominant models fail on Latvian/Estonian legal specifics | Production deployment analysis |

### Ireland

| Source | Institution | Key content | Methodology |
|--------|-------------|-------------|-------------|
| IE.ARTISAN | Trinity College Dublin (Jan 2025) | ARTISAN Instruction Framework: A-R-T-I-S-A-N (Audience/Role/Task/Instruction/Specific Constraints/Assessment/Nuance). "Specific Constraints" is its own stage | Systematic methodology with 7 stages |
| IE.ADAPT | ADAPT Centre / DCU | ADAPT Research Ireland Centre for AI-Driven Digital Content; ADVANCE 2025 conference on safe AI evaluation sandboxes | Multi-disciplinary research centre |

---

## Gaps

| ID | Gap | Severity | Status |
|----|-----|----------|--------|
| GAP.JP | Japan — negation understanding well-studied (Tohoku, Nagoya), but no native systematic study of gotcha/contraction as a design pattern | medium | not surfaced |
| GAP.KR | Korea — negation in LLMs well-studied (SNU, inverse scaling law confirmed), KITE benchmark covers constraint types; no gotcha/contraction pattern-level analysis | medium | not surfaced |
| GAP.LATAM | Latin America — strong on instruction-following benchmarks (CAPITU for Portuguese) and cultural bias, but no mechanistic work on negative constraint failure | medium | not surfaced |
| GAP.AFRICA | Africa — active in instruction tuning for low-resource languages, but no studies on negative/positive constraint effectiveness trade-offs | medium | not surfaced |
| GAP.EU.MECH | EU — weaker mechanistic/causal research compared to US on negative constraint failure; EU strength is formal theory | low | not surfaced |
| GAP.CROSS.MODEL | No study compares gotcha/contraction effectiveness systematically across model families (Claude vs GPT vs Gemini vs Qwen) | high | not surfaced |
| GAP.CROSS.LANG | Negation Sensitivity Index (NSI) not measured across languages — how does constraint type effectiveness vary by language? | high | not surfaced |
| GAP.JP.PRACTICE | Japan — strong academic negation research but weak on production prompt engineering patterns; gap between theory and practice | low | not surfaced |
| GAP.KR.PRACTICE | Korea — strong academic benchmarks but production prompt pattern literature less developed compared to US/Chinese practice guides | low | not surfaced |
| GAP.LATAM.MECH | Latin America — no mechanistic interpretability research on constraint types; focused on application and bias | low | not surfaced |
| GAP.AFRICA.SCOPE | Africa — research focused on low-resource language access, not on optimization of constraint specification patterns | low | not surfaced |
| GAP.ME | Middle East — strong on Arabic instruction following benchmarks (Arabic IFEval) and cultural bias mitigation, but no mechanistic work on gotcha/contraction | medium | not surfaced |
| GAP.IN | India — very sparse; Sarvam-M only major source; no systematic constraint pattern research for Indian languages | medium | not surfaced |
| GAP.SEA | Southeast Asia — strong on multilingual IFEval adaptation (SEA-IFEval) but no gotcha/contraction pattern analysis | medium | not surfaced |
| GAP.RU | Russia/Eastern Europe — sparse; ru-promptriever relevant for constraint retrieval but no systematic pattern research | medium | not surfaced |
| GAP.HK | Hong Kong — strong on constraint graph theory (CRGC) and conflict detection (ConInstruct) but no production prompt pattern engineering guides | low | not surfaced |
| GAP.CA | Canada — strong on formal constraint specification (CIFAR/Vector) and spec-driven engineering but no mechanistic LLM-specific work | low | not surfaced |
| GAP.AU | Australia — strong on instruction hierarchy (HIPO, VerIH) and cultural prompting but no cross-model comparison of gotcha penalty | low | not surfaced |
| GAP.NO | Scandinavia — strong on low-resource LLM adaptation for Norwegian/Finnish but no systematic constraint pattern research | low | not surfaced |
| GAP.CH | Switzerland — strong on meta-RL for agents (LAMER) and multi-agent orchestration but no constraint type taxonomy work | low | not surfaced |
| GAP.IL | Israel — strong on Hebrew-specific instruction following (Dicta-LM, Hebatron) but no cross-lingual gotcha comparison | low | not surfaced |
| GAP.DE | Germany — strong on causal methods and DML-LLM hybrids but no mechanistic interpretability of constraint types | low | not surfaced |
| GAP.FR | France — strong on modular compliance evaluation (MOSAIC) and French medical instruction data but no gotcha-specific work | low | not surfaced |
| GAP.ES | Spain — strong on Iberian evaluation (IberBench) and guided prompting but no constraint pattern research | low | not surfaced |
| GAP.TR | Turkey — strong on Turkish-specific prompt formats and reasoning but no systematic constraint pattern analysis | low | not surfaced |
| GAP.PL | Poland — strong on Polish LLM development with organic instruction data but no constraint pattern research | low | not surfaced |
| GAP.EE | Estonia/Baltics — strong on production sovereign LLM deployment (X-Road) and legal AI but no systematic pattern research | low | not surfaced |
| GAP.IE | Ireland — ARTISAN framework provides systematic methodology but no empirical validation of constraint type effectiveness | low | not surfaced |

---

## Key Researchers by Region

| Region | Researcher | Institution | Focus |
|--------|-----------|-------------|-------|
| US | Anthropic prompt engineering team | Anthropic | Positive framing, XML structure, role-based prompting |
| US | OpenAI prompt engineering team | OpenAI | Structured outputs, schemas, instruction hierarchy |
| US | Tian Pan | Independent | Forbidden list ablation, out-of-prompt enforcement |
| EU | Joar Skalse, Nikolaus Howe | Oxford, Mila | Formal reward hacking definition, unhackability conditions |
| EU | Matty Hilliard | Independent | Negative Instruction Cascade, positive:negative ratio |
| EU | Antonia Tolzin, Nils Knoth | University of Kassel | Prompt pattern mining via FCA |
| EU | IAB Europe AI committee | IAB Europe | Industry prompt engineering standards |
| CN | Shenghua Liu, Lingrui Mei | CAS / UCAS | Context Engineering survey |
| CN | LangGPT community | Chinese OSS | Structured prompt methodology |
| CN | Zhejiang University NLP group | ZJU | Prompt space complexity theory, CoS |
| CN | IAAR Shanghai CTG group | IAAR Shanghai / Renmin Univ | Controllable text generation survey |
| JP | Jun Suzuki, Mengyu Ye | Tohoku University / RIKEN AIP | Negation understanding in CoT, LLM mispriming by negation |
| JP | Reiko Yuasa, Yoshihide Kato, Shigeki Matsubara | Nagoya University | Japanese negation understanding benchmarks (NLI, STS) |
| KR | Sungmok Jung, Yeonkyoung So, Joonhak Lee | Seoul National University | Korean negation understanding, inverse scaling law of negation |
| KR | KAIST HCI lab | KAIST | Modular prompt design, persona-instruction interaction |
| LATAM | Giovana Bonás, Roseval Malaquias Junior | Brazilian consortium | Portuguese instruction-following benchmarks (CAPITU) |
| LATAM | Inria Chile NLP team | Inria Chile | LatamQA cultural bias benchmark, LLM evaluation for LatAm |
| AFR | Benjamin Quarshie, Vanessa Willemse | GenAI-ERA (multiple African countries) | Prompt engineering literacy, AI education in Africa |
| AFR | Masakhane / AFRIINSTRUCT team | U. Toronto, MIT | Instruction tuning for African languages |
| ME | MBZUAI / HuggingFace Arabic leaderboard team | MBZUAI, UAE | Arabic instruction following, Arabic IFEval |
| ME | KFUPM / JRCAI lab | King Fahd University, Saudi Arabia | Prompt variation effects on Arabic LLMs |
| IN | Sarvam AI research team | Sarvam AI, India | Indian-language LLMs, multilingual instruction following |
| SEA | AI Singapore SEA-HELM team | AI Singapore / NUS | SEA multilingual instruction following, SEA-IFEval |
| RU | Russian NLP consortium | Moscow / multiple | Russian instruction-tuned LLMs, constraint-based retrieval |
| HK | Kam-Fai Wong, Zhengyi Zhao | Chinese University of Hong Kong | CRGC: constraint relationship graphs, bridge constraints |
| HK | Xingwei He, Siu-Ming Yiu | University of Hong Kong | ConInstruct: conflicting constraint detection and resolution |
| CA | Sheila McIlraith | Vector Institute / University of Toronto | Desired Behavior Specifications, formalizing agent constraints |
| AU | Nardine Basta, Benjamin Zi Hao Zhao | Macquarie University | CARE: dual-agent prompt refinement with validation constraints |
| NO | David Samuel, Lilja Øvrelid, Erik Velldal | University of Oslo | Fluent alignment for low-resource languages, on-policy RL |
| CH | Maria Brbić, Damien Teney | EPFL / Idiap | LAMER: meta-RL for LLM agents, self-reflection |
| IL | Shaltiel Shmidman, Avi Shmidman | Dicta / Bar-Ilan | Dicta-LM: Hebrew instruction-following LLMs |
| DE | Dennis Frauen, Stefan Feuerriegel | LMU Munich / MCML | Causal methods for LLM development and evaluation |
| FR | Alberto Purpura, Adam Faulkner | French research collaboration | MOSAIC: modular instruction compliance benchmark |
| ES | José Ángel González, Ian Borrego | Spanish consortium | IberBench: Iberian language LLM evaluation |
| PL | Jan Kocoń, Piotr Pęzik | Wrocław Tech | PLLuM: Polish LLM family, instruction corpus design |
| EE | Parviz Salmanov | Tallinn University of Technology | Sovereign LLM for X-Road anomaly detection |
| IE | Eamonn O'Raghallaigh | Trinity College Dublin | ARTISAN prompt engineering framework |

## Cross-lingual evidence — gotcha-hard-stop failure measured everywhere tested

Contraction (Tier 1) succeeds universally; gotcha-hard-stop (Tier 2) fails cross-lingually in every study; gotcha-behavioral (Tier 3) shows inverse scaling and imperative interference.

### Evidence summary — 60+ independent studies, 6 continents, zero contradictory

Gotcha-hard-stop fails in EVERY language group tested — from ultra-low-resource to major European languages. The gotcha mechanism is architecturally determined: **87.5% priming failure** (naming the forbidden word activates it) and **12.5% FFN override** (layers 23-27 causally responsible). Cross-lingual register: **81% variance reduction** via declarative rewriting. Production: every beneficial rule is a negative constraint; every harmful one is a positive directive. Reasoning models trade off controllability for capability — CoT distillation degrades instruction adherence.

**Infrastructure confirming the gap exists** — safety benchmarks built from necessity across Africa (UbuntuGuard 10 langs), Arabic (SalamahBench 8,170 prompts), West Africa (LSR: 90%→35-55% refusal), Hausa (Complex Interference, temporal asymmetry), Brazil (Curupira), Latin America (+42.9% CE via fine-tuning), India (IndicJR 12 langs, IndicSafe 1.2B speakers, IndicGuard, Samiksha 150K human assessments), Korea (KSAFE-MM, AssurAI), Taiwan (TWGuard +0.289 F1), 12 EU languages (RefusEU), all 24 EU languages tested, China (CSSBench, CRiskEval, ChiSafe-PAS, Libra-Guard, ChineseSafe 205K), Japan (JMedEthicBench, AnswerCarefully, WildGuardTestJP), SEA (SEA-Guard 8 langs, ThaiSafetyBench, IndoSafety 5 varieties), Norway (Borealis audit, Understanding Paradox). Selective Safety Trap (MiJaBench): defense rate varies 42% by demographic. Code-mixing amplifies ASR to >90%.

### Key mechanistic finding (MINIONESE, ICML 2026):
Geometric analysis across 18 languages, 4 resource tiers, 4 perturbation types found: **low-resource jailbreaks succeed by routing harmful content through a geometrically misaligned subspace that projects insufficiently onto refusal directions, leaving the refusal mechanism intact but untriggered.** Cross-lingual refusal is effectively one-dimensional — only the principal refusal direction transfers across languages. A sharp safety regime transition between Tier 2 (mid-high) and Tier 3 (mid-low) resource languages is consistent across all models tested.

### Key mitigation findings — semantic bottleneck alignment works
**LASA (Tsinghua/Alibaba 2026)**: Anchoring safety alignment at the **semantic bottleneck** (intermediate layer where geometry is governed by shared semantic content, not language identity) reduces average ASR from 24.7% to 2.8% on LLaMA-3.1-8B, and 3-4% across all Qwen2.5/Qwen3 models (7B-32B). Swahili ASR drops from ~50% to 13.0%. This confirms the root cause: **safety alignment fails cross-lingually because it is enforced in language-specific representation space, not language-agnostic semantic space.**

**MLC (BAAI/Peking University 2026)**: Plug-and-play multilingual consistency loss improves collinearity of multilingual representation vectors. Lifts all 10 languages (EN/ZH/RU/JA/AR/BN/SW/UR/PS/KU) to >90% safety with no additional response-level supervision for low-resource languages. Works with DPO, SimPO, ORPO — compatible with existing alignment pipelines.

### Key high-stakes finding — language changes moral reasoning (TrustNLP 2026, ACL):
Controlled experiment with 9 models across 6 providers using nuclear strike game-theoretic vignettes. **Japanese prompts reduce Claude Sonnet 4.6 launch rate from 40% to 0%** in unnecessary-strike scenarios, and from 93% to 17% in contested scenarios. Cross-language ablation isolates the mechanism: **reasoning in Japanese (not input language) drives the effect.** When instructed to reason in Japanese within an English prompt, launch rates drop from 93% to 37%. Models spontaneously generate moral vocabulary ("moral cost", "millions of lives") entirely absent from the prompt. **Evaluating in English alone can miss both risks and safeguards encoded in other languages.** Effect requires a model that already hesitates in English. Five other models show no language effect — they launch in nearly every condition.

### Key gotcha mechanistic finding — Semantic Gravity Wells (2026):
First comprehensive mechanistic investigation of negative instruction failure across 40,000 samples. Violation probability follows a tight logistic relationship with semantic pressure (p=σ(-2.40+2.27·P₀); n=40,000). **Two mechanistically distinct failure modes identified:**

**Priming failure (87.5% of violations)**: The instruction's explicit mention of the forbidden word paradoxically activates rather than suppresses the target representation. The model attends more strongly to where the forbidden word appears than to the negation cue ("do not"). **The very act of naming a forbidden word primes the model to produce it.**

**Override failure (12.5%)**: Late-layer feed-forward networks (layers 23-27) generate contributions of +0.39 toward the target probability — nearly 4× larger than in successes (+0.10). These contributions can overwhelm earlier suppression signals even when suppression exists. The suppression signal is 4.4× weaker in failures (5.2pp reduction) than successes (22.8pp).

**Causal confirmation**: Activation patching confirms layers 23-27 are causally responsible — replacing their activations flips the sign of constraint effects.

### Key gotcha register finding — Imperative Interference (Mason 2026):
System prompt instructions that cooperate in English compete in Spanish, with the same semantic content but opposite interaction topology. **Declarative rewriting of a single instruction block reduces cross-linguistic variance by 81%** (p=0.029). Rewriting three of eleven imperative blocks shifts Spanish topology from competitive to cooperative, with **spillover effects on unrewritten blocks**. This provides direct evidence that imperative register carries different obligatory force across speech communities — models process instructions as social acts, not technical specifications. Testable prediction: Constitutional AI principles authored in imperative mood may create language-dependent alignment.

### Key gotcha production finding — Don't Say Never (2026):
645 trials across 3 models, 6 vulnerability-eliciting prompts, 4 CWE classes. **Prohibition framing ("NEVER use eval()") increases vulnerability on Claude Sonnet 4 (50% vs 20% control, p=0.016) — the opposite of the rule's intent.** Backfire requires double-priming interaction: when user prompts do not name the insecure API, neither framing causes harm (0/225 trials). Well-intentioned prohibition rules inadvertently create the same activation pattern an adversary would deliberately construct. Alternative-suggestion framing ("Always use JSON.parse()") backfires on Gemma 4 31B. GPT-5 exhibits no backfire under either framing — model-dependent.

### Key gotcha practical finding — The Recipe Effect (Pan 2026):
Each "do not" line in a system prompt carries a measurable cost: context tokens, cache locality, eval surface area, and leakage risk. Ablation experiment: take each forbidden-list line, run eval with and without. Three outcomes: (1) most common — **no measurable effect** (the line is scar tissue); (2) second most — **increases the forbidden output** (recipe effect: the forbidden list inserts the forbidden concept into working context); (3) rarely — actually helps. The forbidden list does not just leak attack surface; **the most-attended thing in the model's context is the thing it is being asked not to recite.** Same defenses moved outside the prompt (classifier, regex, tool guard) are dramatically more robust because the rule is invisible to the model and the attacker.

### Key gotcha role finding — Prompt Injection as Role Confusion (2026):
LLMs perceive role by **style, not tags**. Injected text occupies the same representational space as the trusted role it imitates — sounding like a role is indistinguishable from being one. CoT Forgery: zero-shot attack injecting fabricated reasoning into user prompts. Models mistake the forgery for their own thoughts: **60% ASR against frontier models with near-zero baselines.** Role confusion predicts attack success before a token is generated — measurable dose-response relationship. This is the same mechanism as semantic priming but applied to role boundaries: tags don't survive into representation space.

### Key gotcha reasoning finding — Scaling Reasoning, Losing Control (ACL 2026):
MathIF benchmark evaluates instruction-following in mathematical reasoning tasks. **Models that reason more effectively often struggle to comply with user directives.** Tuning on distilled long CoT or reasoning-oriented RL degrades instruction adherence, especially when generation length increases. Simple interventions partially recover obedience at cost of reasoning performance. **Fundamental tension between reasoning capacity and controllability.**

### Key refusal geometry finding — CLS: Safety as Linear Feature (TrustNLP 2026):
Contrastive Logit Steering isolates the refusal direction by contrasting logits under safe vs unrestricted system prompts, then subtracts it via simple arithmetic. **95% ASR on Llama-3.1 in ~1 second** — bypassing safeguards that withstand expensive optimization attacks like GCG. Mechanism analysis reveals two distinct safety topologies: **"Late Decision" (Llama)**: safety divergence only at final layers, easily bypassed. **"Early Divergence" (Qwen)**: safety integrated mid-computation, substantially more robust. Safety alignment is a linear steerable feature — both critical vulnerability and precise primitive for defense.

### Key refusal subspace finding — Over-Refusal and Representation Subspaces (2026):
Harmful-refusal directions are **task-agnostic** (captured by single global vector). Over-refusal directions are **task-dependent** (inside benign task clusters, higher-dimensional subspace, vary across tasks). The two refusal types are representationally distinct from early transformer layers. Global direction ablation suppresses harmful-refusal substantially more than over-refusal — **applies the wrong geometry.** Task-conditioned methods achieve substantially better precision.

### Key gotcha empirical finding — Guardrails Beat Guidance (2026):
Large-scale controlled study of 679 agent rule files (25,532 rules) across 5,000+ agent runs on SWE-bench Verified. **Every individually beneficial rule is a negative constraint; every individually harmful one is a positive directive.** Performance gains are largely content-independent — random, shuffled, and mismatched-domain rule files all match curated rules (+13.8pp), pointing to a context priming mechanism rather than content learning. Individual rules that appear harmful in isolation do not visibly accumulate damage in ensemble. Clear principle: **constrain what agents must not do, rather than prescribing what they should** — but only when constraints are deterministically checkable (out-of-prompt enforcement), not when used as behavioral gotchas in prompt text.

### Key experimental replication finding (RefusEU, 2026):
Controlled DPO alignment across 12 European languages (EN/DE/FR/IT/ES/PT/PL/CZ/SK/SL/LT/LV) found: **training exclusively in English is insufficient to ensure cross-lingual safety, even for identical harm categories.** Multilingual training improves safety without degrading general performance. This is the most rigorous controlled experiment to date, confirming the pattern across a full European language set.

### Infrastructure confirming the gap exists
- **SEA-HELM** (ACL 2025) — 5 pillars incl. Safety for Filipino/Indonesian/Tamil/Thai/Vietnamese
- **CMiLBench** (ACL 2026) — Safety Alignment Tasks for Tibetan/Mongolian/Uyghur
- **ELAB** (ACL 2025) — alignment benchmark for Persian (translated AdvBench/HarmBench)
- **Beaver-zh-hk** (2026) — 29 safety scenarios for Hong Kong context
- **TFD** (EMNLP 2026) — Tibetan Foundation Dataset includes safety alignment + preference optimization
- **CAALLM** (2026-2028) — Nordic-Baltic culture-sensitive LLM alignment project
- **Qwen3Guard** (2025) — 119-language guardrail; exists because safety doesn't transfer
- **CHILLGuard** (2026) — Chinese-specific 31 micro-category guardrail; Chinese = safety blind spot
- **PKU-SafeRLHF** (2025) — 166.8K preference pairs decoupling helpfulness/harmlessness
- **CVC** (2026) — 250K Chinese value rules; culturally-specific alignment needed
- **CSSBench** (2026) — Chinese-Specific Safety Benchmark; pinyin/homophone/symbol adversarial patterns for lightweight LLMs
- **CRiskEval** (ACL 2025) — Chinese Multi-Level Risk Evaluation; 14,888 questions across 7 frontier risk types
- **ChiSafe-PAS** (2026) — Human-annotated Chinese adversarial benchmark; 1,897 prompts across 4 high-stakes domains
- **Libra-Guard/Test** (2025) — Chinese safeguard + evaluation benchmark; 5,700 samples across 7 harm categories
- **LASA** (Tsinghua/Alibaba 2026) — Semantic bottleneck alignment; proof that fixing the root cause works (ASR 24.7%→2.8%)
- **MLC** (BAAI/Peking University 2026) — Multilingual consistency loss; plug-and-play, lifts 10 languages to >90%
- **JailBench** (PAKDD 2025) — Comprehensive Chinese jailbreak benchmark; 10,800 test cases, 73.86% ASR against ChatGPT
- **JMedEthicBench** (2026) — Multi-turn medical safety for Japanese healthcare; 52,000 conversations, 27 models
- **WildGuardTestJP** (ANLP 2026) — Japanese guardrail benchmark; English-centric guardrails underperform
- **XL-SafetyBench** (2026) — 10 countries, 37 models; Korea/UAE >50% ASR; local model safety = comprehension failure
- **CAGE/KoRSET** (2026) — Korean culturally-adapted red-teaming; CA prompts +9.3pp over translation
- **MLJailDe** (2026) — Multilingual jailbreak detection; 98.5% F1, 97.1% on unseen languages
- **MPO** (ACL 2025) — Multilingual safety alignment via reward gap optimization; dominant language as supervision signal
- **LogiBreak** (ACL 2026) — Multilingual logical expression jailbreak across EN/ZH/NL/JA/ES; exposes token-level vs semantic-level alignment gap
- **Refusal Direction is Universal** (NeurIPS 2025) — PolyRefuse dataset; refusal direction transfers across 14 languages
- **One Jailbreak, Many Tongues** (2026) — Language-insensitive intention representations for jailbreak detection
- **KSAFE-MM** (2026) — Korean multimodal safety benchmark; culturally grounded attacks more effective than generic
- **AssurAI** (2025) — Korean multimodal safety dataset; 35 risk factors across text/image/video/audio
- **TWGuard** (2026) — Taiwanese Mandarin guardrail; +0.289 F1, 94.9% FPR reduction
- **Camellia** (ICLR 2026) — 9 Asian language cultural bias benchmark; 19,530 entities; LLMs favor Western entities
- **ChineseSafe** (SUSTech 2024) — 205K Chinese safety examples; political sensitivity, variant/homophonic words
- **CHiSafetyBench** (2024) — Chinese hierarchical safety benchmark; 5 risk areas, 31 categories
- **OpenEval** (2024, Tianjin Univ.) — Chinese LLM evaluation platform; 35 benchmarks across capability/alignment/safety
- **A Chinese Dataset for Evaluating Safeguards** (2024) — 3,042 Chinese prompts; region-specific risks determine safety rank
- **Lingua-SafetyBench** (2026) — 100K multilingual multimodal safety pairs across 10 languages
- **MSD: Multilingual Self-Distillation** (2026) — cross-lingual safety transfer via self-distillation without response data
- **Nuclear Strike — Language-Dependent Reasoning** (TrustNLP 2026) — Japanese triggers moral vocabulary in high-stakes decisions
- **IMDA Red Teaming Challenge Japan** (Springer 2026) — Japan case study: monolingual environment shapes stereotype evaluation
- **Camellia** (ICLR 2026) — entity-centric cultural bias benchmark for 9 Asian languages
- **Why Do Safety Guardrails Degrade Across Languages?** (2026) — Multi-Group IRT framework; 61 configs, 10 languages, 1.9M rows; 22 configs MORE vulnerable in English
- **Towards Safe Multilingual Frontier AI** (2026) — EU policy paper; 5 frontier models tested across all 24 EU languages
- **EuroLLM-22B** (2026) — European open LLM covering all 24 EU languages; strongest fully open European alternative
- **Cross-Lingual Stability of LLM Judges** (EACL 2026) — Finno-Ugric languages; surface metrics stable (τ≥0.76), discourse judgments break (τ≈0)
- **NB-REAL 2025** — Nordic-Baltic Responsible Evaluation workshop; Lithuanian history study
- **RefusEU full analysis** (ACL 2026) — cross-lingual similarity Polish-Czech, Portuguese-Spanish; English-only worse for 70B than 8B on low-resource
- **ML-Bench & ML-Guard** (2026) — policy-grounded multilingual safety benchmark from 17 regional AI regulations across 14 languages; no machine translation; dLLM-based guardrail with policy-conditioned compliance; 56K instances
- **Norwegian Safety Audit** (Simula 2026) — 5 models, 36 Norwegian scenarios; 'Understanding Paradox': Qwen3 8B (#116 NLU) worst safety (16 critical failures); Borealis 4B (#249) best safety
- **Auditing Borealis Norwegian LMs** (2026) — 21 models, ≈1,200 audits; Norwegian fine-tuning +13.9 pts at 4B scale; epistemic cost at 12B/27B; 87.5% responses high/critical under adversarial audit
- **CONGRAD** (EACL 2026) — conflicting gradient filtering for multilingual preference alignment; negative cross-lingual interference demonstrated; gradient similarity filtering improves 10-language performance
- **MrGuard** (2025) — multilingual reasoning guardrail; synthetic data + SFT + GRPO curriculum; >15% over baselines; handles code-switching and low-resource distractors
- **Safety of LLMs Beyond English — Systematic Review** (EACL 2026, Krasnodębska et al.) — 43 papers, 111 languages; interactive dashboard; toxicity most common category; evaluation biases documented
- **TryggLLM** (2026) — Norwegian LLM safety benchmark
- **Fluent Alignment with Disfluent Judges** (ICLR 2026) — Norwegian case study; on-policy RL maintains fluency without instruction data; 67.5% over SFT on translated data

### Zero safety studies found (~30+ regions):
Silence is consistent with the pattern: if alignment transferred, we would not need dedicated safety benchmarks for each language.

## Causal mechanisms — fourteen converging lines

| Mechanism | Source | Evidence |
|-----------|--------|----------|
| No universal constraint mechanism | Rocchetti & Ferrara (2026) | Different types at different neural depths; structural=early (reliable), semantic=late (fragile) |
| Gotcha priming failure | Semantic Gravity Wells (2026) | **87.5%** of negative constraint failures: naming the forbidden word **primes** rather than suppresses. The instruction's explicit mention of X activates the target representation. The model attends more to the forbidden word than to "do not." |
| Gotcha FFN override | Semantic Gravity Wells (2026) | **12.5%** of failures: late-layer FFNs (layers 23-27) generate +0.39 toward forbidden token — **4×** larger than successes. Overwhelms earlier suppression. Causal via activation patching. |
| Imperative Interference / Social register | Mason (2026) | Social register mediates processing; declarative transfers universally; imperative fails cross-lingually. **81% variance reduction via declarative switch**. Imperative mood carries different obligatory force across speech communities. |
| Token-dependent safety | LSR + NASB + SomaliBench + Cantonese + CSSBench | Safety guardrails are token-level, not concept-level. Same concept in different token stream → different safety outcome. Chinese homophones/pinyin/symbol-mix bypass token-level detection while preserving concept (CSSBench 2026) |
| Harmfulness–refusal decoupling | LLMs Encode Harmfulness and Refusal Separately (NeurIPS 2025) | Harmfulness direction ≠ refusal direction. Some jailbreaks work by **suppressing refusal signal without changing harmfulness judgment**. Steering along harmfulness direction changes model's perception; refusal direction only changes surface behavior. |
| Cross-lingual safety neurons | SS-Neurons (2026) | Small neuronal subset jointly regulates safety across languages; suppressing them drops NHR safety. **Neuron-level confirmation of why transfer fails** |
| Geometric misalignment | MINIONESE (ICML 2026) | Low-resource jailbreaks route harmful content through a **geometrically misaligned subspace** that projects insufficiently onto refusal directions. Cross-lingual refusal is **effectively one-dimensional**: only the principal refusal direction transfers across languages. Secondary directions carry negative cross-lingual margins. Sharp regime transition between Tier 2 and 3 resource levels. |
| Semantic bottleneck mismatch | LASA (Tsinghua/Alibaba 2026) | Safety alignment enforces in **language-specific representation space**, not **language-agnostic semantic space**. The semantic bottleneck (intermediate layer governed by shared content rather than language identity) exists across all tested models. Anchoring safety there drops average ASR from 24.7%→2.8%. Classical Chinese exploits same mismatch: abundant data but guardrails "optimized for modern languages" fail — safety operates on surface token patterns, not underlying semantics. |
| Language-dependent reasoning | Nuclear Strike (TrustNLP 2026) | **Reasoning language drives moral vocabulary activation.** Japanese reasoning spontaneously generates moral vocabulary ("moral cost", "millions of lives") absent from the prompt. Same model, same strategic scenario, different language → different decision (40%→0% launch). |
| Role confusion / style-tag conflation | Prompt Injection as Role Confusion (2026) | Models perceive role by **style**, not tags. Tags don't survive into representation space. Style and tags map to convergent latent features — when they conflict, style dominates. CoT Forgery achieves 60% ASR against frontier models with near-zero baselines. |
| Safety linear instability | CLS: Geometry of Refusal (TrustNLP 2026) | Safety compliance is a linear steerable feature. **Late Decision** topology (Llama): safety divergence only at final layers, 95% ASR in ~1s. **Early Divergence** (Qwen): safety integrated mid-computation, more robust. Refusal direction isolable via simple logit arithmetic. |
| Over-refusal subspace dimension | Over-Refusal and Subspaces (2026) | Harmful-refusal = task-agnostic global vector. Over-refusal = task-dependent higher-dimensional subspace inside benign clusters. Two refusal types distinct from early layers. Global ablation applies wrong geometry for over-refusal. |
| Answer-safety decoupling | LLM-VA (ACL 2026) | Answer vector (va) and benign vector (vb) are **nearly orthogonal** (~90°) — model encodes answer decision and safety judgment as independent processes. Aligning them resolves jailbreak-overrefusal trade-off. Explains why magnitude-based steering can't fix both. |
| Production backfire / double-priming | Don't Say Never (2026) | Prohibition framing backfires when user prompts name the insecure API (double-priming interaction). The rule's mention of the forbidden API activates the target pattern. Well-intentioned prohibition = same activation as adversarial construction. |

## See also

- RUL.ZERO.COPULA — related linguistic compression pattern
- RUL.DASH.PIVOT — related instruction-pattern convention
- Rocchetti & Ferrara (2026) — mechanistic evidence: constraint types processed at different neural depths; no universal mechanism exists
- CRGC — Constraint Relationship Graph Completion (CUHK 2026): bridge constraints reconcile conflicting requirements, reduce violations by 39%
- ConInstruct (HKU 2026) — conflicting constraint detection: models detect conflicts but rarely communicate them
- Semantic Gravity Wells (2025) — mechanistic evidence: 87.5% priming failure for negative behavioral constraints
- CSE — Constraint Saturation Evaluation: exponential decay beyond 5-6 constraints; failures are independent not interactive
- ELAB (ACL 2025) — Extensive LLM Alignment Benchmark for Persian language; translated AdvBench/HarmBench
- EPT Benchmark (2025) — Evaluation of Persian Trustworthiness; safety weakest dimension across all models
- SomaliBench Eval (arXiv 2605.25420, May 2026) — English→Somali refusal gap 0.38-0.90 across 4 models
- CMiLBench (ACL 2026) — multitask benchmarks incl. safety alignment for Tibetan/Mongolian/Uyghur
- SEA-HELM (ACL 2025 Findings) — holistic evaluation suite incl. safety for SE Asian languages
- Cantonese LLM Jailbreak Library (SyncSoft AI, 2026) — 12 jailbreak patterns, 79% Cantonese attack success vs 0.79% English
- CAALLM (2026-2028) — Culture-Sensitive Assessment and Adjustment of LLMs for Nordic-Baltic societies
- IRLBench (KDD 2026) — Irish-English parallel benchmark; valid Irish responses <80%, correct 55.8% vs 76.2% English
- E-Proxy (EMNLP 2025 Findings) — English as safety anchor; blocks 99% jailbreak via language-mapping prompts
- SS-Neurons (2026) — cross-lingual shared safety neurons; suppressing them drops safety in non-high-resource languages
- MM-ART (TrustNLP 2025) — multi-lingual multi-turn red teaming; 195% more safety vulnerabilities in non-English
- CSRT (ACL 2025) — Code-Switching Red-Teaming; 46.7% more attacks than English-only; safety ∝ resource availability
- CCC-BOS (2026) — Classical Chinese jailbreak; exploits safety blind spot; near-100% ASR across all models
- Strata-Sword (Alibaba 2025) — hierarchical safety eval from reasoning complexity; Chinese-specific attack methods
- JailBench (PAKDD 2025) — comprehensive Chinese jailbreak benchmark; 73.86% ASR against ChatGPT
- CHiSafetyBench (2025) — DeepSeek safety eval in Chinese; DeepSeek-R1 71% vs Qwen 91% on Chinese safety
- Qwen3Guard (2025) — multilingual guardrail for 119 languages; streaming token-level safety detection
- PKU-SafeRLHF (2025) — 166.8K preference data decoupling helpfulness/harmlessness
- CVC / C-VARC (2026) — 250K Chinese value rules for culturally-specific alignment
- COIG-P (2025) — 1M Chinese preference pairs; 2-12% improvement on AlignBench
- Turkish Prompt Injection Benchmark (MDPI 2026) — "safety mechanisms not fully language-invariant"; 55 models, 790 prompts
- UAlign (2025) — first alignment benchmark for Ukrainian; "gap between alignment in Ukrainian and English confirmed"
- PLLuM-Align (EMNLP 2025) — first human-curated Polish preference dataset; safety doesn't transfer from English
- Bielik Guard (2026) — Polish safety classifiers for 5 categories; built because English classifiers fail Polish
- RefusEU (2026) — multilingual refusal alignment for 12 European languages; "English-only alignment insufficient for cross-lingual safety"
- M-ALERT (2024) — 75K multilingual safety prompts across 5 languages; "significant inconsistencies in safety across languages"
- HISTOIRESMORALES (NAACL 2025) — French dataset for assessing moral alignment; "LLMs align better with moral norms in English than French"
- AI Safety Lost in Translation (LREC 2026) — English-Italian cross-lingual safety alignment; "safety doesn't generalize across languages; EN SFT can deteriorate Italian safety"
- BeaverTails-IT (CLiC-it 2025) — first Italian LLM safety benchmark; created because Italian safety unevaluated
- Uncovering Unsafety Traits in Italian LMs (CLiC-it 2025) — first comprehensive Italian safety evaluation
- Schützen (2026) — German-Bulgarian safety dataset; "pronounced cross-language differences in safety behavior"
- GaMS-Instruct-SAFE (2026) — first Slovene instruction-following safety dataset
- TOXIFRENCH (ACL 2026 Findings) — French toxicity detection dataset; SLMs can outperform larger models
- compar:IA (2026) — French government LLM arena; 600K+ prompts, motivated by safety gap in non-English
- EU AI Act (Regulation 2024/1689, effective Aug 2026) — first comprehensive legal framework for AI safety
- EUROPA (2026) — EU frontier AI model covering all 24 official languages
- OpenEuroLLM — EU-funded open multilingual foundation models
- AnswerCarefully (LREC 2026) — first comprehensive Japanese LLM safety dataset; 1,800 manually curated pairs for Japanese socio-cultural context
- Chakoshi (RANLP 2025) — Japanese-oriented guardrail; outperforms baselines on XSTest and RTP-LX; handles Japanese-specific nuance
- Japanese VLM Multimodal Safety (ANLP 2026) — Japanese prompts yield higher violation rates than English in vision-language models
- JMedEthicBench (2026) — multi-turn adversarial medical ethics benchmark for Japanese; safety declines 9.5→5.0 across turns
- Korean Honorific Jailbreak Study (Convergence Security 2025) — honorific Korean bypasses safety alignment; sociolinguistic attack vector
- K-EXAONE (LG, 2026) — Korean sovereign AI with K-AUT taxonomy and KGC-Safety benchmark
- ROK-FORTRESS (2026) — Korean NSPS safety benchmark with transcreation matrix separating language from geopolitical context
- CAGE (2026) — Korean culturally-adapted red-teaming; CA prompts +9.3pp ASR over translation-only
- KSAFE-MM (2026) — Korean multimodal safety benchmark; culturally grounded attacks more effective than generic
- Mi:dm 2.0 (KT, 2026) — Korean bilingual LLM; RL safety training improves 24%p
- TS-Bench + Breeze Guard (MediaTek, 2026) — Taiwan Safety Benchmark + Taiwanese Mandarin safety classifier; global models have blind spots
- TWGuard (2026) — Taiwanese Mandarin guardrail; +0.289 F1, 94.9% FPR reduction
- MINIONESE (ICML 2026) — 18-language mechanistic analysis; "safety regime transition between Tier 2 and 3"; geometric misalignment mechanism
- AISI Multilingual Joint Testing Exercise (2025) — 9 AI Safety Institutes tested 2 models across 10 languages; Japan prompt injection 63.7% vs 26.3% English
- XL-SafetyBench (2026) — 10-country, 37-model safety/culture benchmark; Korean/UAE vulnerability >50% ASR; local model safety is "comprehension failure"
- Lingua-Safe (2025) — 12-language, 45K-entry multilingual safety benchmark
- LogiBreak (ACL 2026) — multilingual logical expression jailbreak across 5 languages
- Mātṛkā (Bhasha 2025) — multilingual jailbreak evaluation across 7 languages (English, Chinese, Korean, Japanese, Malay, Sanskrit, Hindi)
- Cross-Lingual Jailbreak Detection via Semantic Codebooks (2026) — AUC 0.99 on canonical templates, degrades under distribution shift
- MLJailDe (2026) — multilingual jailbreak detection; 98.5% F1, 97.1% on unseen languages
- Culturally-Adapted Red-Teaming (2026) — East/Southeast Asian contexts; CA prompts +9.3pp over translation
- SEA-Guard (ACL 2026 Findings) — first culturally grounded multilingual safeguard for 8 SEA languages; translation-only misses cultural nuances
- SEALGuard (2026) — multilingual guardrail for SEA languages; LlamaGuard DSR drops 18% on SEA jailbreak prompts
- ThaiSafetyBench (2026) — 1,954 Thai malicious prompts including culturally contextualized; "Thai-specific attacks achieve higher ASR"
- IndoSafety (EMNLP 2025) — culturally grounded Indonesian safety dataset across 5 language varieties
- SEAHateCheck (2026) — functional hate speech detection tests for Indonesian, Tagalog, Thai, Vietnamese
- MLC: Align Once, Benefit Multilingually (2026) — multilingual consistency loss lifts all 10 languages to >90% safety
- Sparse Weight Editing (2026) — training-free cross-lingual safety transfer via closed-form weight perturbation
- MSD: Multilingual Self-Distillation (2026) — cross-lingual safety transfer without response-level supervision
- Layer-wise Swapping for Multilingual Safety (EACL 2026) — training-free safety transfer from English to low-resource languages
- KorNAT (NAACL 2025) — Korean National Alignment Test; government-approved benchmark for Korean social values and common knowledge
- KMMLU-Redux/Pro (EMNLP 2025) — professional Korean benchmark suite from National Technical Qualification exams
- Open Ko-LLM Leaderboard2 (NAACL 2025 Industry) — Korean LLM benchmark with Ko-IFEval, Ko-Harmlessness, Ko-Helpfulness
- HyperCLOVA X THINK (2026) — Korean sovereign reasoning LLM with K-AUT taxonomy and KGC-Safety benchmark
- WildGuardTestJP (ANLP 2026) — Japanese guardrail benchmark; English-only guardrails underperform on Japanese
- Rakuten AI 3.0 (2025-2026) — 700B MoE Japanese LLM; Apache 2.0 open-weight release
- J-ART (2026) — Japanese adversarial red-team framework with MITRE ATLAS mapping
- LASA (Tsinghua/Alibaba 2026) — Language-Agnostic Semantic Alignment at semantic bottleneck; average ASR 24.7%→2.8% across all languages
- MLC: Align Once, Benefit Multilingually (BAAI/Peking 2026) — plug-and-play multilingual consistency loss; >90% across 10 languages with DPO/SimPO/ORPO
- CSSBench (2026) — Chinese-Specific Safety Benchmark: pinyin, homophones, symbol-mix, zero-width insertion adversarial patterns for lightweight LLMs
- ChiSafe-PAS (2026) — human-annotated 1,897 Chinese adversarial prompts across 4 high-stakes domains; 9-category obfuscation taxonomy
- CRiskEval (ACL 2025) — Chinese Multi-Level Risk Evaluation; 14,888 questions across 7 frontier risk types; most Chinese LLMs >40% risk tendency
- Libra-Guard/Test (2025) — Chinese safeguard + evaluation benchmark; 86.79% accuracy vs Qwen2.5 74.33%
- JMedEthicBench (2026) — multi-turn medical safety for Japanese healthcare; 52K conversations; safety 9.5→5.0 across turns
- Refusal Direction is Universal Across Safety-Aligned Languages (NeurIPS 2025) — PolyRefuse dataset; refusal direction extracted from English bypasses refusals in 14 languages
- Cross-Lingual Jailbreak Detection via Semantic Codebooks (2026) — training-free external guardrail; AUC 0.99 on canonical templates, degrades under distribution shift
- MLJailDe (2026) — multilingual jailbreak detection; relative-distance constraints + imbalance-aware classification; 98.5% F1, 97.1% unseen languages
- MPO: Multilingual Safety Alignment via Reward Gap Optimization (ACL 2025) — transfers safety from dominant language via reward gap minimization
- LogiBreak (ACL 2026) — formal logical expression jailbreak across 5 languages; exposes token-level vs semantic-level alignment gap
- Automated Generation of Multilingual Jailbreak Prompts (2026) — Multilingual GCG, AutoDAN, and graph-based multilingual traversal
- Improving Methodologies for LLM Evaluations Across Global Languages (2026) — AISI Joint Testing detailed report; Japan 63.7% vs EN 26.3% prompt injection
- PsyCrisis (ACL ARR 2026) — Chinese mental health safety evaluation framework; LLM-as-Judge with expert reasoning chains
- Nuclear Strike — Language-Dependent Moral Reasoning (TrustNLP 2026, ACL) — Japanese prompts reduce Claude nuclear strike rate 40%→0%; reasoning language drives moral vocabulary activation
- KSAFE-MM (2026) — Korean multimodal safety benchmark; culturally grounded attacks + jailbreak 74.2% ASR vs 13.4% standard
- AssurAI (2025) — Korean multimodal safety dataset; 35 risk factors, 11,480 instances across text/image/video/audio
- TWGuard (2026) — Taiwanese Mandarin guardrail; +0.289 F1, 94.9% FPR reduction; "global models lack cultural priors"
- ChineseSafe (SUSTech 2024) — 205K Chinese safety examples across 4 classes, 10 sub-classes; variant/homophonic word detection
- CHiSafetyBench (2024) — Chinese hierarchical safety benchmark; 5 risk areas, 31 categories; automated evaluation validated
- OpenEval (2024, Tianjin Univ.) — Chinese LLM evaluation platform; 35 benchmarks across capability, alignment, safety
- A Chinese Dataset for Evaluating Safeguards (2024) — 3,042 Chinese prompts; region-specific risks determine safety rank
- Camellia (ICLR 2026) — entity-centric cultural bias benchmark for 9 Asian languages; LLMs favor Western entities
- Lingua-SafetyBench (2026) — 100K multimodal safety pairs across 10 languages; image-dominant vs text-dominant risks
- MSD: Multilingual Self-Distillation (2026) — cross-lingual safety transfer via self-distillation without response data
- IMDA Red Teaming Challenge — Japan Case Study (Springer 2026) — Japan monolingual environment shapes stereotype evaluation; 75% Japanese-language prompts more effective
- Culturally Grounded Red Teaming (Springer 2026) — sociotechnical process analysis of Japan IMDA participation; interdisciplinary challenges in LLM safety evaluation
- Why Do Safety Guardrails Degrade Across Languages? (2026) — Multi-Group IRT latent variable model; 61 configs, 10 languages, 1.9M rows; 22 configs MORE vulnerable in English; cultural/conceptual grounding mismatches drive cross-lingual safety gap τ; AUC 0.940 for predicting safe refusal
- Towards Safe Multilingual Frontier AI (2026) — EU policy paper; tests 5 frontier models across all 24 EU languages; mandatory multilingual safety assessments under EU AI Act; "English first mother tongue for <3% of EU population"
- EuroLLM-22B (2026) — European open LLM from scratch covering all 24 EU languages + 11 additional; strongest fully open European alternative
- Cross-Lingual Stability of LLM Judges Under Controlled Generation (EACL 2026) — Finno-Ugric languages (Estonian, Finnish, Hungarian); surface metrics stable τ≥0.76; discourse coherence τ≈0 under identical generation; zero-shot judge transfer unreliable for morphologically rich languages
- NB-REAL 2025 — Nordic-Baltic Responsible Evaluation Workshop; Lithuanian history cross-lingual evaluation; shared cultural context alone does not guarantee better LLM performance
- Schützen full analysis (ACL 2026) — German-Bulgarian; pronounced cross-language differences; region-specific evaluation resources necessary
- ML-Bench & ML-Guard (2026) — policy-grounded multilingual safety benchmark from 17 regional AI regulations (EU AI Act, China, Japan, Korea, Brazil, etc.) across 14 languages; native-language legal text, no translation; dLLM-based guardrail; 56K instances
- Safety of Large Language Models Beyond English: A Systematic Review (EACL 2026, Krasnodębska et al.) — 43 papers, 111 languages catalogued; toxicity most common category; dataset quality and evaluation bias documented; interactive dashboard
- CONGRAD: Conflicting Gradient Filtering for Multilingual Preference Alignment (EACL 2026) — negative cross-lingual interference during multilingual alignment; gradient similarity filtering improves all 10 languages
- MrGuard: Multilingual Reasoning Guardrail (2025) — synthetic multilingual data + SFT + GRPO curriculum; >15% over baselines on multilingual moderation; handles code-switching and low-resource distractors
- Norwegian Safety Audit — Simula Safety Report 1 (2026) — 36 Norwegian scenarios; Qwen3 8B (#116 NLU) = 16 critical failures; Borealis 4B (#249) = best safety; 'Understanding Paradox' of inverse NLU-safety correlation
- Auditing Borealis Norwegian LMs (2026) — 21 models, ≈1,200 audits; Norwegian fine-tuning helps at 4B (+13.9 pts), epistemic cost at 12B/27B; 87.5% responses high/critical under adversarial auditor
- TryggLLM (2026) — Norwegian LLM safety benchmark
- Fluent Alignment with Disfluent Judges (ICLR 2026) — Norwegian case study; on-policy RL preserves fluency; 67.5% preference over SFT on machine-translated data
- NorwAI LLMs Technical Report (2026) — Norwegian LLMs; RLHF for news summarization; NorEval benchmark
- MiJaBench / Selective Safety Trap (ACL 2026) — 43,961 jailbreak prompts × 16 minority groups × bilingual EN/PT; defense rate varies 42% by identity; scaling amplifies demographic disparity
- UbuntuGuard (ACL 2026) — First African safety benchmark; 10 languages, 155 domain experts; English benchmarks overestimate real safety
- LSR: Linguistic Safety Robustness Benchmark (2026) — West African Yoruba/Hausa/Igbo/Igala; 90%→35-55% refusal; Refusal Centroid Drift metric
- HausaSafety / Complex Interference (2025) — 2×4 factorial design, 1,440 evals; reverse linguistic vulnerability; temporal asymmetry 15.6% vs 57.2% safe
- SalamahBench (2026) — Arabic safety benchmark; 8,170 prompts, 12 categories; Fanar/ALLaM/Jais evaluated
- Dialect Safety Gap (TrustNLP 2026) — Systematic degradation by dialect distance from MSA
- MENAValues (ICLR 2026) — 16 MENA countries; Cross-Lingual Value Shifts; Reasoning-Induced Degradation
- AraSafe (EMNLP 2025) — 12K native Arabic prompts; 9 safety categories; Arabic-centric and multilingual models evaluated
- FanarGuard (EACL 2026) — Arabic cultural awareness + safety filter; 468K pairs; matches SOTA safety + cultural alignment
- Curupira (PROPOR 2026) — Brazilian Portuguese guardrail; synthetic data SFT improves safety classification
- CLARIN-PT-LDB (PROPOR 2026) — European Portuguese LLM leaderboard; safety and culture benchmarks
- IndicJR (EACL 2026) — 12 South Asian languages, 45K prompts; contracts inflate refusals; orthography affects safety
- IndicSafe (2026) — First systematic safety eval for 12 Indic languages (1.2B speakers)
- IndicGuard (2026) — 10 Indic language guardrail; outperforms CultureGuard; generalizes to unseen languages
- IndicSteer (StereACuLT 2026) — Inference-time activation steering for Indic; 32-58pp harmful rate reduction
- CompositeHarm (2026) — 6 languages; ASR rises sharply in Indic under adversarial syntax
- Indic-JailbreakBench (TMLR 2026) — 1,668 prompts × 5 languages; Shakespearean style 93% ASR
- Samiksha (2026) — Indian language evaluation; 11 languages, 23K culturally grounded points; 150K human assessments
- Bridging the Multilingual Safety Divide for Global South (AAAI 2026) — Code-mixing >90% ASR; parameter-efficient steering (~3%); attribution-guided repair recovers ~80% safety
- Semantic Gravity Wells: Why Negative Constraints Backfire (2026) — Mechanistic evidence: 87.5% priming failure; 4.4× suppression asymmetry; layers 23-27 causal via activation patching; logistic relationship p=σ(-2.40+2.27·P₀) across 40K samples
- Imperative Interference: Social Register Shapes Instruction Topology (Mason 2026) — 81% cross-linguistic variance reduction via declarative rewriting; topology inversion EN→ES; spillover effects on unrewritten blocks
- Guardrails Beat Guidance: Large-Scale Study of Rules, Skills, and Persistent Configuration for Coding Agents (2026) — 679 rule files, 25K+ rules, 5K+ agent runs; every beneficial rule = negative constraint; random rules match curated (+13.8pp)
- When Prohibitions Become Permissions: Auditing Negation Sensitivity (2026) — 77-100% endorsement under negation; NSI governance metric; 317% increase over affirmative framing
- Polarity Blindness in LLM Safety: Negation, Antonym Substitution, Adversarial Framing (2026) — 4.12/5 harm score; consistent across EN/ES/CZ; polarity inversion undermines guardrails
- Negation Neglect: When models fail to learn negations in training (2026) — 2.5%→88.6% belief rate; all models affected (Kimi K2.5, GPT-4.1, Qwen3.5); extends to behaviors
- Learning from Negative Examples: Why Warning-Framed Training Data Teaches What It Warns Against (2026) — SAE: Feature #8684 activates identically in warning and exploitation contexts; statistical co-occurrence dominates pragmatic interpretation
- LLMs Encode Harmfulness and Refusal Separately (NeurIPS 2025) — Harmfulness direction ≠ refusal direction; Latent Guard using internal harmfulness representation
- Via Negativa for AI Alignment: Why Negative Constraints Are Structurally Superior to Positive Preferences (2026) — Formal proof: negative constraints are discrete/finite/verifiable; positive preferences are continuous/inexhaustible/context-coupled
- Don't Think of the White Bear: Ironic Negation in Transformer Models Under Cognitive Load (2025) — Ironic rebound in LLMs; circuit tracing identifies middle-layer attention heads amplifying forbidden tokens; ReboundBench 5K prompts
- The Attentional White Bear Effect in Transformer Language Models (2026) — Prohibited concepts remain recoverable from hidden representations despite lexical avoidance; gap between behavioral and representational alignment
- Measuring Pragmatic Influence in Large Language Model Instructions (2026) — 400 framing instantiations across 13 strategies, 4 mechanism clusters; authority claims and urgency systematically shift directive prioritization
- When Saying "No" Is Not Enough: Cognitive-Action Decoupling (2026) — Agentic safety: refusal language ≠ safe behavior; text-based metrics underestimate behavioral risk
- Reasoning Up the Instruction Ladder for Controllable Language Models (ACL 2026 Findings) — Instruction hierarchy via reasoning; RLVR training reduces ASR up to 20%; VerIH dataset
- Simple Role Assignment is Extraordinarily Effective for Safety Alignment (ACL 2026 Findings) — Role conditioning (mother, principal) reduces unsafe outputs from 81.4% to 3.6%; Theory of Mind framing
