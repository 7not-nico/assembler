# research-wiki.md

**Composes with:** precept/prefer-official-reference.md, precept/cite-versioned-wiki.md, precept/search-before-navigate.md

Study a Hyprland wiki section into a chain note. Canonical procedure for extending the knowledge project.

## Prepare

1. Identify target section from wiki nav tree (note/ch02-wiki-structure.md anchors)
2. Search first: `parallel-search_web_search` 2-3 queries — locate canonical page
3. Read excerpts — answer directly if sufficient
4. Known canonical URL → direct `web_fetch` (search precept exception)

## Capture

5. Fetch page content:
   - Static content → `parallel-search_web_fetch` with objective
   - Dynamic/JS pages → Playwright navigate + snapshot (`browser_snapshot` article)
6. Note version: wiki defaults to latest git; check version selector for tagged release
7. Cross-ref ArchWiki/NixOS wiki for distro specifics only (official first)

## Write

8. Draft note `note/ch{NN}-{topic}.md` with source header:
   `**Source:** URL (date), version`
9. Extract tables and code blocks verbatim — config examples are authoritative
10. Post-0.55: translate any hyprlang examples to Lua (`hl.*` API) — flag old syntax to `wiki.hypr.land/0.54.0/`

## Integrate

11. Add new terms to `glossary/` — atomic definitions, one per file
12. Update `reference/conventions.md` — new API surface entries
13. Add fixture examples to `fixtures/` — practice configs governed by conventions
14. Record walkthrough in `bitacora/` — numbered, name describes work

## Verify

15. Check chain completeness: precept → procedure → note → bitacora → glossary → reference → fixtures
16. Confirm citations carry version + date
