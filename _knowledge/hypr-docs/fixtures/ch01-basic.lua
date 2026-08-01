-- ch01-basic.conf → hyprland.lua practice config
-- Source: wiki.hypr.land notes ch01-ch16 (2026-07-30), post-0.55 Lua
-- Practice fixture — not a complete production config.

-- General
hl.config({
    general = {
        border_size = 2,
        gaps_in = 5,
        gaps_out = 20,
        col.active_border = "0xffffffff",
        col.inactive_border = "0xff444444",
        layout = "dwindle",
    },
    decoration = {
        rounding = 10,
        dim_strength = 0.5,
    },
    misc = {
        disable_hyprland_logo = true,
    },
    input = {
        kb_options = "ctrl:nocaps",
    },
})

-- Monitor
hl.monitor({ output = "DP-1", mode = "1920x1080@144", position = "0x0", scale = 1 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 }) -- fallback

-- Dwindle
hl.config({
    dwindle = {
        preserve_split = false,
        smart_split = true,
        smart_resizing = true,
        default_split_ratio = 1.0,
    },
})

-- Window rules
hl.window_rule({ match = { class = "kitty" }, opacity = "1.0 override 0.5 override 0.8 override" })
hl.window_rule({ match = { class = "firefox" }, move = { "cursor_x - window_w * 0.5", "cursor_y - window_h * 0.5" } })

-- Workspace rules
hl.workspace_rule({ workspace = "name:coding", no_rounding = true, decorate = false, monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", on_created_empty = "[float] firefox" })
hl.workspace_rule({ workspace = "special:scratchpad", on_created_empty = "foot" })

-- Binds
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd("kitty"))
hl.bind("SUPER + Q", hl.dsp.exec_cmd("firefox"))
hl.bind("SUPER + SHIFT + Q", hl.dsp.exec_cmd("waybar"))
hl.bind("SUPER + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo())
hl.bind("SUPER + C", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind("SUPER + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind("SUPER + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))

-- Mouse binds
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("ALT + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Submap example
hl.define_submap("resize", function()
    hl.bind("right", function()
        hl.dispatch(hl.dsp.window.resize({ x = 10, y = 0, relative = true }))
        hl.dispatch(hl.dsp.submap("reset"))
    end)
end)
hl.bind("ALT + R", hl.dsp.submap("resize"))

-- Global keybind pass-through (OBS)
hl.bind("SUPER + F10", hl.dsp.pass({ window = "class:^(com\\.obsproject\\.Studio)$" }))

-- Autostart
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("nm-applet")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
