-- ch05-init.lua — practice plugin init
-- Source: yazi-rs.github.io/docs/plugins/overview (2026-07-31), 26.5.6

-- Configure plugins (sync context)
require("git"):setup { order = 1500 }
require("zoxide"):setup { update_db = true }
require("full-border"):setup()

-- Header: show user@host
Header:children_add(function()
    if ya.target_family() ~= "unix" then
        return ""
    end
    return ui.Span(ya.user_name() .. "@" .. ya.host_name() .. ":"):fg("blue")
end, 500, Header.LEFT)

-- Status: show symlink target
Status:children_add(function(self)
    local h = self._current.hovered
    if h and h.link_to then
        return " -> " .. tostring(h.link_to)
    else
        return ""
    end
end, 3300, Status.LEFT)
