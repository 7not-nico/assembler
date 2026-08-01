---
name: use-playwright-core
description: Reference for all core Playwright MCP browser automation tools
state-profile: stateless
---

**Trigger** — browser navigation, interaction, form filling, screenshot, or tab management task

**Procedure**

- 1. `browser_navigate` to target URL
- 2. `browser_snapshot` to capture accessibility tree with refs
- 3. Interact via refs — `browser_click`, `browser_type`, `browser_select_option`, etc.
- 4. Re-snapshot after each action for updated refs

**Rules**

- snapshot → find ref → interact — the standard cycle
- Refs are snapshot-scoped; re-snapshot after navigation or DOM updates
- Dialogs block interaction — `browser_handle_dialog` before proceeding
- `browser_fill_form` preferred over individual `browser_type` calls for multi-field forms
- `browser_tabs { action: "new", url }` opens new tab; `browser_tabs { action: "select", index }` switches

**Tools**

| Tool | Parameters | Notes |
|------|-----------|-------|
| `browser_navigate` | `url` | Navigate to URL |
| `browser_navigate_back` | — | Go back in history |
| `browser_navigate_forward` | — | Go forward in history |
| `browser_reload` | — | Reload current page |
| `browser_snapshot` | — | Capture accessibility tree with refs |
| `browser_click` | `ref`, `doubleClick?`, `button?`, `modifiers?` | Click element by ref |
| `browser_hover` | `ref` | Hover over element |
| `browser_drag` | `startRef`, `endRef` | Drag and drop between elements |
| `browser_type` | `ref`, `text`, `submit?`, `slowly?` | Type into editable element |
| `browser_fill_form` | `fields[]` | Fill multiple fields at once |
| `browser_select_option` | `ref`, `values[]` | Select dropdown option |
| `browser_check` | `ref` | Check checkbox or radio |
| `browser_uncheck` | `ref` | Uncheck checkbox or radio |
| `browser_press_key` | `key` | Press key combination |
| `browser_take_screenshot` | `type`, `scale`, `fullPage?`, `element?` | Capture PNG or JPEG |
| `browser_tabs` | `action`, `url?`, `index?` | List, create, close, switch tabs |
| `browser_handle_dialog` | `accept`, `promptText?` | Accept or dismiss alert/confirm/prompt |
| `browser_file_upload` | `paths[]` | Upload files |
| `browser_close` | — | Close browser |
| `browser_resize` | `width`, `height` | Resize window |
| `browser_wait_for` | `time?`, `text?`, `textGone?` | Wait for condition |

**Gotchas**

- Refs change after page navigation or DOM updates — always re-snapshot
- `browser_find` finds text in snapshot; refs valid only from `browser_snapshot`
- Dialogs auto-block interaction until handled
- `browser_fill_form` requires field types from snapshot (textbox, checkbox, combobox, etc.)
- Slow `type` (`slowly: true`) triggers per-key handlers like autocomplete
