# ch07-plugins.md

**Source:** wiki.hypr.land/Plugins/Using-Plugins/ (2026-07-29), Playwright snapshot

## Nature

- Plugins are **C++ shared objects** (`.so`), run as part of Hyprland — full trust required
- No default plugins — user finds own
- Written in C++, run inside compositor process — **read source, trust source**; never trust random `.so`

## hyprpm (plugin manager — recommended)

### Permission note

With permission management enabled, allow hyprpm plugin loading in config:
```lua
hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")
```
Otherwise permission popup on every load.

### Dependencies

`cpio`, `cmake`, `git`, `meson`, `gcc` (+ `-dev` packages of Hyprland deps on Fedora/Debian).

### Workflow

```sh
hyprpm add https://github.com/hyprwm/hyprland-plugins   # add repo
hyprpm list                                              # list installed
hyprpm enable name / hyprpm disable name                 # toggle
hyprpm reload                                            # load into Hyprland
hyprpm update                                            # update plugins
hyprpm -h                                                # all options
```

- `hyprpm reload` in autostart → plugins at startup; `-n` flag for load notification
- reload generates notifications for warning/error events regardless

## Manual

- Different build methods per plugin
- No headers: clone Hyprland, checkout version, build, `sudo make installheaders`, then build plugin
- Load/unload via hyprctl:
  ```sh
  hyprctl plugin load path    # absolute path required!
  hyprctl plugin unload path
  hyprctl plugin list         # list loaded
  ```

## Config usage (Lua)

```lua
function M.setup_vkfix()
    if hl.plugin.csgo_vulkan_fix ~= nil then
        hl.plugin.csgo_vulkan_fix.vkfix_app({ app = "cs2", w = 2304, h = 1440 })
        hl.config({
            plugin = {
                csgo_vulkan_fix = { fix_mouse = false }
            }
        })
    end
end
```
`if hl.plugin.X ~= nil` guards against plugin not yet loaded.

## FAQ

- Crash → plugin broken → `hyprpm disable`
- List loaded: `hyprctl plugin list`
- Find: hypr.land/plugins (featured), awesome-hyprland#plugins, github "hyprland plugin" keyword
- Safety: safe if source read
- Stability: crash-unload tactics exist, not always effective; well-designed plugins don't affect stability

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Plugins/Using-Plugins/ (2026-07-29), Playwright snapshot
