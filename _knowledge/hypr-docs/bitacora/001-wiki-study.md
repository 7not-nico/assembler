# 001-wiki-study.md

**Date:** 2026-07-30
**Source:** wiki.hypr.land, hypr.land — official Hyprland docs

## Objective

Study Hyprland documentation into a knowledge-chain project at `_knowledge/hypr-docs/`.

## Session walkthrough

1. **Scaffold** — created knowledge-chain structure: `AGENTS.md`, `precept/ procedure/ note/ bitacora/ glossary/ reference/ fixtures/`, `docs/` (16 flattened skill markdown files from `.opencode/skills/`)
2. **Precepts** — wrote 3 governing rules: `prefer-official-reference.md` (official wiki first), `cite-versioned-wiki.md` (version-aware citation — 0.55 Lua migration), `search-before-navigate.md` (search before browser jumps; known-URL exception)
3. **Foundations** — patlib semantic search confirmed no existing Hyprland entities (new domain); web research located official sources
4. **Homepage** (ch01) — hypr.land: dynamic tiling Wayland compositor, C++, aquamarine backend, 0.55 hyprlang→Lua migration
5. **Wiki map** (ch02) — nav tree captured; 6 study anchors (Configuring, IPC, Ecosystem, Plugins, Utilities, Nix)
6. **Configuring** (ch03-04) — Lua config model (`hl.*` API), binds/dispatchers, variables, monitors, window/layer/workspace rules — via parallel-search fetches
7. **IPC** (ch05) — sockets + hyprctl; found hyprctl page URL moved to `Advanced-and-Cool/Using-hyprctl/` (404 → search recovery)
8. **Ecosystem + Plugins** (ch06-07) — via Playwright navigation + snapshots (browser automation per compose-web)
9. **Utilities** (ch08-13) — status bars, launchers, must-have, wallpapers, screenshots/recording, clipboard managers — Playwright snapshots
10. **Autostart + Layouts** (ch14-15) — `hl.on("hyprland.start")`, Dwindle/Master/Scrolling/Monocle
11. **Systemd** (ch16) — UWSM, hyprland-session.target, autostart units
12. **Glossary** (10 terms) — hyprlang, dispatcher, workspace, special-workspace, submap, dwindle, mfact, window-rule, his
13. **Reference** — `conventions.md` Lua API surface compiled from notes
14. **Fixtures** — `ch01-basic.lua` + `ch15-layouts.lua` practice configs

## Method notes

- compose-web: parallel-search first (excerpts often sufficient), Playwright for dynamic pages, direct fetch for known canonical URLs
- Hyprland wiki is versioned (latest git default) — cited version in every note
- 0.55 migration (hyprlang → Lua) — all notes post-0.55; old syntax at `wiki.hypr.land/0.54.0/`

## Outcomes

16 notes, 3 precepts, 10 glossary terms, 1 reference, 2 fixtures. Chain complete: precept → procedure → note → bitacora → glossary → reference → fixtures.
