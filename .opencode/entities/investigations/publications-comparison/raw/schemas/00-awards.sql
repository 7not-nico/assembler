-- Awards seed data

INSERT OR IGNORE INTO awards (publication_id, year, award_name, category, notes) VALUES
    -- Quantum Magazine
    ('quanta', 2022, 'Pulitzer Prize', 'Explanatory Reporting', 'For coverage of the James Webb Space Telescope and developments in cosmology'),
    ('quanta', 2020, 'National Magazine Award', 'General Excellence', 'Ellies — recognition of overall editorial quality'),
    ('quanta', 2024, 'National Magazine Award', 'Best Single-Topic Issue', 'For "The Unraveling of Space-Time" series'),
    ('quanta', 2022, 'Webby Award', 'People''s Voice — Science', 'Online video and editorial excellence'),
    ('quanta', 2023, 'Webby Award', 'People''s Voice — Science', 'Online video and editorial excellence'),
    ('quanta', 2024, 'Webby Award', 'People''s Voice — Science', 'Online video and editorial excellence'),

    -- National Geographic (historic — specific years not documented in research)
    ('natgeo', 1900, 'Multiple Pulitzer Prizes', 'Photography, Reporting', 'Historic gold standard — specific recent awards not found'),
    ('natgeo', 1990, 'National Magazine Award', 'Photography', 'Multiple Ellies historically for photography and reporting'),

    -- The Conversation
    ('conversation', 2020, 'INN Membership', 'Nonprofit Journalism', 'Institute for Nonprofit News member — not an award per se'),
    ('conversation', 2023, 'Nieman Lab Feature', 'Innovation in Journalism', 'Profiled for investigative journalism expansion'),

    -- Aeon
    ('aeon', 2018, 'AAP Media Professionals Award', 'Philosophy Communication', 'Awarded to editorial director Brigid Hains by Australasian Association of Philosophy'),
    ('aeon', 2020, 'Vimeo Staff Pick', 'Video — Short Documentary', 'Multiple Aeon Video exclusives selected as Staff Picks (Dramatic and Mild, American Renaissance, etc.)');
