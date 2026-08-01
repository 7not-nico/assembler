---
name: use-playwright-debug
description: Reference for Playwright MCP code execution, assertions, tracing, video, and PDF tools
state-profile: stateless
---

**Trigger** — complex browser automation, page diagnostics, trace recording, or PDF export

**Procedure**

- 1. `browser_console_messages { level: "error" }` to check for page errors
- 2. `browser_evaluate` for lightweight JS inspection
- 3. `browser_run_code` for complex logic (iframes, geolocation, custom waits)
- 4. `browser_pdf_save` for page-to-PDF export
- 5. Tracing/video for session recording before complex workflows

**Rules**

- `browser_run_code_unsafe`, `browser_evaluate`, `browser_console_messages` are core (always available)
- Assert/trace/video/PDF require `--caps=assert`, `--caps=trace`, `--caps=video`, or `--caps=pdf` respectively
- `browser_pdf_save` preferred over `page.pdf()` — saves to standard output directory

**Availability** — core tools always available. Assert/trace/video/PDF require capability flags.

**Tools**

| Tool | Availability | Parameters | Notes |
|------|-------------|-----------|-------|
| `browser_run_code` | core (as `browser_run_code_unsafe`) | `code` | Execute async fn receiving `page` — full Playwright API |
| `browser_evaluate` | core | `expression`, `ref?` | Evaluate JS on page or element |
| `browser_console_messages` | core | `level?` | Get console output (error/warning/info/debug) |
| `browser_console_clear` | core | — | Clear console buffer |
| `browser_generate_locator` | `--caps=assert` | — | Generate Playwright locator from element |
| `browser_verify_element_visible` | `--caps=assert` | `ref` | Assert element visible |
| `browser_verify_text_visible` | `--caps=assert` | `text` | Assert text visible |
| `browser_start_tracing` | `--caps=trace` | — | Start trace recording |
| `browser_stop_tracing` | `--caps=trace` | — | Stop and save trace |
| `browser_start_video` | `--caps=video` | — | Start video recording |
| `browser_stop_video` | `--caps=video` | — | Stop and save video |
| `browser_pdf_save` | `--caps=pdf` | — | Export current page as PDF to output dir |

**Gotchas**

- `browser_run_code` receives a `page` object — full Playwright API available
- `browser_evaluate` parameter is `function` in this MCP binding (`expression` excluded)
- Assert/trace/video/PDF tools return errors if server launched without capability flags
- Tracing and video for debugging only — production use excluded
- `browser_pdf_save` renders visible viewport; full-page content requires scrolling first
