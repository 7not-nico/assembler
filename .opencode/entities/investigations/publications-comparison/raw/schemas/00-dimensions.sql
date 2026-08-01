-- Shared dimensions seed data

INSERT OR IGNORE INTO dimensions (id, name, description) VALUES
    ('editorial_model',  'Editorial Model',     'How content is commissioned, written, edited, and verified'),
    ('subject_scope',    'Subject Scope',       'Topics and disciplines covered'),
    ('business_model',   'Business Model',      'Revenue sources, ownership structure, paywall/ad policy'),
    ('audience',         'Audience & Reach',    'Readership size, demographics, geographic distribution'),
    ('quality',          'Quality & Reputation', 'Awards, independent ratings, industry recognition'),
    ('funding',          'Funding Source',       'Who provides financial support and associated risks'),
    ('trajectory',       'Editorial Trajectory', 'Trend direction — rising, declining, or stable'),
    ('fact_checking',    'Fact-Checking Process','Editorial verification procedures and transparency policies');
