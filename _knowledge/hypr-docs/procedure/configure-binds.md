# configure-binds.md

**Composes with:** precept/search-before-navigate.md, note/ch03-configuring.md

Configure keybindings in `hyprland.lua`. Lua API since 0.55.

## Plan binds

1. List desired actions: launch apps, workspace nav, window ops, layout control, media, screenshots
2. Assign mods — SUPER for window mgmt, ALT for mouse ops, plain keys for media
3. Reserve global keybinds for apps (OBS, Discord) — use `pass`/`send_shortcut`

## Write binds

4. Basic bind — dispatcher table:
   ```lua
   hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty"))
   ```
5. Window ops:
   ```lua
   hl.bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }))
   hl.bind("SUPER + P", hl.dsp.window.pseudo())
   hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
   hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })
   ```
6. Special workspace:
   ```lua
   hl.bind("SUPER + C", hl.dsp.window.move({ workspace = "special:magic" }))
   hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
   ```
7. Layout messages: `hl.bind("SUPER + A", hl.dsp.layout("togglesplit"))`
8. Conditional logic via function dispatcher:
   ```lua
   hl.bind("SUPER + X", function()
       hl.dispatch(hl.dsp.window.float({ action = "toggle" }))
   end)
   ```
9. Global keybind pass-through:
   ```lua
   hl.bind("SUPER + F10", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))
   ```

## Refine

10. Flags — `release` for hold-actions, `locked` for lockscreen, `long_press` variants:
    ```lua
    hl.bind("SUPER + XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { long_press = true })
    ```
11. Per-device binds — `device = { inclusive = true, list = {...} }`
12. Submaps for modal modes:
    ```lua
    hl.define_submap("resize", function()
        hl.bind("right", function()
            hl.dispatch(hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
            hl.dispatch(hl.dsp.submap("reset"))
        end)
    end)
    hl.bind("ALT + R", hl.dsp.submap("resize"))
    ```

## Verify

13. Save config — live reload
14. Test each bind; check conflicts: `hyprctl binds`
15. Waybar submap display: replace `sway/mode` → `hyprland/submap` (ch08)
