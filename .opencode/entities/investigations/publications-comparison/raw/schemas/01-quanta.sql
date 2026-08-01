-- Quantum Magazine seed data

INSERT OR REPLACE INTO publications (id, name, founded, url, scope, business_model, funding_source, trajectory) VALUES
    ('quanta', 'Quantum Magazine', 2012, 'https://www.quantamagazine.org',
     'Mathematics, theoretical physics, theoretical computer science, basic life sciences',
     'Nonprofit — no paywall, no ads. Syndication partnerships with SciAm, Wired, Atlantic, WaPo',
     'Simons Foundation (single funder)',
     'rising');

INSERT OR REPLACE INTO publication_dimensions (publication_id, dimension_id, finding, rating) VALUES
    ('quanta', 'editorial_model',
     'Editorially independent from Simons Foundation. Staff-written by professional journalists. In-house fact-checking. E.i.C makes all editorial decisions; foundation has no review.',
     'strong'),
    ('quanta', 'subject_scope',
     'Narrow and deep: math, theoretical physics, theoretical CS, basic life sciences. Explicitly excludes applied science (health, medicine, engineering).',
     'strong'),
    ('quanta', 'business_model',
     'Fully funded by Simons Foundation ($5B+ endowment). No paywall, no ads. Syndicates content to major outlets. Quanta Books (FSG imprint).',
     'strong'),
    ('quanta', 'audience',
     'Intellectually curious general readers. YouTube 1M+ subs. Syndicated in 6+ languages. Medium traffic but highly engaged.',
     'moderate'),
    ('quanta', 'quality',
     'Pulitzer Prize 2022 (Explanatory Reporting). National Magazine Awards (General Excellence 2020, Best Single-Topic Issue 2024). 3 Webby Awards. MBFC: Pro-Science, VERY HIGH factual.',
     'strong'),
    ('quanta', 'funding',
     'Single funder (Simons Foundation). Concentrated risk — if foundation priorities shift, publication vulnerable. Strong editorial firewall documented.',
     'moderate'),
    ('quanta', 'trajectory',
     'Rising — consistent awards, ambitious series ("Unraveling of Space-Time"), expansion into books, growing YouTube presence.',
     'strong'),
    ('quanta', 'fact_checking',
     '"Meticulously reported, edited and fact-checked" per About page. AI Editorial Policy (2026) bans AI drafting. Zero failed fact-checks since founding. Staff-written model enables systematic verification.',
     'strong');

INSERT OR IGNORE INTO sources (publication_id, url, title, source_type, search_round, domain) VALUES
    ('quanta', 'https://www.quantamagazine.org/about', 'About Quanta Magazine', 'institutional', 'round-1', 'quantamagazine.org'),
    ('quanta', 'https://en.wikipedia.org/wiki/Quanta_Magazine', 'Quanta Magazine — Wikipedia', 'wiki', 'round-1', 'wikipedia.org'),
    ('quanta', 'https://www.simonsfoundation.org/2024/09/25/quanta-magazine-unravels-space-and-time-in-ambitious-new-series', 'Quanta Unravels Space and Time', 'institutional', 'round-1', 'simonsfoundation.org'),
    ('quanta', 'https://mediabiasfactcheck.com/quanta-magazine', 'Quanta Magazine — MBFC', 'commercial', 'round-A', 'mediabiasfactcheck.com'),
    ('quanta', 'https://www.quantamagazine.org/ai-editorial-policy', 'AI Editorial Policy', 'institutional', 'round-A', 'quantamagazine.org');
