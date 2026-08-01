-- Undark Magazine seed data

INSERT OR REPLACE INTO publications (id, name, founded, url, scope, business_model, funding_source, trajectory) VALUES
    ('undark', 'Undark Magazine', 2016, 'https://undark.org',
     'Intersection of science and society — investigative science journalism, policy, ethics, environment, health, technology',
     'Nonprofit. Primary funding from Knight Foundation via KSJ@MIT. Additional small gifts/grants. No paywall, free to republish.',
     'Knight Foundation through Knight Science Journalism @MIT',
     'stable');

INSERT OR REPLACE INTO publication_dimensions (publication_id, dimension_id, finding, rating) VALUES
    ('undark', 'editorial_model',
     'Published under Knight Science Journalism at MIT. Editorially independent — full firewall from funders. Founders: Deborah Blum (Pulitzer winner) + Tom Zeller Jr. (ex-NYT). Investigative, critical science journalism.',
     'strong'),
    ('undark', 'subject_scope',
     'Science/society intersection. Investigative: policy, ethics, environment, health, technology. "Light and shadow" approach — covers contentious and ethically fraught aspects of science.',
     'strong'),
    ('undark', 'business_model',
     'Nonprofit, INN member. Primary: Knight Foundation through KSJ@MIT. Small additional grants. Accepts reader donations via MIT. No paywall, free CC-licensed republishing.',
     'strong'),
    ('undark', 'audience',
     '"Millions of readers annually." Syndicated to Atlantic, SciAm, Smithsonian, Time, Newsweek, NPR, Quartz, Salon, Slate. English-only.',
     'moderate'),
    ('undark', 'quality',
     'George K. Polk Award 2018 (Environmental Reporting). Al Neuharth Innovation in Investigative Journalism Award 2019. Nat''l Magazine Award finalist 2022. Anthologized in Best American Science & Nature Writing.',
     'strong'),
    ('undark', 'funding',
     'Single primary funder (Knight Foundation through KSJ@MIT). MIT affiliation provides stability. Additional small grants diversify somewhat. INN membership standards apply.',
     'moderate'),
    ('undark', 'trajectory',
     'Stable — consistent since 2016. MIT/Knight backing provides institutional stability. No signs of expansion or contraction.',
     'stable'),
    ('undark', 'fact_checking',
     'Renowned for rigorous fact-checking per KSJ@MIT. Dedicated internal research team. Corrections policy with inline explanations. AI Policy: no AI drafts, strict prohibition. Full transparency pages (independence, funding).',
     'strong');

INSERT OR IGNORE INTO awards (publication_id, year, award_name, category, notes) VALUES
    ('undark', 2018, 'George K. Polk Award', 'Environmental Reporting', 'For "Breathtaking" — multinational exposé on global air pollution by Larry C. Price'),
    ('undark', 2019, 'Al Neuharth Innovation in Investigative Journalism Award', 'Investigative Journalism', 'Online News Association — also for "Breathtaking" series'),
    ('undark', 2022, 'National Magazine Award Finalist', 'Reporting', 'Nomination — Elliot Award'),
    ('undark', 2017, 'Online Journalism Award Finalist', 'Feature', 'For "Wear & Tear" series on leather tanning and textile industry impacts'),
    ('undark', 2018, 'Best American Science & Nature Writing', 'Anthology', 'Work anthologized in annual book series');

INSERT OR IGNORE INTO timeline_events (publication_id, year, event_type, description, source_url) VALUES
    ('undark', 2016, 'launch', 'Founded in Cambridge, MA by Deborah Blum and Tom Zeller Jr. under Knight Science Journalism at MIT', 'https://en.wikipedia.org/wiki/Undark_Magazine'),
    ('undark', 2017, 'milestone', 'Became finalist for Online Journalism Award (Feature category)', 'https://en.wikipedia.org/wiki/Undark_Magazine'),
    ('undark', 2018, 'award', 'Won George K. Polk Award for Environmental Reporting — "Breathtaking" series', 'https://en.wikipedia.org/wiki/Undark_Magazine'),
    ('undark', 2019, 'award', 'Won Al Neuharth Innovation in Investigative Journalism Award from ONA', 'https://en.wikipedia.org/wiki/Undark_Magazine'),
    ('undark', 2022, 'award', 'Named National Magazine Award finalist in Reporting category', 'https://en.wikipedia.org/wiki/Undark_Magazine'),
    ('undark', 2025, 'policy', 'Published AI Editorial Policy — no AI-generated or AI-edited text', 'https://undark.org/ai-policy');

INSERT OR IGNORE INTO sources (publication_id, url, title, source_type, search_round, domain) VALUES
    ('undark', 'https://undark.org/who-is-undark/', 'About Undark', 'institutional', 'round-5', 'undark.org'),
    ('undark', 'https://undark.org/editorial-independence/', 'Editorial Independence', 'institutional', 'round-5', 'undark.org'),
    ('undark', 'https://undark.org/funding-transparency/', 'Funding Transparency', 'institutional', 'round-5', 'undark.org'),
    ('undark', 'https://en.wikipedia.org/wiki/Undark_Magazine', 'Undark Magazine — Wikipedia', 'wiki', 'round-5', 'wikipedia.org'),
    ('undark', 'https://ksj.mit.edu/about/undark', 'KSJ@MIT — Undark', 'academic', 'round-5', 'ksj.mit.edu'),
    ('undark', 'https://ksj.mit.edu/about/', 'About KSJ@MIT', 'academic', 'round-5', 'ksj.mit.edu'),
    ('undark', 'https://undark.org/corrections-policy/', 'Corrections Policy', 'institutional', 'round-E', 'undark.org'),
    ('undark', 'https://undark.org/ai-policy', 'AI Policy', 'institutional', 'round-E', 'undark.org');
