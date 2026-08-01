-- Aeon seed data

INSERT OR REPLACE INTO publications (id, name, founded, url, scope, business_model, funding_source, trajectory) VALUES
    ('aeon', 'Aeon', 2012, 'https://aeon.co',
     'Ideas, philosophy, culture, science, psychology, society, arts',
     'Nonprofit charity (Aus + US 501c3). Reader donations only. No paywall, no ads.',
     'Reader donations only (single source)',
     'stable');

INSERT OR REPLACE INTO publication_dimensions (publication_id, dimension_id, finding, rating) VALUES
    ('aeon', 'editorial_model',
     'Long-form essays (2,500-5,000 words) by academics, journalists, and expert practitioners. Accepts pitches monthly. Video documentaries (Aeon Video). Sister site Psyche (2020). Very small team (1-10 employees).',
     'strong'),
    ('aeon', 'subject_scope',
     'Ideas-first: philosophy, culture, science, psychology, society, arts. "Asks the biggest questions." Depth over breadth.',
     'moderate'),
    ('aeon', 'business_model',
     'Leanest operation. Nonprofit charity funded solely by reader donations. No institutional or foundation backing. No ads, no paywall.',
     'weak'),
    ('aeon', 'audience',
     'Niche, engaged readership. Rank #189 in News (SimilarWeb). 53% male, 47% female. Largest group 25-34. Medium traffic but high engagement.',
     'moderate'),
    ('aeon', 'quality',
     'MBFC: HIGH factual reporting, Left-Center bias. Zero failed fact-checks in 5+ years. Editor won AAP Media Professionals Award 2018. Vimeo Staff Picks for video. Respected for depth but niche.',
     'strong'),
    ('aeon', 'funding',
     'Most fragile model — fully donation-dependent. No institutional or foundation backing. Small team vulnerable to donation fluctuations.',
     'weak'),
    ('aeon', 'trajectory',
     'Stable but small. Consistent identity and quality. Sister site Psyche launched 2020. SophiaClub events 2022. Growing slowly.',
     'moderate'),
    ('aeon', 'fact_checking',
     'Exacting editorial process: 3-5 drafts, professional fact-checking and copyediting, ~3 months from draft to publication. No AI drafts. Writers vetted for expertise. MBFC: HIGH factual, clean record. No standalone corrections page.',
     'strong');

INSERT OR IGNORE INTO sources (publication_id, url, title, source_type, search_round, domain) VALUES
    ('aeon', 'https://en.wikipedia.org/wiki/Aeon_(magazine)', 'Aeon — Wikipedia', 'wiki', 'round-4', 'wikipedia.org'),
    ('aeon', 'https://aeon.co/', 'Aeon — a world of ideas', 'institutional', 'round-4', 'aeon.co'),
    ('aeon', 'https://mediabiasfactcheck.com/aeon', 'Aeon — MBFC', 'commercial', 'round-4', 'mediabiasfactcheck.com'),
    ('aeon', 'https://www.similarweb.com/website/aeon.co', 'aeon.co Traffic Analytics', 'commercial', 'round-4', 'similarweb.com'),
    ('aeon', 'https://aeon.co/pitch', 'Aeon Pitch Guidelines', 'institutional', 'round-4', 'aeon.co'),
    ('aeon', 'https://aeon.co/about', 'About Aeon', 'institutional', 'round-D', 'aeon.co'),
    ('aeon', 'https://aeon.co/contact', 'Contact Aeon', 'institutional', 'round-D', 'aeon.co');
