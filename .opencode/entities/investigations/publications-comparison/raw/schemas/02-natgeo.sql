-- National Geographic seed data

INSERT OR REPLACE INTO publications (id, name, founded, url, scope, business_model, funding_source, trajectory) VALUES
    ('natgeo', 'National Geographic', 1888, 'https://www.nationalgeographic.com',
     'Geography, archaeology, natural science, world history, culture, exploration, conservation',
     'For-profit since 2015. Disney 73% / NatGeo Society 27%. Ads + subscriptions. 40 language editions.',
     'Walt Disney Company (controlling)',
     'declining');

INSERT OR REPLACE INTO publication_dimensions (publication_id, dimension_id, finding, rating) VALUES
    ('natgeo', 'editorial_model',
     'PRE-2015: Nonprofit, staff-written, rigorous. POST-2015: For-profit under Fox/Disney. 2023: all 19 staff writers laid off, freelance-driven, newsstand sales ended. Audio department eliminated.',
     'degraded'),
    ('natgeo', 'subject_scope',
     'Broadest scope of all four: geography, science, history, culture, exploration, conservation, photography. Covers natural and human worlds.',
     'strong'),
    ('natgeo', 'business_model',
     'For-profit JV: Disney 73%, NatGeo Society 27%. Ad-supported + subscriptions. Print circ 1.8M (down from 12M peak). TV channels + digital platforms.',
     'moderate'),
    ('natgeo', 'audience',
     'Mass-market reach. ~60M global readers, 40 language editions. Median reader affluent (HHI $100K+). Rapidly declining print circulation.',
     'strong'),
    ('natgeo', 'quality',
     'Historic gold standard — pioneer of photojournalism. Multiple Pulitzers historically but none in recent years. 2023 layoffs raised serious quality concerns.',
     'moderate'),
    ('natgeo', 'funding',
     'Disney-controlled for-profit. Corporate parent with competing priorities. Multiple rounds of cost-cutting. Long-term sustainability of print uncertain.',
     'weak'),
    ('natgeo', 'trajectory',
     'Declining — circulation down 85% from peak. All editorial staff eliminated. Brand still trusted but institutionally diminished.',
     'weak'),
    ('natgeo', 'fact_checking',
     'HISTORIC: Industry gold standard — 2-year lead times, story teams, expert vetting, dedicated researchers, multi-round editing. CURRENT: Post-2023 layoffs, freelance-driven. No public fact-checking policy for current era. Minimal corrections page (just email).',
     'degraded');

INSERT OR IGNORE INTO sources (publication_id, url, title, source_type, search_round, domain) VALUES
    ('natgeo', 'https://en.wikipedia.org/wiki/National_Geographic_Society', 'National Geographic Society — Wikipedia', 'wiki', 'round-2', 'wikipedia.org'),
    ('natgeo', 'https://en.wikipedia.org/wiki/National_Geographic_Partners', 'National Geographic Partners — Wikipedia', 'wiki', 'round-2', 'wikipedia.org'),
    ('natgeo', 'https://www.washingtonpost.com/media/2023/06/28/national-geographic-staff-writers-laid-off', 'NatGeo lays off last staff writers — WaPo', 'commercial', 'round-2', 'washingtonpost.com'),
    ('natgeo', 'https://www.nytimes.com/2023/06/29/business/media/national-geographic-layoffs.html', 'NatGeo lays off more writers — NYT', 'commercial', 'round-2', 'nytimes.com'),
    ('natgeo', 'https://www.nationalgeographic.com/pages/article/corrections', 'Corrections and Clarifications', 'institutional', 'round-B', 'nationalgeographic.com'),
    ('natgeo', 'https://innovation.media/insights/learning-from-national-geographics-editorial-process', 'Learning from NatGeo Editorial Process', 'commercial', 'round-B', 'innovation.media');
