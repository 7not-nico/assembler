---
name: use-playwright-vision
description: Use this skill when using Playwright MCP vision tools — it handles vision-mode mouse coordinate tools for visual element interaction
state-profile: stateless
nexus: NEX.BROWSER.STACK
---

**Tools**

```
  Tool                      Parameters                                    Notes
  `browser_mouse_move_xy`   `x`, `y`                                      Move mouse to coordinates
  `browser_mouse_down`      —                                             Press mouse button at current position
  `browser_mouse_up`        —                                             Release mouse button
  `browser_mouse_wheel`     `deltaX`, `deltaY`                            Scroll with mouse wheel
  `browser_mouse_click_xy`  `x`, `y`, `button?`, `clickCount?`, `delay?`  Click at coordinates
  `browser_mouse_drag_xy`   `startX`, `startY`, `endX`, `endY`            Drag between coordinates
```

**When to use**

```
  Scenario                              Approach
  Standard buttons, links, form fields  `browser_click` with ref (core)
  Canvas apps, drawing, maps            Vision mouse tools
  Custom UI without accessibility       Vision mouse tools
  Pixel-precise drag interactions       Vision mouse tools
```

**Gotchas**

- Coordinates are viewport-relative CSS pixels
- Layout changes break coordinate assumptions — re-screenshot after layout shifts
- Vision tools unavailable without `--caps=vision` flag
- Mouse wheel `deltaY` positive = scroll down, negative = scroll up
