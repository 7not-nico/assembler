-- Modular Library Architecture — Global Research Index Seed Data

-- Regions
INSERT INTO regions (id, name, notes) VALUES
  ('FUND', 'Fundamentals', 'Core principles: high cohesion, low coupling, clear interfaces, information hiding, single responsibility, acyclic dependency, separation of concerns'),
  ('JP', 'Japan', 'Japanese-language sources; kaizen quality emphasis, manufacturing-influenced modularity'),
  ('DE', 'Germany/Austria', 'German-language sources; IEEE 1471 formal definition, academic architecture curricula'),
  ('FR', 'France', 'French-language sources; SoC-first approach, interface contracts as binding agreements'),
  ('CN', 'China', 'Chinese-language sources; 高内聚低耦合, SOLID mapped to Chinese, Parnas cited'),
  ('ES', 'Spain', 'Spanish-language source; physical construction analogy for modularity'),
  ('US', 'US/International', 'English-language sources; SOLID, Clean Architecture, package metrics, tooling enforcement'),
  ('MA', 'Meta-Analyses', 'Cross-region systematic reviews of modular architecture principles'),
  ('GAP', 'Gaps', 'Regions with no indexed sources or native-language surveys found');

-- Fundamentals
INSERT INTO fundamentals (id, concept, source, key_idea) VALUES
  ('F.HIGHCOHESION', 'High cohesion', 'Universal (all regions)', 'Module internals are tightly related to a single purpose — 高内聚 (CN), 高い凝集度 (JP), haute cohésion (FR)'),
  ('F.LOWCOUPLING', 'Low coupling', 'Universal (all regions)', 'Modules depend on each other minimally — 低耦合 (CN), 低い結合度 (JP), couplage faible (FR)'),
  ('F.CLEARINTERFACE', 'Clear interface contracts', 'Universal (all regions)', 'Communication through well-defined APIs, not internal details — contrat d''interface (FR), 接口契约 (CN)'),
  ('F.INFOHIDING', 'Information hiding', 'Parnas 1972', 'Internal implementation is encapsulated behind the interface — 情報隠蔽 (JP), masquage d''informations (FR)'),
  ('F.SRP', 'Single responsibility', 'Martin 2002', 'One module = one reason to change — 单一职责 (CN), Einzelverantwortung (DE)'),
  ('F.ACYCLIC', 'Acyclic dependency', 'Martin 1994', 'Dependency graph is a DAG — 循环依赖禁止 (CN), zyklenfreie Abhängigkeiten (DE)'),
  ('F.SEPCONCERNS', 'Separation of concerns', 'Universal (all regions)', 'Divide by what changes together — 关注点分离 (CN), séparation des préoccupations (FR)');

-- Sources
INSERT INTO sources (id, region_id, title, country, institution, key_content, methodology, language, doi_url, year, tags) VALUES
  -- Japan
  ('JP.BREXA', 'JP', 'モジュール設計とは？メリットと導入効果、現場での課題と対策まとめ', 'Japan', 'BREXA Technology', 'Modular design definition, benefits (independence, reusability, extensibility), implementation steps; kaizen quality approach', 'industry guide', 'JA', 'https://engineering-technology.brexa.com/blog/technavi/dr-modulardesign', 2026, 'jp,brexa,guide'),
  ('JP.CADDi', 'JP', 'モジュール設計のメリットと導入効果', 'Japan', 'CADDi Inc.', 'Module design for manufacturing — challenge of derivative models, standardization, reuse rate measurement', 'industry guide', 'JA', 'https://caddi.com/ja-jp/resources/library/16129', 2026, 'jp,caddi,manufacturing'),
  ('JP.OGAWA', 'JP', 'Software Factory in Japan and Europe/USA with ChatGPT', 'Japan', 'Dr. Kiyoshi Ogawa / Qiita', 'Historical comparison: Japan kaizen + process standardization vs West tooling + automation; modularity as shared value', 'analysis', 'EN, JA', 'https://qiita.com/kaizen_nagoya/items/0e97bbc08d48cecd4dde', 2025, 'jp,ogawa,software-factory'),

  -- Germany
  ('DE.TECNOVY', 'DE', 'Softwarearchitektur: Definition, Prinzipien, Design', 'Germany', 'Tecnovy', 'IEEE Std 1471-2000 definition; 7-step architecture development; component identification, interface definition, pattern application', 'educational guide', 'DE', 'https://tecnovy.com/de/software-architektur-ultimative-leitfaden', 2026, 'de,tecnovy,ieee'),
  ('DE.WILEX', 'DE', 'Softwarearchitektur — Enzyklopädie der Wirtschaftsinformatik', 'Germany', 'WI-Lex / Prof. Dr. Elmar Sinz', 'Architecture = Bauplan (blueprint) + Konstruktionsregeln (construction rules); granularity levels; application system architecture', 'encyclopedia entry', 'DE', 'https://www.wi-lex.de/lexikon/entwicklung-und-management-von-informationssystemen/systementwicklung/softwarearchitektur', 2022, 'de,wilex,sinz,academic'),
  ('DE.STUDY', 'DE', 'Softwareentwicklung — Softwarearchitektur (StudySmarter)', 'Germany', 'StudySmarter', 'Academic software architecture curriculum; modularity in university CS programs', 'academic curriculum', 'DE', 'https://www.studysmarter.de/studium/informatik-studium/softwareentwicklung/softwarearchitektur', 2026, 'de,studysmarter,academic'),
  ('DE.INZTITUT', 'DE', 'Softwarearchitektur und Software Design', 'Germany', 'INZTITUT / Sascha Block', 'Robust software architecture; customer-centered design; modular libraries as core principle', 'consulting guide', 'DE', 'https://inztitut.de/software-technologie/softwarearchitektur-und-software-design', 2023, 'de,inztitut,consulting'),

  -- France
  ('FR.APPMASTER', 'FR', 'Pourquoi utiliser une architecture modulaire dans la conception de logiciels', 'France', 'AppMaster', '5 principes clés: SoC, cohésion élevée, couplage faible, masquage d''informations, communication basée sur l''interface; contrats d''interface clairs', 'educational guide', 'FR', 'https://appmaster.io/fr/blog/pourquoi-utiliser-une-architecture-modulaire-dans-la-conception-de-logiciels', 2023, 'fr,appmaster,principles'),
  ('FR.OPENCLASSROOMS', 'FR', 'Apprenez l''architecture modulaire', 'France', 'OpenClassrooms', 'Modular architecture structure: baseline product, main system, customer interface, plug-in modules; advantages and disadvantages', 'educational course', 'FR', 'https://openclassrooms.com/courses/7210131-definissez-votre-architecture-logicielle-grace-aux-standards-reconnus/7371321-apprenez-l-architecture-modulaire', 2024, 'fr,openclassrooms,course'),
  ('FR.TNC', 'FR', 'Architecture modulaire: définition et avantages', 'France', 'TNC Solutions', 'Modular vs monolithic comparison table; flexibility, maintenance, scalability, reusability; evolution of modular architecture', 'industry article', 'FR', 'https://tnc-solutions.com/architecture-modulaire-definition-et-avantages', 2025, 'fr,tnc,comparison'),

  -- China
  ('CN.ALIYUN', 'CN', '软件架构设计的原则与模式: 构建高质量系统的基石', 'China', 'Alibaba Cloud Developer', 'Full SOLID in Chinese; 高内聚低耦合; 迪米特原则 (Law of Demeter); layered/microservice/event-driven architecture patterns', 'developer guide', 'ZH', 'https://developer.aliyun.com/article/1572074', 2024, 'cn,aliyun,solid'),
  ('CN.CNBLOGS', 'CN', '模块化系统设计——复杂系统分析的实践路径', 'China', 'CNBlogs / 郝海', 'Modular system design theory; cites Parnas 1972, Baldwin & Clark 2000, Schilling 2000; 高内聚低耦合; 接口定义 as key to modularization', 'academic analysis', 'ZH', 'https://www.cnblogs.com/haohai9309/p/18924840', 2025, 'cn,cnblogs,academic'),
  ('CN.HUAWEI', 'CN', '模块化设计-应用架构', 'China', 'Huawei HarmonyOS', 'Official best practices: contract-based interfaces, independent compilation and deployment, UIAbility components, feature modules', 'official documentation', 'ZH', 'https://developer.huawei.com/consumer/cn/doc/best-practices/bpta-modular-design', 2026, 'cn,huawei,official'),
  ('CN.REFACTORING', 'CN', '设计模式 (RefactoringGuru.cn)', 'China', 'Refactoring Guru', 'Complete GoF design pattern catalog in Chinese; SOLID principles; module-level design patterns; information hiding', 'reference site', 'ZH', 'https://refactoringguru.cn/design-patterns', 2026, 'cn,refactoring,patterns'),

  -- Spain
  ('ES.JGARQS', 'ES', 'ARQUITECTURA MODULAR', 'Spain', 'JG Arqs', 'Physical construction analogy: prefabricated modules, standardized interfaces, interconnection, replaceability; modular architecture in building design', 'architecture blog', 'ES', 'https://www.jgarqs.com/blog/2020/8/28/arquitectura-modular', 2020, 'es,jgarqs,building'),

  -- US/International
  ('US.MARTIN-BOOK', 'US', 'Clean Architecture: A Craftsman''s Guide to Software Structure and Design', 'US', 'Robert C. Martin', 'SOLID principles, Dependency Rule, component principles (ADP/CCP/SDP/SAP/REP/CRP), layered architecture with dependency direction', 'book', 'EN', 'https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164', 2017, 'us,martin,book'),
  ('US.MARTIN-CLEAN-ARCH', 'US', 'The Clean Architecture (blog post)', 'US', 'Robert C. Martin', 'Dependency Rule: source code dependencies point inwards; entities, use cases, adapters, frameworks; independent of UI/DB/frameworks', 'blog post', 'EN', 'https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html', 2012, 'us,martin,blog'),
  ('US.BOUNDARIES', 'US', 'eslint-plugin-boundaries v7.0.2', 'Global', 'Javier Brea', 'Architectural boundary enforcement: classify files by element type + file category, define allow/disallow policies per dependency direction', 'open source tool', 'EN', 'https://www.npmjs.com/package/eslint-plugin-boundaries', 2026, 'us,brea,eslint,tool'),
  ('US.STRAPI', 'US', 'SOLID Design Principles Guide for JavaScript and TypeScript', 'Global', 'Strapi', 'SOLID for modern JS/TS; practical examples for each principle; one-principle-at-a-time adoption strategy', 'developer guide', 'EN', 'https://strapi.io/blog/solid-design-principles-javascript-typescript-guide', 2025, 'us,strapi,solid'),
  ('US.PVIZ', 'US', 'TypeScript Module Boundaries: Barrel Files vs Clean Architecture', 'Global', 'PViz Generator', 'Barrel files create hidden coupling; direct imports reveal architecture; architectural boundaries > barrel files; enforce with eslint-plugin-import and eslint-plugin-boundaries', 'engineering blog', 'EN', 'https://pvizgenerator.com/blog/typescript-module-boundaries', 2026, 'us,pviz,barrel'),

  -- Meta-Analyses
  ('MA.PACKAGE-PRINCIPLES', 'MA', 'Package Principles (ADP, CCP, REP, CRP, SDP, SAP)', 'Global', 'Robert C. Martin', 'Six principles for package design: cohesion (REP/CCP/CRP) and coupling (ADP/SDP/SAP); the 6 canonical package-level rules', 'multiple papers + book', 'EN', 'https://en.wikipedia.org/wiki/Package_Principles', 1994, 'ma,martin,package'),
  ('MA.ADP-KNOERN', 'MA', 'Acyclic Dependencies Principle', 'Global', 'Kirk Knoernschild', 'ADP states dependency graph must be a DAG; cycles limit reusability, increase coupling, violate layering; breaking strategies: DIP, new package', 'whitepaper', 'EN', 'https://www.kirkk.com/main/pdf/adp.pdf', 2001, 'ma,knoernschild,adp');

-- Researchers
INSERT INTO researchers (id, name, region_id, institution, specialisation) VALUES
  ('R.MARTIN', 'Robert C. Martin (Uncle Bob)', 'US', 'cleancoder.com', 'SOLID principles, Clean Architecture, package design (ADP/CCP/SDP)'),
  ('R.PARNAS', 'David L. Parnas', 'US', 'University of Limerick', 'Information hiding, modular decomposition criteria (1972 seminal paper)'),
  ('R.BALDWIN-CLARK', 'Carliss Y. Baldwin & Kim B. Clark', 'US', 'Harvard Business School', 'Design Rules: The Power of Modularity (2000) — modularity in design and innovation'),
  ('R.BREA', 'Javier Brea', 'Global', 'npm / open source', 'eslint-plugin-boundaries — architectural boundary enforcement in TypeScript/JS'),
  ('R.SINZ', 'Prof. Dr. Elmar Sinz', 'DE', 'University of Bamberg / WI-Lex', 'Software architecture as Bauplan + Konstruktionsregeln, business information systems'),
  ('R.HAOHAI', '郝海 (Hao Hai)', 'CN', 'CNBlogs', 'Modular system design for complex systems; Chinese-language software architecture education');

-- Gaps
INSERT INTO gaps (id, region_name, status, notes) VALUES
  ('GAP.ME', 'Middle East / Arabic', 'no native surveys', 'No Arabic-language sources on modular software architecture found in this survey'),
  ('GAP.SA', 'South Asia / India', 'not searched', 'Indian software engineering traditions not surveyed; likely rich source of modular monolith patterns'),
  ('GAP.SEA', 'Southeast Asia', 'not searched', 'Vietnamese, Thai, Indonesian sources not surveyed'),
  ('GAP.AF', 'Africa', 'not surfaced', 'African software engineering principles not represented in this study'),
  ('GAP.NORDIC', 'Nordic / Scandinavia', 'not surfaced', 'Nordic software architecture traditions not surveyed (e.g., Ericsson, Nokia patterns)'),
  ('GAP.EMPIRICAL', 'Global', 'no sources', 'Empirical studies of module boundary violation rates by architecture type not found in this survey');
