---
id: ILL.AGENTIC.CONFIG
title: "Agentic MCP Configuration — Playwright and Chrome DevTools Setup"
source: PROT.MCP.SERVER
summary: "Concrete opencode.json configuration for two agentic MCP servers: Playwright MCP (automation) and Chrome DevTools MCP (debugging). Both share the same Chromium binary."
illustration: "Two agentic MCP servers configured in opencode.json — Playwright MCP for browser automation and Chrome DevTools MCP for debugging. Both point to the same --executable-path. Playwright handles navigation, click, fill, screenshots. Chrome DevTools handles performance traces, network inspection, console diagnostics, heap snapshots."
illustrates: [PROT.MCP.SERVER, NEX.BROWSER.DEBUG.STACK]
tags: walkthrough,mcp,configuration,browser,automation,debugging
related: [PROT.TOOL.RUNNER, PROT.MCP.SERVER, NEX.BROWSER.DEBUG.STACK]
---

## Context

The project needs browser interaction — automate page actions AND diagnose what the browser is doing. Two npm-published MCP servers provide this: Playwright MCP for automation, Chrome DevTools MCP for debugging. Both are agentic MCP servers (external system-controlling, exempt from read-only constraint). Both use the same Chromium binary installed by Playwright.

## Walkthrough

### Step 1: Install Chromium

Playwright MCP requires a Chromium binary. The Playwright MCP npm package manages its own Chromium — no manual install needed. The binary path resolves to:

```
/home/user/.cache/ms-playwright/chromium-1232/chrome-linux64/chrome
```

Both agentic servers share this binary via `--executable-path`.

### Step 2: Configure Playwright MCP — automation layer

Playwright MCP provides input automation (click, fill, hover, press_key), navigation (navigate, new_page, select_page), and screenshots.

```json
"playwright": {
  "type": "local",
  "command": [
    "bunx",
    "@playwright/mcp@latest",
    "--executable-path",
    "/home/user/.cache/ms-playwright/chromium-1232/chrome-linux64/chrome"
  ],
  "enabled": true
}
```

Key configuration:
- `bunx` invokes the npm package (per `PROT.TOOL.RUNNER`)
- `--executable-path` points to the shared Chromium binary
- No `-y` flag — `bunx` auto-installs without prompting

### Step 3: Configure Chrome DevTools MCP — debugging layer

Chrome DevTools MCP provides performance traces, network inspection, console diagnostics, heap snapshots, and Lighthouse audits.

```json
"chrome-devtools": {
  "type": "local",
  "command": [
    "bunx",
    "chrome-devtools-mcp@latest",
    "--executable-path",
    "/home/user/.cache/ms-playwright/chromium-1232/chrome-linux64/chrome"
  ],
  "enabled": true
}
```

Same configuration pattern — `bunx`, shared `--executable-path`. Both servers run as local processes managed by the opencode runtime.

### Step 4: Shared browser context

Both servers launch the same Chromium binary. They operate on separate browser instances unless configured otherwise. Playwright MCP drives the browser; Chrome DevTools MCP connects to a running instance for debugging.

### Step 5: Tool selection by task

| Task | Server | Tools |
|------|--------|-------|
| Navigate to a URL | Playwright | `browser_navigate` |
| Click a button | Playwright | `browser_click` |
| Fill a form | Playwright | `browser_fill`, `browser_fill_form` |
| Take a screenshot | Playwright | `browser_take_screenshot` |
| Record a performance trace | Chrome DevTools | `performance_start_trace`, `performance_stop_trace` |
| Analyze performance insights | Chrome DevTools | `performance_analyze_insight` |
| Inspect network requests | Chrome DevTools | `list_network_requests`, `get_network_request` |
| Read console messages | Chrome DevTools | `list_console_messages`, `get_console_message` |
| Run a Lighthouse audit | Chrome DevTools | `lighthouse_audit` |
| Capture a heap snapshot | Chrome DevTools | `take_heapsnapshot` |
| Inspect DOM and CSS | Chrome DevTools | `take_snapshot`, `evaluate_script` |

### Step 6: Stack order example

A common workflow: navigate to a page (Playwright), record a performance trace (Chrome DevTools), inspect network requests (Chrome DevTools), then take a screenshot (Playwright).

```
browser_navigate(url: "https://example.com")
  → performance_start_trace(reload: true, autoStop: true)
  → list_network_requests(static: false)
  → take_screenshot()
```

Automation drives; debugging diagnoses. The stack order rule from `NEX.BROWSER.DEBUG.STACK` keeps the sequence predictable.

## Key insight

Two agentic MCP servers for the same external system pair as complementary layers, not alternatives. Playwright automates what the user does; Chrome DevTools inspects what the browser does. They share the same runtime binary but serve distinct roles. The agent selects tools by task type — automation tools from Playwright, diagnostic tools from Chrome DevTools.

This separation prevents a single server from accumulating both driving and diagnostic tools, keeping each tool set coherent and each server's responsibility clear.

## See also

- `PROT.MCP.SERVER` — contract for external system-controlling MCP servers
- `PROT.MCP.SERVER` — contract for agentic MCP server configuration
- `NEX.BROWSER.DEBUG.STACK` — automation + debugging composition
- `PROT.TOOL.RUNNER` — bunx invocation convention
- `PAT.MCP.READONLY` — read-only constraint that agentic servers are exempt from
