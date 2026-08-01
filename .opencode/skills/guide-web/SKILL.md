---
name: guide-web
description: Use this skill when writing HTML/CSS or clientside JS — it provides modern web development best practices and should be executed first to avoid obsolete patterns
state-profile: hybrid
type: procedure
---
**Procedure**

**Step 1: Search Use Cases** — run with an action-oriented query using `bunx`:
```
bunx -y modern-web-guidance@latest search "<query>" --skill-version 2026_05_16-c5e78707
```
If results vague or empty, run `list` to browse all guides:
```
bunx -y modern-web-guidance@latest list
```

**Step 2: Retrieve Best Practices** — once you have a relevant `id`, retrieve the full guide:
```
bunx -y modern-web-guidance@latest retrieve "<id>"
```
Pass multiple IDs comma-separated.

**Step 3: Interpret Results** — adapt the framework-agnostic guide to your setup. Check browser support status:

- Baseline Widely available → use without fallbacks
- Baseline Newly Available → provide fallbacks per guide unless user specifies a custom policy
- Custom policies may override fallback requirements — look for browser support rules in AGENTS.md or conversation context

**Gotchas**

| Signal | Detection | Redirect |
|--------|-----------|----------|
| Search returns no matches or low similarity | Query too narrow or feature edge-case | Run `list` to browse all available guides |
| bunx fails to run | Network unavailable or bunx resolution error | Use `bunx --bun modern-web-guidance@latest` to force Bun runtime |
| Guide recommends polyfills | User targets modern browsers only | Check for custom browser support policy in AGENTS.md before implementing |
| Feature fits multiple categories | Response includes related categories | Retrieve the most specific match; cross-reference with related guides |

**Rules**

- Search first before implementing any web feature — this is mandatory per skill description
- Guides are framework-agnostic; adapt the pattern to your framework (React, Vue, Angular, vanilla)
- Do not hallucinate guides or ignore them — they represent the preferred local standard
- Trigger scope: HTML/CSS layout, UI components, scroll/motion, performance (CWV), system APIs, form handling
- Exclude: backend, CI/CD, Docker, CLI tooling, generic scripting

**Interpreting Browser Support**

Baseline Widely available features are safe without fallbacks. For Baseline Newly Available features, provide the fallback recommendations from the guide unless the user has defined a custom browser support policy. Custom policies take precedence — document in AGENTS.md if one is repeatedly used.
