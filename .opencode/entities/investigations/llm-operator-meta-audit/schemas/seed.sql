-- Seed data: LLM Logical Operators vs Semantic Phrasing investigation

INSERT OR IGNORE INTO investigations (id, title, summary, tags) VALUES
('INV.LLM.OPERATOR', 'Logical Operators vs Semantic Phrasing in LLM Instructions', 'Cross-region investigation (13+ regions, 50+ papers, 189 searches) into whether writing instructions with logical operators instead of declarative semantic phrasing is problematic for LLM instruction following.', 'llm,prompt-engineering,logical-operators,semantic,constraint,specification,instruction-following,cross-lingual');

-- Fundamentals
INSERT OR IGNORE INTO fundamentals (id, investigation_id, title, finding, evidence, confidence) VALUES
('FUN.001', 'INV.LLM.OPERATOR', 'Simple NL is functional scaffolding',
 'Simple natural language structures act as useful thinking tokens that help attention mechanisms capture boolean operator relationships.',
 'Scaffolding or Obstacle (Ni, 2026): controlled experiments on Boolean ASTs with varying NL complexity.', 'High'),
('FUN.002', 'INV.LLM.OPERATOR', 'Operator fidelity is model-specific',
 'Operator fidelity varies more across model families than any other instruction format variable. Conjunction fails at 0-21% across ALL models.',
 'MetaGlyph (van Gassen, 2026): 8 models, 4 operators, 4 task families.', 'High'),
('FUN.003', 'INV.LLM.OPERATOR', 'Instruction-tuning destroys operator comprehension',
 'Mid-sized instruction-tuned models (7-12B) show 0% operator fidelity vs small base models (3B) at 33%.',
 'MetaGlyph: U-shaped fidelity curve — small OK, mid-sized worst, frontier recovers.', 'High'),
('FUN.004', 'INV.LLM.OPERATOR', 'Operators and semantics use different neural depths',
 'Structural constraints (operators) processed in early layers; semantic in late layers. They compete rather than compose.',
 'Rocchetti & Ferrara (2026): probing across 9 tasks in 3 models.', 'High'),
('FUN.005', 'INV.LLM.OPERATOR', 'Imperative register fails cross-lingually',
 'Instructions that cooperate in English compete in Spanish. Declarative register eliminates 81% of cross-linguistic variance.',
 'Mason (2026): 4 languages, 4 models, 56-block system prompt ablation.', 'High'),
('FUN.006', 'INV.LLM.OPERATOR', 'Priming is dominant negation failure mode',
 '87.5% of negation failures caused by naming the forbidden word activating rather than suppressing it. Suppression signal 4.4x weaker in failures.',
 'Semantic Gravity Wells (2026): 40,000 samples across transformers.', 'High'),
('FUN.007', 'INV.LLM.OPERATOR', 'XOR dissociates reasoning from output',
 'Correct reasoning chain produces wrong declared answer. Models 99.99% confident when wrong. Requires 2 attention heads minimum.',
 'Rao et al. (2026): Novel Operator Test, 5 models, 8,100 problems.', 'High'),
('FUN.008', 'INV.LLM.OPERATOR', 'Token reduction is the only proven operator benefit',
 'Compact constraint encoding shows no statistically significant improvement in constraint satisfaction rate. Effect size Cliff''s delta < 0.01.',
 'Tang (2026): 11 models, 16 benchmarks, 830+ LLM invocations.', 'High');

-- Regions
INSERT OR IGNORE INTO regions (id, investigation_id, name, languages, searches, sources_found, status) VALUES
('REG.GLOBAL', 'INV.LLM.OPERATOR', 'Global/English', 'EN', 12, 18, 'PASS'),
('REG.CN', 'INV.LLM.OPERATOR', 'China', 'ZH-CN', 8, 8, 'PASS'),
('REG.RU', 'INV.LLM.OPERATOR', 'Russia', 'RU', 6, 4, 'PASS'),
('REG.JP', 'INV.LLM.OPERATOR', 'Japan', 'JA', 6, 6, 'PASS'),
('REG.KR', 'INV.LLM.OPERATOR', 'Korea', 'KO', 6, 4, 'PASS'),
('REG.ROMANCE', 'INV.LLM.OPERATOR', 'France/Romance Europe', 'FR,ES,IT,PT', 6, 6, 'PASS'),
('REG.GERMANIC', 'INV.LLM.OPERATOR', 'Germany/Nordic', 'DE,SV,DA,NO,FI', 5, 5, 'PASS'),
('REG.PL', 'INV.LLM.OPERATOR', 'Poland/Central Europe', 'PL,CS,HU', 4, 3, 'PASS'),
('REG.SEA', 'INV.LLM.OPERATOR', 'Southeast Asia', 'TH,VI,ID,TL', 5, 4, 'PASS'),
('REG.TR', 'INV.LLM.OPERATOR', 'Turkey', 'TR', 4, 3, 'PASS'),
('REG.IR', 'INV.LLM.OPERATOR', 'Iran', 'FA', 3, 3, 'PASS'),
('REG.AR', 'INV.LLM.OPERATOR', 'Arabic', 'AR', 3, 3, 'PASS'),
('REG.AFRICA', 'INV.LLM.OPERATOR', 'Africa', 'SW,YO,HA', 3, 2, 'PASS');

-- Sources (18 core)
INSERT OR IGNORE INTO sources (id, investigation_id, region_id, title, authors, institution, key_finding, methodology, url, year, venue) VALUES
('SRC.METAGLYPH', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Semantic Compression of LLM Instructions via Symbolic Metalanguages', 'Ernst van Gassen', null, 'Symbolic operators achieve 62-81% token reduction but conjunction fails at 0-21% across all models. Instruction-tuning degrades operator fidelity.', '8 models, 4 task families, 3 prompt types (NL/symbolic/control)', 'https://arxiv.org/abs/2601.07354', 2026, 'arXiv'),
('SRC.SCAFFOLD', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Scaffolding or Obstacle: Quantifying the Dual Role of Natural Language in Transformer-based Logic', 'Ziang Ni', null, 'Simple NL structures act as thinking tokens helping attention capture operator relationships. Complex NL shifts processing to FFN layers.', 'Boolean AST dataset with varying NL complexity, multi-layer Transformers', 'https://doi.org/10.5281/zenodo.19311555', 2026, 'Zenodo'),
('SRC.GRAVITY', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Semantic Gravity Wells: Why Negative Constraints Backfire', null, null, '87.5% of negation failures from priming. Suppression 4.4x weaker in failures. Two failure modes: priming (87.5%) and override (12.5%).', '40,000 samples, logit lens, activation patching', 'https://arxiv.org/abs/2601.08070', 2026, 'arXiv'),
('SRC.CORRECTCHAINS', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Correct Chains, Wrong Answers: Dissociating Reasoning from Output in LLM Logic', 'Abinav Rao, Sujan Rachuri, Nikhil Vemuri', null, 'XOR: 100% of depth-7 errors have correct reasoning but wrong answer. Trojan operator test confirms logical not lexical failure.', 'Novel Operator Test, 5 models, 8,100 problems, depths 1-10', 'https://arxiv.org/abs/2604.13065', 2026, 'ICLR 2026 WS'),
('SRC.BREAKS', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Where Reasoning Breaks: Logic-Aware Path Selection by Controlling Logical Connectives', 'Seunghyun Park, Yuanyuan Lei', 'Independent / U. Florida', 'Single connective change derails 41.1% of correct chains. 1.75x more destructive than non-connective perturbations. Connectives = 4-7% of tokens.', 'Token-level entropy analysis, single-token perturbation, 4 models', 'https://arxiv.org/abs/2604.20564', 2026, 'ACL 2026 Findings'),
('SRC.IMMEDIATE', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Immediate Inference: The Missing Foundation in LLM Logical Reasoning', 'Sihang Jiang, Zhiyu Lu, Keyi Wang, Jiaqing Liang, Yanghua Xiao, Xiaojun Meng, Jiansheng Wei', null, 'Models lack robust operator grounding, oscillating between structural reasoning and surface matching. Operator errors mediate ~40% of syllogistic reasoning effects.', 'IIBench benchmark, correlation analysis across reasoning benchmarks', 'https://aclanthology.org/2026.acl-long.808/', 2026, 'ACL 2026'),
('SRC.IMPERATIVE', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Imperative Interference: Social Register Shapes Instruction Topology in LLMs', 'Tony Mason', null, 'Imperatives cooperate in English, compete in Spanish. Declarative register reduces cross-lingual variance by 81%. Spillover effects on unrewritten blocks.', '22 hand-authored probes, 56-block system prompt, 4 languages, 4 models', 'https://arxiv.org/abs/2603.25015', 2026, 'arXiv'),
('SRC.ROCCHETTI', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'How LLMs Follow Instructions: Skillful Coordination, Not a Universal Mechanism', 'Elisabetta Rocchetti, Alfio Ferrara', null, 'No universal constraint mechanism. Structural (operators) in early layers, semantic in late. Cross-task transfer weak. Dynamic monitoring during generation.', 'Diagnostic probing across 9 tasks, 3 models, causal ablation', 'https://arxiv.org/abs/2604.06015', 2026, 'arXiv'),
('SRC.COMPACT', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Compact Constraint Encoding for LLM Code Generation', 'Hanzhang Tang', null, 'No statistically significant CSR improvement from compact encoding (Cliff''s delta < 0.01). Token reduction is the only benefit.', '11 models, 16 benchmarks, 830+ LLM invocations, 6 rounds', 'https://arxiv.org/abs/2604.07192', 2026, 'arXiv'),
('SRC.OVERRIDE', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'When Models Ignore Definitions: Measuring Semantic Override Hallucinations', 'Yogeswar Reddy Thota, Setareh Rafatirad, Houman Homayoun, Tooraj Nikoubin', null, 'Models revert to pretrained operator defaults despite explicit local redefinition. Boolean gates fail when semantics overridden.', '30 logic/digital-circuit reasoning tasks, 3 frontier LLMs', 'https://arxiv.org/abs/2602.17520', 2026, 'arXiv'),
('SRC.SOFTPROMPT', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'SoftPrompt-IR: Declarative Symbolic Representation', null, null, '98% cross-model consensus on symbolic operators across 5 frontier models. 75-92% token reduction. Zero-shot interpretation.', 'Zero-shot cross-model testing, 5 frontier architectures', 'https://github.com/tobs-code/SoftPrompt-IR', 2026, 'GitHub'),
('SRC.LSRIF', 'INV.LLM.OPERATOR', 'REG.CN', 'LsrIF: Logic-Structured Reinforcement Learning for Instruction Following', 'Qingyu Ren, Qianyu He, Jingwen Chang, Jie Zeng, Jiaqing Liang, Yanghua Xiao, et al.', null, 'Logic-structured training shifts attention to logical connectors. Parallel penalty propagation improves arithmetic +10.6.', 'Logic-structured dataset + structure-aware reward modeling', 'https://arxiv.org/abs/2601.06431', 2026, 'arXiv'),
('SRC.NEGATION', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'How Language Models Process Negation', 'Zhejian Zhou, Tianyi Zhou, Robin Jia, Jonathan May', null, 'Construction mechanism dominates suppression. Late-layer shortcut heads overwrite correct negation. Sinking them recovers +17% accuracy.', 'Attention sinking, path patching, LogitLens, SAE contrastive attribution', 'https://arxiv.org/abs/2605.03052', 2026, 'ICML 2026'),
('SRC.STEERING', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Compositional Steering of LLMs with Steering Tokens', null, null, 'Learned steering tokens + NL instructions beats either alone (62.9% vs 57.4%). Generalizes across 7 models, 5 families.', 'Self-distillation, learned composition token, 7 models', null, 2026, 'ACL 2026'),
('SRC.NEGATIONCN', 'INV.LLM.OPERATOR', 'REG.CN', 'A Study on the Reasoning Ability of LLMs Using Negation Principles in Chinese Sentences', 'Ran Li, Lingxiang Fan, Gan Ze, Zhaoyang Gao, Lifei Wang, Renjia Xiao, Zhe Yu, Guiyun Zhao, Zhe Lin', null, '14 LLMs tested on negation in Chinese. Models adopt intuitionist/minimal negation over classical. CoT helps inconsistently.', '15 negation properties, 14 LLMs (11 Chinese, 3 English)', null, 2026, 'AAAI 2026 Bridge'),
('SRC.TYPHOON', 'INV.LLM.OPERATOR', 'REG.SEA', 'Typhoon T1: An Open Thai Reasoning Model', null, null, 'Forced Thai reasoning degrades accuracy. Unconstrained > English-forced > Thai-forced. Structured XML thinking format.', 'SFT with Thai reasoning traces, structured thinking format', 'https://arxiv.org/abs/2502.09042', 2026, 'arXiv'),
('SRC.SYMSURVEY', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'A Survey on LLM Symbolic Reasoning', 'Jindong Li, Yali Fu, Yang Yang, Jiahong Liu, Hongce Zhang, Haoxuan Li, et al.', null, 'First comprehensive survey of LLM symbolic reasoning. Systematic taxonomy: formalization, logic programming, theorem proving, neuro-symbolic.', 'Systematic literature review', 'https://openreview.net/pdf?id=L3zwjjdI1x', 2026, 'AAAI 2026 Bridge'),
('SRC.ONESAT', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Compact Constraint Encoding: Null Result', 'Hanzhang Tang', null, 'Replication confirming no CSR improvement from operator encoding across 3 independent rounds. Constraint type is the real driver of compliance.', '6 rounds, 3 encoding forms, 4 propagation modes', 'https://arxiv.org/abs/2604.07192', 2026, 'arXiv');

-- Operators
INSERT OR IGNORE INTO operators (id, investigation_id, symbol, name, verdict, mechanism, fidelity_range) VALUES
('OP.AND', 'INV.LLM.OPERATOR', '∩, &&, AND', 'Conjunction', 'Never use for multi-constraint composition', 'Models interpret as list punctuation, not logical conjunction', '0-21%'),
('OP.OR', 'INV.LLM.OPERATOR', '∪, ||, OR', 'Disjunction', 'Avoid — scope ambiguity', 'Models default to inclusive OR, ambiguity in constraint scope', 'Varies'),
('OP.XOR', 'INV.LLM.OPERATOR', 'XOR', 'Exclusive OR', 'Unreliable in all tested models', 'Correct reasoning chain produces wrong answer. 2-head minimum.', '0% at depth 7'),
('OP.NOT', 'INV.LLM.OPERATOR', '!, ¬, NOT', 'Negation', 'Worst operator choice', 'Priming: naming target activates it (87.5% failures). Override: FFN overwhelms (12.5%).', '0-33% (model-dependent)'),
('OP.IMP', 'INV.LLM.OPERATOR', '⇒, →', 'Implication', 'Model-specific', '98.1% on Kimi K2, 0% on everyone else tested', '0-98%'),
('OP.MEM', 'INV.LLM.OPERATOR', '∈', 'Membership', 'Frontier-model only', 'GPT-5.2: 91.3%. Mid-size IT: 0%. Simple selection only.', '0-91%'),
('OP.CONN', 'INV.LLM.OPERATOR', 'therefore, however, but', 'Logical connective', 'Handle with care — single point of failure', '41% of correct chains derailed by 1 change. 1.75x destructive power.', 'N/A'),
('OP.PSEUDO', 'INV.LLM.OPERATOR', 'IF/ELSE, SWITCH', 'Pseudo-code', 'Works on frontier models', '+36% accuracy, -87% tokens. 98% consensus on frontier.', '98% consensus'),
('OP.STEER', 'INV.LLM.OPERATOR', 'Learned token', 'Steering token', 'Promising but requires training', '62.9% compositional accuracy. Hybrid with NL best.', 'N/A');

-- Operator fidelity data points
INSERT OR IGNORE INTO operator_fidelity (id, operator_id, model_name, fidelity_pct, task_type, source_id) VALUES
('FID.AND.GPT5', 'OP.AND', 'GPT-5.2 Chat', 21.4, 'Constraint composition', 'SRC.METAGLYPH'),
('FID.AND.GEMINI', 'OP.AND', 'Gemini 2.5 Flash', 2.7, 'Constraint composition', 'SRC.METAGLYPH'),
('FID.AND.CLAUDE', 'OP.AND', 'Claude Haiku 4.5', 1.5, 'Constraint composition', 'SRC.METAGLYPH'),
('FID.AND.LLAMA3', 'OP.AND', 'Llama 3B', 0, 'Constraint composition', 'SRC.METAGLYPH'),
('FID.AND.QWEN7', 'OP.AND', 'Qwen 7B', 0, 'Constraint composition', 'SRC.METAGLYPH'),
('FID.AND.OLMO7', 'OP.AND', 'OLMo 7B', 0, 'Constraint composition', 'SRC.METAGLYPH'),
('FID.AND.GEMMA12', 'OP.AND', 'Gemma 12B', 0, 'Constraint composition', 'SRC.METAGLYPH'),
('FID.IMP.KIMI', 'OP.IMP', 'Kimi K2', 98.1, 'Conditional logic', 'SRC.METAGLYPH'),
('FID.IMP.GEMINI', 'OP.IMP', 'Gemini 2.5 Flash', 33.5, 'Conditional logic', 'SRC.METAGLYPH'),
('FID.MEM.GPT5', 'OP.MEM', 'GPT-5.2 Chat', 91.3, 'Selection', 'SRC.METAGLYPH'),
('FID.MEM.GEMINI', 'OP.MEM', 'Gemini 2.5 Flash', 49.9, 'Selection', 'SRC.METAGLYPH'),
('FID.MEM.KIMI', 'OP.MEM', 'Kimi K2', 36.0, 'Selection', 'SRC.METAGLYPH'),
('FID.MEM.LLAMA3', 'OP.MEM', 'Llama 3B', 33.3, 'Selection', 'SRC.METAGLYPH'),
('FID.MEM.CLAUDE', 'OP.MEM', 'Claude Haiku 4.5', 26.0, 'Selection', 'SRC.METAGLYPH'),
('FID.MEM.QWEN7', 'OP.MEM', 'Qwen 7B', 20.4, 'Selection', 'SRC.METAGLYPH'),
('FID.MEM.OLMO7', 'OP.MEM', 'OLMo 7B', 0, 'Selection', 'SRC.METAGLYPH'),
('FID.MEM.GEMMA12', 'OP.MEM', 'Gemma 12B', 0, 'Selection', 'SRC.METAGLYPH');

-- Failure modes
INSERT OR IGNORE INTO failure_modes (id, investigation_id, name, prevalence_pct, mechanism, affected_operators, mitigation) VALUES
('FM.PRIMING', 'INV.LLM.OPERATOR', 'Priming failure', 87.5, 'Instruction naming the forbidden target activates rather than suppresses it', 'NOT, !, ¬', 'Declarative phrasing: "X: disabled" avoids target naming'),
('FM.OVERRIDE', 'INV.LLM.OPERATOR', 'Override failure', 12.5, 'Late-layer FFN contributions overwhelm earlier suppression signals', 'NOT, !, ¬', 'Post-generation filtering, activation steering at layers 23-27'),
('FM.DISSOC', 'INV.LLM.OPERATOR', 'Reasoning-output dissociation', 100, 'Correct structural reasoning produces wrong semantic output. Model 99.99% confident when wrong.', 'XOR, mixed operator chains', 'Avoid XOR; use explicit enumeration; external verification'),
('FM.SEMOVERRIDE', 'INV.LLM.OPERATOR', 'Semantic override', null, 'Model reverts to pretrained operator defaults despite explicit local redefinition', 'All operators', 'Out-of-prompt enforcement; formal verification; structured output'),
('FM.CONNFRAG', 'INV.LLM.OPERATOR', 'Connective fragility', 41.1, 'Single token change at logical connective derails correct reasoning trajectory', 'therefore, however, but, so', 'Explicit logical relation specification; avoid reliance on model-chosen connectives'),
('FM.ATOMGAP', 'INV.LLM.OPERATOR', 'Atomic instruction gap', null, 'Surface format drives behavior, not logical intent. 30.44% accuracy drop between label formats.', 'Symbolic labels (A/B vs 1/2)', 'Instruction invariance training; decouple symbolic control from semantic content'),
('FM.ITDEGRADE', 'INV.LLM.OPERATOR', 'Instruction-tuning degradation', null, 'IT optimizes for NL fluency, overwriting operator circuits. 0% vs 33% fidelity.', 'All operators on 7-12B models', 'Hybrid operator+NL; frontier models only; verify fidelity on target');

-- Researchers
INSERT OR IGNORE INTO researchers (id, investigation_id, region_id, name, institution, focus) VALUES
('RES.VANGASSEN', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Ernst van Gassen', null, 'Symbolic metalanguages, prompt compression'),
('RES.RAO', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Abinav Rao', null, 'Boolean operator reasoning-output dissociation'),
('RES.NI', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Ziang Ni', null, 'Scaffolding role of NL in transformer logic'),
('RES.PARK', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Seunghyun Park', 'Independent', 'Logical connective fragility, reasoning chain dynamics'),
('RES.LEI', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Yuanyuan Lei', 'University of Florida', 'Logical subspace steering, reasoning failure analysis'),
('RES.ROCCHETTI', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Elisabetta Rocchetti', null, 'Mechanistic understanding of instruction following'),
('RES.FERRARA', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Alfio Ferrara', null, 'Constraint satisfaction mechanisms in LLMs'),
('RES.REN', 'INV.LLM.OPERATOR', 'REG.CN', 'Qingyu Ren', null, 'Logic-structured RL for instruction following'),
('RES.MASON', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Tony Mason', null, 'Imperative interference, social register, instruction topology'),
('RES.THOTA', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Yogeswar Reddy Thota', null, 'Semantic override hallucinations, operator redefinition failures'),
('RES.TANG', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Hanzhang Tang', null, 'Compact constraint encoding token economics'),
('RES.ZHOUZ', 'INV.LLM.OPERATOR', 'REG.GLOBAL', 'Zhejian Zhou', null, 'Negation processing mechanisms in LLMs'),
('RES.LI', 'INV.LLM.OPERATOR', 'REG.CN', 'Ran Li', null, 'Chinese negation reasoning, non-classical logic in LLMs'),
('RES.MORISHITA', 'INV.LLM.OPERATOR', 'REG.JP', 'Terufumi Morishita', 'Hitachi', 'Japanese logic benchmarks, FLDx2 corpus'),
('RES.TRYBUS', 'INV.LLM.OPERATOR', 'REG.PL', 'Adam Trybus', null, 'Bielik-R Polish reasoning model development');

-- Meta-analyses
INSERT OR IGNORE INTO meta_analyses (id, investigation_id, title, source_count, coverage, key_conclusion) VALUES
('MA.SYMSURVEY', 'INV.LLM.OPERATOR', 'A Survey on LLM Symbolic Reasoning', 120, 'Comprehensive taxonomy of symbolic reasoning in LLMs', 'LLM symbolic reasoning remains fragmented. Key challenges: prompt design, syntax correction, lack of symbolic knowledge acquisition, architectural coherence, representation alignment.'),
('MA.NESYSURVEY', 'INV.LLM.OPERATOR', 'Neuro-Symbolic AI: A Task-Directed Survey', 80, 'Task-specific NeSy methods across NLP and CV', 'Federative architectures consistently outperform injective ones. Trade-off between interpretability and data efficiency. Synthetic benchmarks limit conclusions.'),
('MA.NESYNLP', 'INV.LLM.OPERATOR', 'Neuro-symbolic NLP: Taxonomy, Assessment, and Directions', 60, 'NeSy NLP with CL classification framework', 'Federative systems outperform injective but are underexplored. Field should scale federative architectures to foundation-model size.');

-- Gaps
INSERT OR IGNORE INTO gaps (id, investigation_id, description, severity, suggested_research) VALUES
('GAP.BENCH', 'INV.LLM.OPERATOR', 'No standardized operator fidelity benchmark exists. Each study uses different tasks, models, and metrics.', 'High', 'Create a common benchmark: standard operators x standard model families x standard task types'),
('GAP.SCALE', 'INV.LLM.OPERATOR', 'All operator fidelity data stops at approximately 1T parameters. Unknown whether operator comprehension continues improving with scale.', 'Medium', 'Test operator fidelity on >1T parameter models across all operator types'),
('GAP.LOWRES', 'INV.LLM.OPERATOR', 'Only 1-2 papers per low-resource language. Many language families have zero operator fidelity data.', 'High', 'Systematic operator fidelity evaluation in 10+ low-resource languages'),
('GAP.COMPOSE', 'INV.LLM.OPERATOR', 'How multiple operators interact when composed is unknown. Current data tests one operator at a time.', 'Medium', 'Operator interaction matrix: test all pairs of operators in composition'),
('GAP.TRAINING', 'INV.LLM.OPERATOR', 'When during pretraining do operator circuits emerge? When does instruction-tuning overwrite them?', 'Medium', 'Training dynamics study: probe operator circuits throughout pretraining and IT'),
('GAP.COUNTER', 'INV.LLM.OPERATOR', 'Do models understand operator semantics or just pattern-match from training data?', 'Low', 'Counterfactual operator reasoning test with novel operator definitions');
