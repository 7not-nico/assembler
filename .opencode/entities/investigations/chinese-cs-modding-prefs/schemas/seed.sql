-- ==========================================
-- membrane: shared-substrate
-- registration:
--   file: seed.sql
--   title: Chinese CS Modding Preferences — Seed Data
--   membrane: shared-substrate
-- channel:
--   target: db.sql
-- ==========================================

INSERT INTO regions (id, name, language, notes) VALUES
('EA', 'Mainland China', 'zh-CN', 'MC modding dominates CS education; NetEase institutional backing'),
('TW', 'Taiwan', 'zh-TW', 'Structured coding games preferred over sandbox modding'),
('INT', 'International', 'en', 'English-language sources; confirm MC volume, miss CS framing');

INSERT INTO sources (id, region_id, title, institution, url, language, type, accessed_date) VALUES
('EA.001', 'EA', 'MC百科 (mcmod.cn)', 'Community', 'https://www.mcmod.cn', 'zh-CN', 'mod_wiki', '2026-07-20'),
('EA.002', 'EA', 'MCBBS 编程开发版', 'Community', 'https://www.mcbbs.co', 'zh-CN', 'forum', '2026-07-20'),
('EA.003', 'EA', '网易我的世界开发者官网', 'NetEase', 'https://mc.163.com/dev/', 'zh-CN', 'official_docs', '2026-07-20'),
('EA.004', 'EA', 'Bilibili ECNU水杉方块社 MC模组课程', 'ECNU', 'https://www.bilibili.com', 'zh-CN', 'video_course', '2026-07-20'),
('EA.005', 'EA', '知乎 Fabric模组开发教程系列', 'Zhihu', 'https://zhuanlan.zhihu.com', 'zh-CN', 'tutorial', '2026-07-20'),
('EA.006', 'EA', '知乎 异星工厂模组开发教程', 'Zhihu', 'https://zhuanlan.zhihu.com', 'zh-CN', 'tutorial', '2026-07-20'),
('EA.007', 'EA', 'Screeps 中文文档', 'Community', 'https://screeps-cn.github.io', 'zh-CN', 'docs', '2026-07-20'),
('TW.001', 'TW', '104學習 Screeps教學', '104.com', 'https://nabi.104.com.tw', 'zh-TW', 'educational_article', '2026-07-20'),
('TW.002', 'TW', 'AI4kids CodeCombat vs Minecraft 比較', 'AI4kids', 'https://ai4kids.ai', 'zh-TW', 'comparison_article', '2026-07-20'),
('TW.003', 'TW', 'learningisf.com 程式設計遊戲推薦', 'Personal', 'https://learningisf.com', 'zh-TW', 'blog', '2026-07-20'),
('TW.004', 'TW', 'Taiwan school CodeCombat site', 'NKHS', 'https://sites.google.com/gm.nkhs.tp.edu.tw', 'zh-TW', 'educational', '2026-07-20'),
('INT.001', 'INT', 'ACM Learning through game modding', 'ACM', 'https://dl.acm.org/doi/10.1145/1111293.1111301', 'en', 'academic_paper', '2026-07-20'),
('INT.002', 'INT', 'Factorio Wiki 简体中文', 'Wube', 'https://wiki.factorio.com/Modding', 'zh-CN, en', 'official_wiki', '2026-07-20'),
('INT.003', 'INT', 'CurseForge Chinese MC mods', 'CurseForge', 'https://www.curseforge.com/minecraft', 'en', 'mod_platform', '2026-07-20'),
('INT.004', 'INT', 'FTB Wiki Chinese mods category', 'Feed The Beast', 'https://ftb.fandom.com', 'en', 'wiki', '2026-07-20'),
('INT.005', 'INT', 'GitHub minecraft-mod topic', 'GitHub', 'https://github.com/topics/minecraft-mod', 'en', 'code_hosting', '2026-07-20');

INSERT INTO researchers (id, name, affiliation, region_id, expertise, contact) VALUES
('RES.001', 'Kim Jackson', 'Independent', 'EA', 'Minecraft Fabric mod development', 'zhihu.com'),
('RES.002', '小白鱼', 'Independent', 'EA', 'Minecraft modpack creation', 'mcmod.cn'),
('RES.003', 'ECNU水杉方块社', 'East China Normal University', 'EA', 'University-level MC modding education', 'bilibili.com'),
('RES.004', 'El-Nasr et al.', 'Penn State University', 'INT', 'Game modding for CS education', 'dl.acm.org'),
('RES.005', 'Turbodriver', 'Independent', 'INT', 'Game modding community analysis', 'gamersky.com'),
('RES.006', 'Tim Hsiao', 'Independent', 'TW', 'Programming game education', 'learningisf.com');

INSERT INTO meta_analyses (id, topic, method, finding, region_id, source_ids, confidence) VALUES
('MA.CHINESE.MC.DOMINANCE', 'MC modding as CS learning in Mainland China', 'xsearch zh-CN', 'Minecraft is #1 — institutional backing from NetEase, university courses at ECNU, largest mod wiki', 'EA', 'EA.001,EA.002,EA.003,EA.004,EA.005', 'high'),
('MA.TAIWAN.CODING.GAMES', 'Taiwan CS game preferences', 'xsearch zh-TW', 'CodeCombat and Screeps preferred; Minecraft scored low for CS learning', 'TW', 'TW.001,TW.002,TW.003,TW.004', 'high'),
('MA.INTL.CONFIRMATION', 'International sources on CN modding', 'xsearch en', 'Confirm MC modding volume in China but lack CS-education framing', 'INT', 'INT.001,INT.002,INT.003,INT.004', 'medium');

INSERT INTO gaps (id, description, severity, status, region_id, notes) VALUES
('GAP.CHINESE.MODDING.STUDY', 'No peer-reviewed study comparing CN vs TW CS modding preferences', 'high', 'native_surveys_absent', 'EA', 'Direct survey of CS students needed'),
('GAP.MC.CS.FRAMING', 'English sources lack CS-education framing for MC modding in China', 'medium', 'surfaced_disabled', 'INT', 'Western coverage treats MC modding as culture, not pedagogy'),
('GAP.TW.MODDING.DATA', 'Taiwan sources on modding-as-CS-learning are sparse', 'medium', 'sources_absent', 'TW', 'Few dedicated modding education sources in TW'),
('GAP.FACTORIO.CN.DEPTH', 'Factorio Chinese community size unquantified', 'low', 'searched_disabled', 'EA', 'Zhihu column exists but no population data');

INSERT INTO fundamentals (id, claim, evidence, confidence, region_id) VALUES
('FND.001', 'Mainland China prefers MC Java modding for CS learning', 'MC百科, Bilibili ECNU courses, NetEase developer portal, MCBBS programming section', 'high', 'EA'),
('FND.002', 'Taiwan prefers structured coding games over modding', 'AI4kids comparison, 104 Learning Screeps article, school CodeCombat adoption', 'high', 'TW'),
('FND.003', 'Java career relevance drives MC modding adoption in China', 'Bilibili MC tutorials emphasize Java skills for employability', 'medium', 'EA'),
('FND.004', 'NetEase provides institutional MC modding pipeline absent in West', 'mc.163.com developer program with Python SDK, monetization, QQ channels', 'high', 'EA'),
('FND.005', 'Screeps has cross-region appeal (CN + TW + INT)', 'Chinese docs, 104 Learning article, English storefront', 'high', 'EA,TW,INT');
