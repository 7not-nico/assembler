---
name: use-playwright-core
description: Use this skill when using Playwright MCP browser automation — it covers navigation, clicking, typing, screenshots, and tab management tools
state-profile: stateless
nexus: NEX.BROWSER.STACK
---

## Tools

```
  Tool                        Parameters                                      Notes
  `browser_navigate`          `url`                                           Navigate to URL
  `browser_navigate_back`     —                                               Go back in history
  `browser_navigate_forward`  —                                               Go forward in history
  `browser_reload`            —                                               Reload current page
  `browser_snapshot`          —                                               Capture accessibility tree with refs
  `browser_click`             `ref`, `doubleClick?`, `button?`, `modifiers?`  Click element by ref
  `browser_hover`             `ref`                                           Hover over element
  `browser_drag`              `startRef`, `endRef`                            Drag and drop between elements
  `browser_type`              `ref`, `text`, `submit?`, `slowly?`             Type into editable element
  `browser_fill_form`         `fields[]`                                      Fill multiple fields at once
  `browser_select_option`     `ref`, `values[]`                               Select dropdown option
  `browser_check`             `ref`                                           Check checkbox or radio
  `browser_uncheck`           `ref`                                           Uncheck checkbox or radio
  `browser_press_key`         `key`                                           Press key combination
  `browser_take_screenshot`   `type`, `scale`, `fullPage?`, `element?`        Capture PNG or JPEG
  `browser_tabs`              `action`, `url?`, `index?`                      List, create, close, switch tabs
  `browser_handle_dialog`     `accept`, `promptText?`                         Accept or dismiss alert/confirm/prompt
  `browser_file_upload`       `paths[]`                                       Upload files
  `browser_close`             —                                               Close browser
  `browser_resize`            `width`, `height`                               Resize window
  `browser_wait_for`          `time?`, `text?`, `textGone?`                   Wait for condition
```

## Gotchas

- Refs change after page navigation or DOM updates — always re-snapshot
- `browser_find` finds text in snapshot; refs valid only from `browser_snapshot`
- Dialogs auto-block interaction until handled
- `browser_fill_form` requires field types from snapshot (textbox, checkbox, combobox, etc.)
- Slow `type` (`slowly: true`) triggers per-key handlers like autocomplete
