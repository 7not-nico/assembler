**Playwright** — open-source browser automation framework by Microsoft. Drives Chromium, Firefox, and WebKit through a single API for end-to-end testing, web scraping, and AI-agent browser control.

Playwright eliminates flaky tests through auto-waiting actions and web-first assertions — elements are checked for visibility, stability, and enabled state before interaction. Browser contexts provide isolated sessions with near-zero overhead, enabling parallel test execution. Network interception supports API mocking and request modification without external tools.

Playwright enables multi-tab, multi-origin, and multi-user scenarios in a single run. Supports TypeScript, JavaScript, Python, Java, and .NET across Linux, macOS, and Windows. Built-in tooling includes codegen (record-and-replay), trace viewer (time-travel debugging), and visual regression via screenshot comparison.

Playwright MCP (Model Context Protocol) server exposes browser automation as MCP tools — AI agents control browsers through structured accessibility tree snapshots rather than vision models, reducing token usage ~4x versus screenshot-based approaches.

---
id: TERM.PLAYWRIGHT
title: Playwright
source: CON.FS.WATCH
tags: [browser-automation,testing-framework,mcp,playwright,web-testing]
related: []
reference:
  - title: Playwright Documentation — Reliable End-to-End Testing for Modern Web Apps
    url: https://playwright.dev/docs/intro
  - title: "Framework Matters: Energy Efficiency of UI Automation Testing Frameworks (SAC '26)"
    url: https://dl.acm.org/doi/10.1145/3748522.3779954
  - title: "Test automation with selenium: A survey (IST '26)"
    url: https://dl.acm.org/doi/10.1016/j.infsof.2026.108077
  - title: Playwright MCP Server — Browser Automation for AI Agents
    url: https://github.com/microsoft/playwright-mcp
  - title: Microsoft Playwright — Cross-Browser Web Automation Framework
    url: https://github.com/microsoft/playwright
---
