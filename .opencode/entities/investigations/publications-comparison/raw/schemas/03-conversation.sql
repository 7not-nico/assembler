-- The Conversation seed data

INSERT OR REPLACE INTO publications (id, name, founded, url, scope, business_model, funding_source, trajectory) VALUES
    ('conversation', 'The Conversation', 2011, 'https://theconversation.com',
     'All academic disciplines — policy, science, health, economics, education, history, ethics, arts',
     'Nonprofit. University membership fees + foundation grants + reader donations. CC-licensed free republishing. No paywall, no ads.',
     'Diversified: universities, foundations, readers',
     'stable');

INSERT OR REPLACE INTO publication_dimensions (publication_id, dimension_id, finding, rating) VALUES
    ('conversation', 'editorial_model',
     'UNIQUE: academics write, journalists edit. Authors must prove expertise + disclose funding. Editors commission and shape. CC-licensed — AP distributes daily. Professional journalists on editing staff.',
     'strong'),
    ('conversation', 'subject_scope',
     'Broadest disciplinary range — covers all academic fields. From astronomy to Zoroastrianism. Depth varies by author expertise.',
     'strong'),
    ('conversation', 'business_model',
     'Diversified nonprofit. University membership fees (core), foundation grants (Knight, Ford, Sloan, Moore), reader donations. 11 regional editions. INN member.',
     'strong'),
    ('conversation', 'audience',
     '28M monthly onsite views, 47M including republication. 88% non-academic readers. ~40% aged 18-34. Balanced gender split. Used in classrooms and policy circles.',
     'strong'),
    ('conversation', 'quality',
     'INN member. Known for reliability and trustworthiness. No major journalism awards (Pulitzer etc.) — model prioritizes accessibility over investigative depth. 96K+ academic authors, 188K+ articles.',
     'moderate'),
    ('conversation', 'funding',
     'Most diversified funding of all four. Universities + foundations + readers — no single point of failure. Resilient model.',
     'strong'),
    ('conversation', 'trajectory',
     'Stable — steady growth since 2011. Proven model replicated across 11 countries. Expanding into investigative journalism (Nieman Lab 2023).',
     'strong'),
    ('conversation', 'fact_checking',
     'Academic authors write from proven expertise. Professional editors review for accuracy. Disclosure of funding/affiliations required. Transparency charter. No dedicated fact-checking department — relies on academic sourcing model.',
     'moderate');

INSERT OR IGNORE INTO sources (publication_id, url, title, source_type, search_round, domain) VALUES
    ('conversation', 'https://theconversation.com/us/who-we-are', 'About The Conversation US', 'institutional', 'round-3', 'theconversation.com'),
    ('conversation', 'https://theconversation.com/us/partners', 'Partners and Funders', 'institutional', 'round-3', 'theconversation.com'),
    ('conversation', 'https://theconversation.com/us/charter', 'Editorial Charter', 'institutional', 'round-3', 'theconversation.com'),
    ('conversation', 'https://theconversation.com/uk/audience', 'UK Audience Page', 'institutional', 'round-3', 'theconversation.com'),
    ('conversation', 'https://www.cjr.org/the_profile/the-conversation-covid-19.php', 'CJR — The Conversation thrives during pandemic', 'academic', 'round-3', 'cjr.org'),
    ('conversation', 'https://www.niemanlab.org/2023/08/journalism-with-a-phd-the-conversation-is-pairing-up-academics-with-reporters-for-big-investigations', 'Nieman Lab — Journalism with a PhD', 'academic', 'round-3', 'niemanlab.org'),
    ('conversation', 'https://theconversation.com/global/corrections', 'Corrections — The Conversation', 'institutional', 'round-C', 'theconversation.com'),
    ('conversation', 'https://comingfrom.org/2021/10/25/why-the-conversation-is-transparent-about-its-editorial-process', 'Why The Conversation is transparent about editorial process', 'commercial', 'round-C', 'comingfrom.org');
