-- Timeline events seed data

INSERT OR IGNORE INTO timeline_events (publication_id, year, event_type, description, source_url) VALUES

    -- Quantum Magazine
    ('quanta', 2012, 'launch', 'Launched as Simons Science News by Thomas Lin (ex-NYT) and Simons Foundation', 'https://en.wikipedia.org/wiki/Quanta_Magazine'),
    ('quanta', 2013, 'rename', 'Renamed from Simons Science News to Quanta Magazine', 'https://en.wikipedia.org/wiki/Quanta_Magazine'),
    ('quanta', 2022, 'award', 'Won Pulitzer Prize in Explanatory Reporting', 'https://www.quantamagazine.org/about'),
    ('quanta', 2024, 'leadership', 'Thomas Lin stepped down as E.i.C; Samir Patel became second editor-in-chief', 'https://en.wikipedia.org/wiki/Quanta_Magazine'),
    ('quanta', 2026, 'policy', 'Published AI Editorial Policy — no AI drafting, full disclosure required', 'https://www.quantamagazine.org/ai-editorial-policy'),

    -- National Geographic
    ('natgeo', 1888, 'launch', 'National Geographic Society founded by 33 members including Alexander Graham Bell; first issue published', 'https://en.wikipedia.org/wiki/National_Geographic_Society'),
    ('natgeo', 1910, 'milestone', 'Iconic yellow border introduced on magazine cover', 'https://en.wikipedia.org/wiki/National_Geographic_Society'),
    ('natgeo', 2015, 'ownership_change', 'Media assets sold to 21st Century Fox for $725M; NatGeo Partners formed (Fox 73%, Society 27%)', 'https://en.wikipedia.org/wiki/National_Geographic_Partners'),
    ('natgeo', 2019, 'ownership_change', 'Disney acquires 21st Century Fox, inherits 73% stake in NatGeo Partners', 'https://en.wikipedia.org/wiki/National_Geographic_Partners'),
    ('natgeo', 2022, 'reorganization', 'Six top editors laid off in editorial reorganization', 'https://www.newslaundry.com/2023/06/29/national-geographic-lays-off-all-staff-writers-will-no-longer-sell-at-newsstands'),
    ('natgeo', 2023, 'layoff', 'All 19 staff writers laid off; newsstand sales ended; work outsourced to freelancers', 'https://www.washingtonpost.com/media/2023/06/28/national-geographic-staff-writers-laid-off'),

    -- The Conversation
    ('conversation', 2011, 'launch', 'Founded in Australia by Andrew Jaspan (ex-newspaper editor) and Jack Rejtman', 'https://theconversation.com/us/who-we-are'),
    ('conversation', 2014, 'expansion', 'US edition launched with newsroom in Boston', 'https://theconversation.com/us/who-we-are'),
    ('conversation', 2019, 'expansion', 'Global network expanded to 11 regional editions', 'https://theconversation.com/us/who-we-are'),
    ('conversation', 2020, 'growth', 'Audience surged during COVID pandemic — became trusted source for science communication', 'https://www.cjr.org/the_profile/the-conversation-covid-19.php'),
    ('conversation', 2023, 'expansion', 'Expanded into investigative journalism — pairing academics with reporters for long-form investigations', 'https://www.niemanlab.org/2023/08/journalism-with-a-phd-the-conversation-is-pairing-up-academics-with-reporters-for-big-investigations'),

    -- Aeon
    ('aeon', 2012, 'launch', 'Launched in London by Paul and Brigid Hains (Australian couple)', 'https://en.wikipedia.org/wiki/Aeon_(magazine)'),
    ('aeon', 2016, 'milestone', 'Registered as charity with Australian Charities and Not-For-Profits Commission', 'https://en.wikipedia.org/wiki/Aeon_(magazine)'),
    ('aeon', 2020, 'expansion', 'Registered Aeon America as 501(c)(3) in the US', 'https://en.wikipedia.org/wiki/Aeon_(magazine)'),
    ('aeon', 2020, 'launch', 'Launched Psyche — sister magazine focused on psychology and human experience', 'https://en.wikipedia.org/wiki/Aeon_(magazine)'),
    ('aeon', 2022, 'launch', 'Launched SophiaClub — program of cultural events in London, New York, Melbourne', 'https://en.wikipedia.org/wiki/Aeon_(magazine)');
