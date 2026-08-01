---
id: ILL.PLAYWRIGHT.ROUTE
title: "Playwright Standard — Routing a PDF Download Through Canonical Skills"
source: PROT.MCP.SERVER
summary: "An agent needs to download a PDF from ACM DL. Instead of raw Playwright calls, it routes through SKL.USE.PLAYWRIGHT.CORE and SKL.USE.PLAYWRIGHT.NETWORK.STORAGE."
illustration: "An ACM DL PDF download routes through two canonical skills — SKL.USE.PLAYWRIGHT.CORE handles navigation and click; SKL.USE.PLAYWRIGHT.NETWORK.STORAGE captures the download response — instead of ad-hoc browser_run_code."
illustrates: [PRE.PLAYWRIGHT.STANDARD.ROUTE]
tags: walkthrough,playwright,skill,automation,download,canonical
related: [SKL.USE.PLAYWRIGHT.CORE, SKL.USE.PLAYWRIGHT.NETWORK.STORAGE]
---
## Context

`PRE.PLAYWRIGHT.STANDARD.ROUTE` requires all browser automation to route through four canonical skills. An agent needs to download a PDF from ACM DL — a multi-step task involving navigation, clicking a download button, and capturing the download event. The raw approach uses `browser_run_code` with ad-hoc Playwright script. The standard approach routes through `SKL.USE.PLAYWRIGHT.CORE` (navigation, click) and `SKL.USE.PLAYWRIGHT.NETWORK.STORAGE` (download capture).

## Walkthrough

### Step 1: Navigate via Core skill

Instead of `page.goto(url)` in raw code, the agent loads `SKL.USE.PLAYWRIGHT.CORE` and uses `browser_navigate`:

```
SKL.USE.PLAYWRIGHT.CORE
→ browser_navigate(url: "https://dl.acm.org/doi/10.1145/1234567")
```

The skill handles navigation, waits for DOM, and returns the page snapshot.

### Step 2: Find and click the download button via Core skill

The agent calls `browser_find` to locate the PDF download link, then `browser_click`:

```
SKL.USE.PLAYWRIGHT.CORE
→ browser_find(text: "Download PDF")
→ browser_click(target: "ref_23")
```

The Core skill wraps navigation and click with standard waiting and error handling.

### Step 3: Capture the download via Network/Storage skill

Download capture needs network monitoring — that is `SKL.USE.PLAYWRIGHT.NETWORK.STORAGE` territory:

```
SKL.USE.PLAYWRIGHT.NETWORK.STORAGE
→ browser_network_requests(static: false, filter: "\\.pdf")
→ browser_network_request(index: 1)
```

The Network/Storage skill captures the PDF response, verifies Content-Type, and saves the file.

### Step 4: Skill boundary enforced

The agent never calls `browser_run_code` with ad-hoc Playwright scripts. Every tool call maps to a canonical skill:

| Action | Skill | Tool |
|--------|-------|------|
| Navigate | Core | `browser_navigate` |
| Find PDF button | Core | `browser_find` |
| Click button | Core | `browser_click` |
| Capture download | Network/Storage | `browser_network_requests` |
| Read response | Network/Storage | `browser_network_request` |

### Step 5: Verify the skill was used

The agent checks the session log: no `browser_run_code` calls appear. All browser interactions routed through the two canonical skills.

## Key insight

The skill boundary prevents ad-hoc Playwright programming. Navigation and clicking belong to the Core skill; network capture belongs to the Network/Storage skill. The agent never writes raw Playwright code — it only dispatches MCP tool calls scoped by the skill. This eliminates unchecked `browser_run_code` and ensures every browser action follows the standard waiting, logging, and error handling each skill provides.

## See also

- `PRE.PLAYWRIGHT.STANDARD.ROUTE` — the maxim this illustrates
- `SKL.USE.PLAYWRIGHT.CORE` — navigation, snapshot, click, type
- `SKL.USE.PLAYWRIGHT.NETWORK.STORAGE` — network capture, cookies, auth
- `SKL.USE.PLAYWRIGHT.DEBUG` — assertions, tracing, PDF export
- `SKL.USE.PLAYWRIGHT.VISION` — pixel-coordinate mouse interaction
