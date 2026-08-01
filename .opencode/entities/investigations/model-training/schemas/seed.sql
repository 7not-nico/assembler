-- Model Training Research Index — Seed Data
-- Populates all tables from model-training meta-audit

-- Regions
INSERT INTO regions (id, name, notes) VALUES
  ('FUND', 'Fundamentals', 'Core concepts: scaling laws, data efficiency, memory bottlenecks, post-training pipeline'),
  ('EN', 'English (International)', 'arxiv.org, openreview.net — dominant research language'),
  ('CN', 'China', 'Chinese-language surveys from PKU, BNU, ECNU, Xi\'an Jiaotong'),
  ('JP', 'Japan', 'CiNii-indexed; ANLP proceedings; individual papers in English'),
  ('KR', 'South Korea', 'KAIST, SNU, Yonsei, NAIRL — publish in English at top venues'),
  ('DE', 'Germany', 'Jülich, MPG, DFKI, LRZ — HPC infrastructure and energy efficiency focus'),
  ('FR', 'France', 'CNRS, Inria, Sorbonne — frugal learning, low-resource, sovereignty'),
  ('MA', 'Meta-Analyses', 'Large-scale systematic reviews and surveys'),
  ('GAP', 'Gaps', 'Regions with no indexed sources or native-language surveys found');

-- Fundamentals
INSERT INTO fundamentals (id, concept, source, key_idea) VALUES
  ('F.DATA', 'Data-centric efficiency', 'Luo et al. (2025)', 'Five-component data value flywheel: selection, quality, synthetic, distillation, self-evolving'),
  ('F.MEM', 'Memory bottlenecks', 'Unifying Data/Memory/Compute (2025)', 'GPU memory dominant in fine-tuning; jointly reduce weight storage, optimizer states, activation memory'),
  ('F.MID', 'Mid-training', 'Mo et al. (2025)', 'Targeted specialization phase between pre-training and fine-tuning; data distribution, LR scheduling, long-context'),
  ('F.SCALE', 'Chinchilla scaling laws', 'Hoffmann et al. (2022), DeepMind', '20 tokens per parameter for compute-optimal training (later challenged by inference-cost-aware laws)'),
  ('F.LOWP', 'Low-precision training', 'arXiv 2505.01043', 'Fixed-point, floating-point, and custom numerical formats for LLM training'),
  ('F.POST', 'Post-training pipeline', 'Tie et al. (2025)', 'Five paradigms: fine-tuning, alignment, reasoning, efficiency, integration'),
  ('F.HPC', 'HPC training', 'OpenGPT-X (2025), Jülich', 'Megatron-LM, FSDP, FlashAttention, sequence parallelism; 75% iteration time reduction'),
  ('F.MOE', 'Mixture of Experts', 'Multiple surveys (2024-2025)', 'Sparse activation reduces compute per token; MoE + MoD emerging as dominant efficient architecture'),
  ('F.PEFT', 'Parameter-efficient fine-tuning', 'Wan et al. (2023), LoRA (2021)', '<0.1% weights updated; 99.9% parameter reduction; QLoRA enables 65B on single 48GB GPU');

-- Sources
INSERT INTO sources (id, region_id, title, country, institution, key_content, methodology, language, doi_url, year, tags) VALUES
  -- EN
  ('EN.OPENGPTX', 'EN', 'Training LLMs on HPC Systems: Best Practices from the OpenGPT-X Project', 'Germany', 'Jülich Supercomputing Centre', 'Teuken-7B training on JUWELS Booster; Megatron-LM, FSDP, FlashAttention; 75% iteration time reduction', 'case study', 'EN', 'https://arxiv.org/abs/2504.10013', 2025, 'en,hpc,opengptx,megatron-lm'),
  ('EN.DATA', 'EN', 'A Survey on Efficient Large Language Model Training: From Data-centric Perspectives', 'China/US', 'Multiple', 'Five-component data value flywheel; data selection, quality, synthetic, distillation, self-evolving', 'survey', 'EN', 'https://arxiv.org/abs/2510.25817', 2025, 'en,survey,data-centric'),
  ('EN.MID', 'EN', 'Mid-Training of Large Language Models: A Survey', 'Multiple', 'Multiple', 'First taxonomy of LLM mid-training; data distribution, LR scheduling, long-context extension', 'survey', 'EN', 'https://arxiv.org/abs/2510.06826', 2025, 'en,survey,mid-training'),
  ('EN.LOWP', 'EN', 'Low-Precision Training of Large Language Models: Methods, Challenges, and Opportunities', 'Multiple', 'Multiple', 'Three format categories: fixed-point, floating-point, customized; quantization-aware training', 'survey', 'EN', 'https://arxiv.org/abs/2505.01043', 2025, 'en,survey,low-precision'),
  ('EN.EFF', 'EN', 'On Efficient Training of Large-Scale Deep Learning Models: A Literature Review', 'Multiple', 'Multiple', 'Five perspectives: data-centric, model-centric, optimization-centric, budgeted, system-centric', 'survey', 'EN', 'https://arxiv.org/abs/2304.03589', 2023, 'en,survey,efficient-training'),
  ('EN.LLM', 'EN', 'Understanding LLMs: A Comprehensive Overview from Training to Inference', 'Multiple', 'Multiple', 'Training: data preprocessing, architecture, pretraining, parallel training, finetuning; Inference: compression, scheduling', 'survey', 'EN', 'https://arxiv.org/abs/2401.02038', 2024, 'en,survey,llm-overview'),
  ('EN.EFF2', 'EN', 'Efficient Large Language Models: A Survey', 'Multiple', 'Multiple', 'Model-centric (quantization, pruning, distillation), data-centric, framework-centric taxonomy', 'survey', 'EN', 'https://arxiv.org/abs/2312.03863', 2023, 'en,survey,efficient,compression'),
  ('EN.DIST', 'EN', 'Efficient Training of Large Language Models on Distributed Infrastructures: A Survey', 'Multiple', 'Multiple', 'Data, tensor, pipeline, sequence parallelism; FSDP, ZeRO, Megatron', 'survey', 'EN', 'https://arxiv.org/abs/2407.20018', 2024, 'en,survey,distributed'),
  ('EN.UNIFY', 'EN', 'Unifying Data, Memory, and Compute Efficiency in LLM training: A Survey', 'Multiple', 'Multiple', 'Constraint-centric perspective; dynamic data selection identified as critical research gap', 'survey', 'EN', 'https://arxiv.org/abs/2606.10706', 2025, 'en,survey,unified,constraint'),
  ('EN.POST', 'EN', 'A Survey on Post-training of Large Language Models', 'Multiple', 'Multiple', 'Five paradigms: fine-tuning, alignment, reasoning, efficiency, integration; first PoLM survey', 'survey', 'EN', 'https://arxiv.org/abs/2503.06072', 2025, 'en,survey,post-training'),
  ('EN.ARCH', 'EN', 'Speed Always Wins: A Survey on Efficient Architectures for Large Language Models', 'Multiple', 'Multiple', 'Linear/sparse attention, MoE, hybrid architectures, diffusion LLMs', 'survey', 'EN', 'https://arxiv.org/abs/2508.09834', 2025, 'en,survey,architectures'),
  ('EN.COMP', 'EN', 'A Comprehensive Overview of Large Language Models', 'Multiple', 'Multiple', 'Architecture, training strategies, context length, fine-tuning, multimodal, LLM datasets', 'survey', 'EN', 'https://arxiv.org/abs/2307.06435', 2024, 'en,survey,comprehensive'),
  ('EN.PEAK', 'EN', 'Achieving Peak Performance for Large Language Models: A Systematic Review', 'Multiple', 'Multiple', 'PRISMA SLR of 65/983 papers; training optimization, hardware, scalability', 'SLR', 'EN', 'https://arxiv.org/abs/2409.04833', 2024, 'en,slr,peak-performance'),
  ('EN.ATTN', 'EN', 'Efficient Attention Mechanisms for Large Language Models: A Survey', 'Multiple', 'Multiple', 'Linear (kernelized, recurrent, fast-weight) and sparse (fixed, block, clustering) attention', 'survey', 'EN', 'https://arxiv.org/abs/2507.19595', 2025, 'en,survey,attention'),
  ('EN.AUTOML', 'EN', 'Large Language Models for Constructing and Optimizing ML Workflows: A Survey', 'Multiple', 'Multiple', 'LLMs for AutoML: data engineering, model selection, HPO, workflow evaluation', 'survey', 'EN', 'https://arxiv.org/abs/2411.10478', 2024, 'en,survey,automl'),
  ('EN.MEM', 'EN', 'A Survey on Memory-Efficient Large-Scale Model Training in AI for Science', 'Multiple', 'Multiple', 'Memory-efficient training for AlphaFold2, biology, medicine, chemistry, meteorology', 'survey', 'EN', 'https://arxiv.org/abs/2501.11847', 2025, 'en,survey,memory,ai4science'),
  ('EN.DESIGN', 'EN', 'Designing Large Foundation Models for Efficient Training and Inference: A Survey', 'Multiple', 'Multiple', 'Model design, system design, model-system co-design for efficiency', 'survey', 'EN', 'https://arxiv.org/abs/2409.01990', 2024, 'en,survey,foundation-models'),
  ('EN.GREATS', 'EN', 'GREATS: Online Selection of High-Quality Data for LLM Training', 'Multiple', 'Multiple', 'Scalable online data selection via gradient-based utility scoring', 'method', 'EN', 'https://openreview.net/forum?id=232VcN8tSx', 2025, 'en,data-selection,online'),

  -- CN
  ('CN.COMPUTE', 'CN', '面向大语言模型训练的智能计算系统综述', 'China', 'ICT CAS', 'LLM training on intelligent computing systems; distributed computing, memory, efficiency', 'survey', 'ZH', 'https://jcst.ict.ac.cn/cn/article/doi/10.1007/s11390-024-4178-1', 2025, 'cn,survey,computing-systems'),
  ('CN.PEFT', 'CN', '大模型参数高效微调方法综述: 技术、趋势与挑战', 'China', 'Peking University', 'Four PEFT paradigms: additive, selective, reparameterized, hybrid; quantitative comparison', 'survey', 'ZH', 'https://aas.net.cn/cn/article/doi/10.16383/j.aas.c250451', 2026, 'cn,survey,peft'),
  ('CN.CL', 'CN', '面向大模型时代的持续学习方法论演变', 'China', 'Xi\'an Jiaotong University', 'Evolution from non-pretrained to pretrained continual learning; data/model/loss/theory levels', 'survey', 'ZH', 'https://aas.net.cn/cn/article/doi/10.16383/j.aas.c240805', 2025, 'cn,survey,continual-learning'),
  ('CN.AL', 'CN', '从选择到生成：基于LLM的主动学习综述', 'China', 'Multiple', 'Active learning with LLMs: selection to generation; taxonomy of LLM-based AL', 'survey', 'ZH', 'https://aclanthology.cn/2025.acl-long.708/', 2025, 'cn,survey,active-learning'),
  ('CN.INDUSTRIAL', 'CN', '工业大模型白皮书 (2025)', 'China', 'Beihang University', 'Industrial LLM: data preparation, base model training, task adaptation for manufacturing', 'white paper', 'ZH', 'https://www.cdut.edu.cn', 2025, 'cn,white-paper,industrial'),
  ('CN.EXPLAIN', 'CN', '大语言模型可解释性研究综述', 'China', 'Multiple', 'Interpretability in pre-training, instruction tuning, alignment', 'survey', 'ZH', 'https://www.jcad.cn', 2026, 'cn,survey,explainability'),
  ('CN.CL2', 'CN', '深度模型的持续学习综述：理论、方法和应用', 'China', 'Multiple', 'Continual learning: regularization, replay, gradient, network structure methods', 'survey', 'ZH', 'https://jeit.ac.cn/cn/article/doi/10.11999/JEIT240095', 2024, 'cn,survey,continual-learning'),

  -- JP
  ('JP.OVERVIEW', 'JP', 'A Comprehensive Overview of Large Language Models', 'Japan', 'CiNii / ACM TIST', 'Broad LLM survey: architecture, training, fine-tuning, multimodal, datasets', 'survey', 'EN', 'https://cir.nii.ac.jp/crid/1360307817250501120', 2025, 'jp,survey,llm-overview'),
  ('JP.STEP', 'JP', 'STEP: Staged Parameter Efficient Pre-training', 'Japan', 'Multiple (ANLP)', 'Memory-efficient pretraining via model expansion + PET; 53.9% max memory reduction at equal performance', 'method', 'JP', 'https://www.anlp.jp/proceedings/annual_meeting/2025/pdf_dir/Q4-10.pdf', 2025, 'jp,pretraining,memory,step'),
  ('JP.LLMJP3', 'JP', '日本語大規模言語モデルの事前訓練過程における下流タスク性能の網羅的な分析', 'Japan', 'NII / Tokyo', 'LLM-jp-3: training process analysis across 8 model sizes; 3 typical downstream performance patterns', 'analysis', 'JP', 'https://www.anlp.jp/proceedings/annual_meeting/2025/pdf_dir/P7-13.pdf', 2025, 'jp,analysis,pretraining,llm-jp'),
  ('JP.SYNTH', 'JP', '合成データと能動学習を用いた大規模言語モデルへの効率的な知識定着', 'Japan', 'Multiple (ANLP)', 'Synthetic data + active learning for knowledge retention; perplexity and diversity sampling', 'method', 'JP', 'https://www.anlp.jp/proceedings/annual_meeting/2025/pdf_dir/C8-3.pdf', 2025, 'jp,synthetic,active-learning,retention'),
  ('JP.ANALYSIS', 'JP', '大規模言語モデル訓練における速度・精度革新手法の体系的時系列分析', 'Japan', 'Individual (Hatena)', 'Time-series analysis of speed/accuracy innovation in LLM training; SALT, PPO, algorithm distillation', 'analysis', 'JP', 'https://anond.hatelabo.jp/20250223002434', 2025, 'jp,analysis,speed-accuracy'),

  -- KR
  ('KR.VTRAIN', 'KR', 'VTrain: A Simulation Framework for Cost-Effective LLM Training', 'South Korea', 'KAIST', 'Profiling-driven simulator for optimal parallelization strategies; case studies on cost and compute-optimal architecture', 'method', 'EN', 'https://pure.kaist.ac.kr/en/publications/vtrain-a-simulation-framework-for-evaluating-cost-effective-and-c/', 2024, 'kr,simulator,parallelization,cost'),
  ('KR.PERILN', 'KR', 'Peri-LN: Revisiting Normalization Layer in the Transformer', 'South Korea', 'KAIST', 'Peri-LN placement: balanced variance growth, steadier gradient flow; validated up to 3.2B params', 'method', 'EN', 'https://pure.kaist.ac.kr/en/publications/peri-ln-revisiting-normalization-layer-in-the-transformer-archite/', 2025, 'kr,normalization,transformer,peri-ln'),
  ('KR.SF', 'KR', 'Through the River: Understanding Schedule-Free Methods for LM Training', 'South Korea', 'KAIST', 'SF-AdamW navigates loss landscape without decay phases; implicit weight averaging without memory overhead', 'method', 'EN', 'https://koasas.kaist.ac.kr/handle/10203/337210', 2025, 'kr,optimization,schedule-free'),
  ('KR.LORA', 'KR', 'Enhancing LoRA Fine-tuning Performance Using Curriculum Learning', 'South Korea', 'Multiple (Korea Science)', 'Data heterogeneity-based curriculum learning for LoRA; outperformed traditional fine-tuning on Korean document classification', 'method', 'KO', 'https://www.koreascience.kr/article/JAKO202415754220104.page', 2024, 'kr,lora,curriculum-learning,korean'),
  ('KR.STELLA', 'KR', 'StellaTrain: Accelerating Model Training in Multi-cluster Environments with Consumer-grade GPUs', 'South Korea', 'KAIST', 'Cache-aware gradient compression + CPU sparse optimizer; 104x speedup over PyTorch DDP; 64.5% cost reduction', 'method', 'EN', 'https://ina.kaist.ac.kr/assets/bibliography/Stellatrain.pdf', 2024, 'kr,multi-cluster,consumer-gpu,compression'),
  ('KR.ACUTE', 'KR', 'Optimizing Multi-Level Checkpointing for DDL on Cloud Spot VMs', 'South Korea', 'Sogang University', 'ACUTE: 43.30% faster checkpointing; Check-Mem, Check-Trans, Check-Pack optimizations', 'method', 'EN', 'https://discos.sogang.ac.kr/file/2024/intl_jour/IEEE_ACCESS_2024_Y_Cho.pdf', 2024, 'kr,checkpointing,spot-vm,ddl'),
  ('KR.DYNAS', 'KR', 'Subnet-Aware Dynamic Supernet Training for Neural Architecture Search', 'South Korea', 'Yonsei University', 'Complexity-aware LR scheduler + momentum separation for NAS supernet training', 'method', 'EN', 'https://cvlab.yonsei.ac.kr/projects/DYNAS/', 2025, 'kr,nas,supernet,training'),
  ('KR.SCALE', 'KR', 'Neural Scaling: Efficiency and Accessibility', 'South Korea', 'NAIRL', 'Inference cost optimization, training cost optimization, innovative model development', 'research program', 'KO', 'https://nairl.kr/ko/neural-scaling/', 2025, 'kr,scaling,efficiency'),
  ('KR.PPL', 'KR', 'Policy-labeled Preference Learning: Is Preference Enough for RLHF', 'South Korea', 'Seoul National University', 'PPL overcomes RLHF limitation (meaningless comparison of low-alignment pairs); ICML 2025 Spotlight', 'method', 'EN', 'https://arxiv.org/pdf/2505.06273', 2025, 'kr,rlhf,alignment,icml-spotlight'),
  ('KR.BOOK', 'KR', 'Foundations of Large Language Models (book review)', 'South Korea', 'Community (PyTorchKR)', 'Comprehensive LLM book covering training, fine-tuning, prompting, alignment, RLHF', 'book', 'KO', 'https://discuss.pytorch.kr/t/pdf-231p-feat-arxiv/5895', 2025, 'kr,book,llm-foundations'),
  ('KR.METHODS', 'KR', 'Training Methods for Large Language Models: Current Approaches and Challenges', 'South Korea', 'MDPI (multinational)', 'Systematic mapping study: pre-training, SFT, alignment, PEFT, RAG, multimodal, MoE', 'survey', 'EN', 'https://www.mdpi.com/2227-7080/14/2/133', 2026, 'kr,survey,training-methods'),

  -- DE
  ('DE.OPENGPTX', 'DE', 'Training LLMs on HPC Systems (OpenGPT-X)', 'Germany', 'Jülich Supercomputing Centre', 'Megatron-LM transition; FlashAttention2, sequence parallelism, ALiBi, Adan; 75% iteration time reduction', 'case study', 'EN', 'https://arxiv.org/abs/2504.10013', 2025, 'de,hpc,opengptx,megatron'),
  ('DE.MPG', 'DE', 'Self-Learning Physical Machines for Neuromorphic AI Training', 'Germany', 'MPI for Light / MPG', 'Reversible nonlinear physical processes for training without external feedback; optical neuromorphic computer', 'method', 'DE', 'https://www.mpg.de/20826723/', 2023, 'de,neuromorphic,physical,training'),
  ('DE.DFKI', 'DE', 'ESCADE: Energy-Efficient Large-Scale AI for Sustainable Data Centers', 'Germany', 'DFKI / Uni Saarland', 'Knowledge distillation, neural architecture search for 90% model size reduction; steel scrap sorting use case', 'project', 'DE', 'https://www.dfki.de/web/news/nachhaltige-rechenzentren', 2025, 'de,energy,efficiency,distillation'),
  ('DE.LRZ', 'DE', 'Training Language Models on SuperMUC-NG Phase 2', 'Germany', 'Leibniz Supercomputing Centre', 'GPT-style model training on Intel GPU accelerators; tensor/pipeline/data parallelism evaluation', 'experimental', 'DE', 'https://www.lrz.de/forschung/forschungsprojekte/detail/mit-sng2-sprachmodelle-trainieren', 2025, 'de,hpc,lrz,intel-gpu'),
  ('DE.DENA', 'DE', 'Energy-Efficient AI Study', 'Germany', 'dena / Fraunhofer HHI', 'Federated learning optimization; Neural Network Coding (NNC) standard for model transmission compression', 'study', 'DE', 'https://www.dena.de/fileadmin/dena/Publikationen/PDFs/2024/Studie_Energieeffiziente_kuenstliche_Intelligenz.pdf', 2024, 'de,energy,federated-learning,nnc'),
  ('DE.RWTH', 'DE', 'Dataset Storage Optimization for ML on HPC', 'Germany', 'RWTH Aachen', 'Comparison of Numpy, LMDB, HDF5, Zarr for dataset I/O on parallel filesystems', 'thesis', 'DE', 'https://publications.rwth-aachen.de/record/1009964', 2025, 'de,storage,hpc,io'),
  ('DE.ECO', 'DE', 'ECO: Error-Compensating Optimizer for Quantized LLM Training', 'Germany', 'Community (Mind-Verse)', 'Quantized training without master weights; error-feedback loop; near lossless accuracy at reduced memory', 'method', 'DE', 'https://www.mind-verse.de/news/effizientes-quantisiertes-training-llms-error-compensating-optimizer', 2025, 'de,quantization,optimizer,eco'),
  ('DE.HORNS', 'DE', 'HORNs: Harmonically Oscillating Recurrent Networks', 'Germany', 'MPG / ESI Frankfurt', 'Oscillating networks using wave interference computing; learn faster, tolerate noise, fewer parameters', 'method', 'DE', 'https://www.mpg.de/24840403/F001_Fokus_025-029.pdf', 2025, 'de,oscillating-networks,horns,energy'),
  ('DE.TRAINING', 'DE', '12. Trainingspipeline und Inferenzoptimierung (book chapter)', 'Germany', 'Michael Kipp (Individual)', 'Training pipeline: pre-training, mid-training, SFT, alignment; LoRA, RLHF, quantization, KV-cache, MoE, reasoning models', 'book chapter', 'DE', 'https://michaelkipp.de/neuronalenetze/LLMTraining.html', 2025, 'de,pipeline,training,inference'),

  -- FR
  ('FR.CNRS', 'FR', 'Deep Learning on Jean Zay Supercomputer (training course)', 'France', 'CNRS/IDRIS', 'GPU acceleration, mixed precision, distributed training, FSDP, ZeRO, model parallelism on Jean Zay', 'course', 'FR', 'https://cnrsformation.cnrs.fr/catalogue/formation/31/deep-learning-optimise-sur-supercalculateur/', 2025, 'fr,hpc,idris,jean-zay'),
  ('FR.DATA', 'FR', 'Data Augmentation Strategies for Low-Resource LLM Domains', 'France', 'CORIA-TALN 2025', 'Survey of data augmentation for biomedical and legal QA; few-shot generation, RAG, contrastive learning', 'survey', 'FR', 'https://coria-taln-2025.lis-lab.fr/wp-content/uploads/2025/06/CORIA-TALN_2025_paper_79.pdf', 2025, 'fr,survey,data-augmentation,low-resource'),
  ('FR.SCOPE', 'FR', 'SCOPE: Self-Supervised Framework for Faithfulness in Conditional Text Generation', 'France', 'CORIA-TALN 2025 (ICLR 2025)', 'Self-supervised generation of unfaithful examples for preference-based fine-tuning; improves faithfulness', 'method', 'FR', 'https://coria-taln-2025.lis-lab.fr/wp-content/uploads/2025/06/CORIA-TALN_2025_paper_84.pdf', 2025, 'fr,self-supervised,fine-tuning,faithfulness'),
  ('FR.CONTAM', 'FR', 'Contamination Detection in LLMs: Practical Literature Review', 'France', 'CORIA-TALN 2025', 'Taxonomy of contamination; white/gray/black box detection; similarity, probability, extraction methods', 'survey', 'FR', 'https://coria-taln-2025.lis-lab.fr/wp-content/uploads/2025/06/CORIA-TALN_2025_paper_62.pdf', 2025, 'fr,survey,contamination,detection'),
  ('FR.AL', 'FR', 'Active Learning with LLMs for NER (Mixtral-8x7B)', 'France', 'CORIA-TALN 2025', 'Active learning with Mixtral-8x7B annotations for NER; 80% data reduction; CamemBERT fine-tuning', 'method', 'FR', 'https://coria-taln-2025.lis-lab.fr/wp-content/uploads/2025/06/CORIA-TALN_2025_paper_129.pdf', 2025, 'fr,active-learning,ner,mixtral'),
  ('FR.OPT', 'FR', 'New Insights in DL Optimization', 'France', 'CentraleSupélec', 'Lyapunov analysis for DL; adaptive LR strategies; convergence guarantees; RAG/RAGL mini-batch optimizers', 'method', 'FR', 'https://l2s.centralesupelec.fr/wp-content/uploads/uqsay/uqsay85_slides_bbensaid.pdf', 2025, 'fr,optimization,lyapunov,convergence'),
  ('FR.MULTI', 'FR', 'Multilevel Approach to Accelerate Transformer Training', 'France', 'GRETSI 2025', 'ODE-based multilevel training; coarse/fine network hierarchy; 44% FLOPs reduction at same loss', 'method', 'FR', 'https://gretsi.fr/data/colloque/pdf/2025_lauga1616.pdf', 2025, 'fr,multilevel,training,transformer'),
  ('FR.FRUGAL', 'FR', 'Neural Architecture Growth for Frugal Learning', 'France', 'Inria/LRI', 'Growing networks from 1 neuron; expressivity bottleneck detection; optimal neuron addition via backprop', 'method', 'FR', 'https://www.lri.fr/~gcharpia/Frugal_AI_internship.pdf', 2025, 'fr,frugal,growing-networks,architecture'),
  ('FR.PIPELINE', 'FR', 'Pipeline d\'entraînement des LLM — du texte brut au modèle utile', 'France', 'Labo LLM (Individual)', 'Scaling laws, Chinchilla, SFT, RLHF, DPO, reward hacking; comparative cost analysis across model scales', 'guide', 'FR', 'https://www.labo-llm.fr/fondamentaux/training-pipeline', 2025, 'fr,pipeline,scaling-laws,rlhf'),
  ('FR.SORBONNE', 'FR', 'LLM Optimization and Adaptation for Low-Resource Languages', 'France', 'Sorbonne University', 'PhD proposal: data augmentation, fine-tuning, RLHF for Kabyle language; sovereign LLM development', 'PhD proposal', 'FR', 'https://www.sorbonne-universite.fr/sites/default/files/media/2026-03/BOUZEFRANE%20Samia_ED432.pdf', 2026, 'fr,low-resource,kabyle,sovereignty'),
  ('FR.CAMEMBERT', 'FR', 'CamemBERT: Impact of Training Data Size and Heterogeneity', 'France', 'Inria / Multiple', '4GB high-variability data matches 138GB uniform data for BERT pretraining quality on French', 'study', 'FR', 'https://camembert-model.fr/files/wp-content/uploads/jep-taln-recital-2020_paper_151.pdf', 2020, 'fr,camembert,pretraining,data-quality'),
  ('FR.ANR', 'FR', 'Giga-modèles pour le TALN et données multimodales (ANR TSIA)', 'France', 'CNRS / Multiple', 'MALADES (medical French LLMs), Pantagruel (multimodal inclusive French LLMs), InExtenso (bias evaluation)', 'funding program', 'FR', 'https://www.ins2i.cnrs.fr/fr/cnrsinfo/des-giga-modeles-pour-le-traitement-automatique-du-langage-naturel-et-des-donnees', 2023, 'fr,anr,sovereign,multimodal');

-- Meta-analyses
INSERT INTO meta_analyses (id, title, scope, key_finding, effect_size, sample_size, doi_url) VALUES
  ('MA.DATA', 'Efficient LLM Training: Data-centric Perspectives', '200+ papers', 'Five-component data value flywheel; synthetic data and self-evolving ecosystems emerging', 'taxonomy', '200+ papers', 'https://arxiv.org/abs/2510.25817'),
  ('MA.LOWP', 'Low-Precision Training of LLMs', 'comprehensive', 'Three format categories: fixed-point, floating-point, customized; QAT overlap with low-precision training', 'taxonomy', 'comprehensive', 'https://arxiv.org/abs/2505.01043'),
  ('MA.MID', 'Mid-Training of LLMs: A Survey', 'first unified paradigm', 'Three domains: data distribution, LR scheduling, long-context extension; gradient noise scale explanation', 'first taxonomy', 'comprehensive', 'https://arxiv.org/abs/2510.06826'),
  ('MA.EFF', 'Efficient Large Language Models: A Survey', '200+ papers', 'Model-centric (quantization, pruning, distillation), data-centric, framework-centric', 'taxonomy', '200+ papers', 'https://arxiv.org/abs/2312.03863'),
  ('MA.DIST', 'Efficient Training on Distributed Infrastructures', 'comprehensive', 'Data, tensor, pipeline, sequence parallelism; FSDP, ZeRO, Megatron survey', 'taxonomy', 'comprehensive', 'https://arxiv.org/abs/2407.20018'),
  ('MA.UNIFY', 'Unifying Data, Memory, and Compute Efficiency', 'constraint-centric', 'Resource-conditioned decision-making; dynamic data selection identified as critical gap', 'framework', 'comprehensive', 'https://arxiv.org/abs/2606.10706'),
  ('MA.POST', 'Post-training of LLMs: A Survey', 'first comprehensive', 'Five paradigms; LRMs (o1/o3, DeepSeek-R1) represent shift to reasoning-centric training', 'taxonomy', 'comprehensive', 'https://arxiv.org/abs/2503.06072'),
  ('MA.ARCH', 'Efficient Architectures for LLMs: A Survey', '2023-2025', 'Linear attention, sparse attention, MoE, hybrid designs, diffusion LLMs for efficiency', 'taxonomy', 'comprehensive', 'https://arxiv.org/abs/2508.09834'),
  ('MA.ATTN', 'Efficient Attention Mechanisms: A Survey', 'comprehensive', 'Linear (kernelized, recurrent, fast-weight) and sparse (fixed, block, clustering) attention', 'taxonomy', 'comprehensive', 'https://arxiv.org/abs/2507.19595'),
  ('MA.SYS', 'Peak Performance for LLMs: Systematic Review', '65/983 papers via PRISMA', 'Training optimization, hardware optimization, scalability, and reliability strategies', 'SLR', '65 studies', 'https://arxiv.org/abs/2409.04833');

-- Researchers
INSERT INTO researchers (id, name, region_id, institution, specialisation) VALUES
  ('R.LUO', 'Junyu Luo', 'EN', 'Peking University', 'Data-centric LLM training survey'),
  ('R.MO', 'Kaixiang Mo', 'EN', '—', 'Mid-training paradigm'),
  ('R.TIE', 'Guiyao Tie', 'EN', '—', 'Post-training surveys'),
  ('R.WAN', 'Zhongwei Wan', 'EN', '—', 'Efficient LLMs survey'),
  ('R.SUN', 'Weigao Sun', 'EN', '—', 'Efficient architectures'),
  ('R.JOHN', 'Chelsea John', 'DE', 'Jülich Supercomputing Centre', 'OpenGPT-X HPC training'),
  ('R.MARQUARDT', 'Florian Marquardt', 'DE', 'MPI for Light', 'Neuromorphic training, self-learning physical machines'),
  ('R.MAASS', 'Wolfgang Maaß', 'DE', 'DFKI / Uni Saarland', 'Energy-efficient AI, ESCADE project'),
  ('R.JANZEN', 'Sabine Janzen', 'DE', 'DFKI', 'Knowledge distillation, model compression'),
  ('R.RAJGOPAL', 'Ajay Navilarekal Rajgopal', 'DE', 'LRZ Munich', 'GPT training on SuperMUC-NG (Intel GPU)'),
  ('R.DUFOUR', 'Richard Dufour', 'FR', 'LS2N / Nantes University', 'MALADES project, sovereign French medical LLMs'),
  ('R.SCHWAB', 'Didier Schwab', 'FR', 'LIG / Grenoble', 'Pantagruel multimodal French LLMs'),
  ('R.CHARPIA', 'Guillaume Charpiat', 'FR', 'Inria / LRI', 'Frugal learning, neural architecture growth'),
  ('R.VERBOCK', 'Manon Verbockhaven', 'FR', 'Inria / LRI', 'Growing tiny networks, expressivity bottlenecks'),
  ('R.AMALVY', 'Arthur Amalvy', 'FR', 'LS2N / LIA', 'Long document LLM adaptation'),
  ('R.BOUZEFR', 'Samia Bouzefrane', 'FR', 'Sorbonne University', 'LLM adaptation for Kabyle and low-resource languages'),
  ('R.BENSAID', 'Benjamin Bensaid', 'FR', 'CentraleSupélec', 'DL optimization, Lyapunov analysis'),
  ('R.LIM', 'Hwijoon Lim', 'KR', 'KAIST', 'StellaTrain, multi-cluster training with consumer GPUs'),
  ('R.LEE', 'Jeongwoo Lee', 'KR', 'Seoul National University', 'PPL: policy-labeled RLHF (ICML 2025 Spotlight)'),
  ('R.KIM', 'Kwanghoon Kim', 'KR', 'NAIRL', 'Neural scaling, efficiency, accessibility'),
  ('R.JEON', 'J. Jeon', 'KR', 'Yonsei University', 'DYNAS: dynamic supernet training for NAS'),
  ('R.YANO', 'Kazuki Yano', 'JP', '—', 'STEP: staged parameter-efficient pretraining'),
  ('R.NISHIDA', 'Yuto Nishida', 'JP', 'NII / Tokyo', 'LLM-jp-3 training process analysis'),
  ('R.TAKEISHI', 'Naoya Takeishi', 'JP', 'University of Tokyo', 'ML for scientific models, simulation-based inference');

-- Gaps
INSERT INTO gaps (id, region_name, status, notes) VALUES
  ('GAP.JP.SURVEY', 'Japan', 'no native surveys', 'JP publishes LLM training results in English; no comprehensive Japanese-language survey identified'),
  ('GAP.KR.SURVEY', 'Korea', 'no native surveys', 'KR institutions publish in English at top venues; VTrain, Peri-LN, StellaTrain are individual papers, not surveys'),
  ('GAP.DE.SURVEY', 'Germany', 'no native survey', 'DE focus on HPC infrastructure and energy efficiency; no systematic native survey of training methods found'),
  ('GAP.FR.SURVEY', 'France', 'no native survey', 'FR targets low-resource, frugal learning, sovereignty; no comprehensive training survey in French'),
  ('GAP.ES', 'Spain', 'not searched', 'Could produce LLM training research in Spanish/Catalan'),
  ('GAP.RU', 'Russia', 'not searched', 'May have training research especially for non-Latin scripts'),
  ('GAP.IT', 'Italy', 'not searched', 'Italian NLP community active but model training coverage unknown'),
  ('GAP.BR', 'Brazil', 'not searched', 'Portuguese-language ML community could have relevant surveys');
