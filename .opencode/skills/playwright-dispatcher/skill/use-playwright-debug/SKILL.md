---
name: use-playwright-debug
description: Use this skill when debugging with Playwright MCP — it covers code execution, assertions, tracing, video recording, and PDF capture
state-profile: stateless
nexus: NEX.BROWSER.STACK
---

Availability — core tools always available. Assert/trace/video/PDF require capability flags.

## Tools

```
  Tool                              Availability                         Parameters            Notes
  `browser_run_code`                core (as `browser_run_code_unsafe`)  `code`                Execute async fn receiving `page` — full Playwright API
  `browser_evaluate`                core                                 `expression`, `ref?`  Evaluate JS on page or element
  `browser_console_messages`        core                                 `level?`              Get console output (error/warning/info/debug)
  `browser_console_clear`           core                                 —                     Clear console buffer
  `browser_generate_locator`        `--caps=assert`                      —                     Generate Playwright locator from element
  `browser_verify_element_visible`  `--caps=assert`                      `ref`                 Assert element visible
  `browser_verify_text_visible`     `--caps=assert`                      `text`                Assert text visible
  `browser_start_tracing`           `--caps=trace`                       —                     Start trace recording
  `browser_stop_tracing`            `--caps=trace`                       —                     Stop and save trace
  `browser_start_video`             `--caps=video`                       —                     Start video recording
  `browser_stop_video`              `--caps=video`                       —                     Stop and save video
  `browser_pdf_save`                `--caps=pdf`                         —                     Export current page as PDF to output dir
```

## Gotchas

- `browser_run_code` receives a `page` object — full Playwright API available
- `browser_evaluate` parameter is `function` in this MCP binding (`expression` excluded)
- Assert/trace/video/PDF tools return errors if server launched without capability flags
- Tracing and video for debugging only — production use excluded
- `browser_pdf_save` renders visible viewport; full-page content requires scrolling first
