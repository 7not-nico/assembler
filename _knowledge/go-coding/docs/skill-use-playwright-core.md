# use-playwright-core — Browser Automation

**Purpose** — standard cycle for dynamic page interaction.

## Procedure

```text
browser_navigate → browser_snapshot → interact via refs → re-snapshot
```

1. `browser_navigate` — target URL
2. `browser_snapshot` — capture accessibility tree with refs
3. Interact via refs — `browser_click`, `browser_type`, `browser_select_option`, etc.
4. Re-snapshot after each action for updated refs

## Core Tools

```text
Tool                       Purpose
browser_navigate           Navigate to URL
browser_snapshot           Capture accessibility tree with refs
browser_find               Search snapshot text (cheaper than full)
browser_click              Click element by ref
browser_type               Type text into editable element
browser_fill_form          Fill multiple form fields at once
browser_select_option      Select dropdown option
browser_take_screenshot    Visual capture (PNG/JPEG)
browser_tabs               List, create, close, switch tabs
browser_handle_dialog      Accept/dismiss alert/confirm/prompt
browser_evaluate           Execute JS on page or element
```

## Rules

- snapshot → find ref → interact: standard cycle
- Refs snapshot-scoped — re-snapshot after navigation or DOM updates
- Dialogs block interaction — handle before proceeding
- `browser_fill_form` preferred over individual `browser_type` for multi-field forms
- Slow `type` (`slowly: true`) triggers per-key handlers (autocomplete, etc.)
