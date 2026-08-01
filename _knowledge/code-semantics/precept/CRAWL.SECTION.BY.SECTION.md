# CRAWL.SECTION.BY.SECTION — crawl standard sections in order

When researching a language specification, navigate sections sequentially rather than jumping to isolated clauses.

Procedure:
1. Start from the standard's table of contents (index page)
2. Open each relevant section in order via Playwright
3. Read and snapshot each section before advancing to the next
4. Present the cumulative findings in conversation
5. Only after the full section chain is browsed, write the analysis

Section order follows the standard's own numbering. For C: §5 Execution model → §6.3.2.1 Lvalues → §6.5 Expressions → §6.8 Statements. Skipping sections risks missing context that defines how roles relate.

Composes with: BROWSE.AFTER.SEARCH, PASS.URL.TO.PLAYWRIGHT, RESEARCH.BEFORE.WRITE
