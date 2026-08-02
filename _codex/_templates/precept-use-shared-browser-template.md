---
id: TEMPLATE.PRECEPT.USE.SHARED.BROWSER
title: Use-Shared-Browser Precept Template — One Persistent Chromium
layer: precept/
purpose: "All browser work runs on one shared persistent Chromium on CDP."
naming: use-shared-browser.md
tags: [template, precept, browser, cdp]
status: active
---
# use-shared-browser.md

**Layer:** precept/
**Naming:** `use-shared-browser.md` — declarative action-domain, atomic, one rule per file.
**Composes with:** `procedure/{action}-{domain}.md` (pipeline steps).

## Rule

All browser work runs on one shared persistent Chromium on CDP port {port} (`_templates/shell/start-browser.sh`, original MCP profile).

## Scope

Session-level; every browse, fetch, and acquisition task.

## Order / Practice

1. The instance check runs `curl -s http://127.0.0.1:{port}/json/version`.
2. A down instance starts via `start-browser.sh` (idempotent, one instance per profile).
3. Scripts connect via `connectOverCDP`; fresh launches and profile copies stay excluded.
4. The headed instance stops before any headless use — the SingletonLock allows one instance per profile.
5. {site-specific wart: e.g. curl alone returns 403 on romsfun; the browser handles downloads.}

## Example

```bash
curl -s http://127.0.0.1:{port}/json/version || bash _templates/shell/start-browser.sh
bash {repo}-repo/scripts/{acquire}.sh "{asset}" {category}
```

## Instance

{date, project, outcome — the first acquisition run on the shared instance}
