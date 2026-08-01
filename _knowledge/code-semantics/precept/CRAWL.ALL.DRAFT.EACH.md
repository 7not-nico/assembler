# CRAWL.ALL.DRAFT.EACH — crawl every relevant section, draft one role at a time

Every relevant section of the language specification must be crawled via Playwright before any role file is written. Crawl all sections first, then draft each role file from the full crawl corpus.

Procedure:
1. Open the specification index (table of contents)
2. Identify all sections relevant to Subject, Object, and Action roles
3. Crawl each section in order via Playwright: navigate → snapshot → read
4. Accumulate findings across all sections
5. After every section is crawled, draft one role file at a time
6. Present the draft in conversation for approval
7. Write the role file only after approval
8. Repeat for the next role

No section is skipped. No role is drafted before all relevant sections are browsed. The full crawl corpus ensures no context is missed when assigning roles.

Composes with: CRAWL.SECTION.BY.SECTION, RESEARCH.BEFORE.WRITE, DRAFT.ONE.ROLE.AT.TIME
