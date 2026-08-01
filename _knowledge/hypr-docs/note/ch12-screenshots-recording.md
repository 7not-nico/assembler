# ch12-screenshots-recording.md

**Source:** wiki.hypr.land/Useful-Utilities/Screenshots-and-Recording/ (2026-07-29), Playwright snapshot

## Screenshot utilities

```
| Tool | Role |
|------|------|
| **grim** | simple Wayland screenshot tool (gitlab.freedesktop.org/emersion/grim) |
| **slurp** | area selection |
| **swappy** | annotations |
| Satty | modern annotation tool, swappy/Flameshot-inspired, near drop-in swappy replacement |
| Flameshot | built-in annotation UI; Wayland relies on portal for capture |
| HyprCapture | Hyprland-oriented screenshot+recording utility (integrated workflow) |
```

### Binds

```lua
-- area → swappy
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
-- area → clipboard (needs wl-clipboard)
hl.bind("SUPER + Print", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
-- full → satty (Ctrl-C copy, Ctrl-S saves to ~/Pictures/Screenshots/)
hl.bind("Print", hl.dsp.exec_cmd('grim - | satty -f - --copy-command wl-copy -o "~/Pictures/Screenshots/%Y%m%d_%H%M%S.png"'))
```

### WeChat screenshot forwarding

Hyprland catches keybind first → pass dispatcher forwards to WeChat:
```lua
hl.bind("ALT + A", hl.dsp.pass({class = "^(wechat)$"}))
```
`pass` sends press+release — no separate bindr needed. Check actual class with `hyprctl clients`.

## Recording utilities

```
| Tool | Notes |
|------|-------|
| **OBS Studio** | PipeWire + desktop portal; needs pipewire, wireplumber, xdg-desktop-portal-hyprland, qt6-wayland |
| **wf-recorder** | lightweight Wayland recorder (github.com/ammen99/wf-recorder) |
```

```sh
wf-recorder -f ~/Videos/recording.mp4                     # whole screen
wf-recorder -g "$(slurp)" -f ~/Videos/recording.mp4      # selected region
```

Capture tools blocked → see `Configuring/Advanced-and-Cool/Permissions`.

## Grounding

- research/ — pending capture (topic-source)
- reference/site-citations.md — pending citation extract
- Source: wiki.hypr.land/Useful-Utilities/Screenshots-and-Recording/ (2026-07-29), Playwright snapshot
