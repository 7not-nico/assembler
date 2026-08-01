-- ch15-layouts.conf → layout practice fixture
-- Source: wiki.hypr.land/Configuring/Layouts (2026-07-30), post-0.55 Lua

-- Master layout with center orientation
hl.config({
    master = {
        mfact = 0.6,
        new_status = "slave",
        orientation = "center",
        slave_count_for_center_master = 2,
        drop_at_cursor = true,
    },
})

-- Per-workspace layouts via workspace rules
hl.workspace_rule({ workspace = "2", layout = "scrolling" })
hl.workspace_rule({ workspace = "3", layout = "master" })
hl.workspace_rule({ workspace = "4", layout = "monocle" })
hl.workspace_rule({ workspace = "5", layout_opts = { orientation = "top" } })

-- Scrolling layout tuning
hl.config({
    scrolling = {
        direction = "right",
        follow_focus = true,
        follow_min_visible = 0.4,
        fullscreen_on_one_column = true,
    },
})

-- Scrolling window rule: starting column width
hl.window_rule({ name = "kitty_starting_width", match = { class = "kitty" }, scrolling_width = 0.5 })

-- Master layout messages
hl.bind("SUPER + M", hl.dsp.layout("swapwithmaster master"))
hl.bind("SUPER + N", hl.dsp.layout("cyclenext loop"))
hl.bind("SUPER + B", hl.dsp.layout("focusmaster auto"))

-- Scrolling layout messages
hl.bind("SUPER + period", hl.dsp.layout("move +col"))
hl.bind("SUPER + comma", hl.dsp.layout("swapcol l"))
hl.bind("SUPER + grave", hl.dsp.layout("fit expand"))

-- Monocle cycling (cycle_next does not work on monocle)
hl.bind("SUPER + TAB", hl.dsp.layout("cyclenext"))

-- Dwindle layout messages
hl.bind("SUPER + A", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + S", hl.dsp.layout("splitratio +0.1"))
hl.bind("SUPER + SHIFT + S", hl.dsp.layout("splitratio -0.1"))
