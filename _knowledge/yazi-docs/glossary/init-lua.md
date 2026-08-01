# init.lua

init.lua is the Lua initialization file of Yazi — configures plugins, runs synchronously at startup.

Located at `~/.config/yazi/init.lua`. Synchronous context: `require("my-plugin"):setup {...}` configures plugins. Also hosts custom status/header widgets via `Status:children_add` / `Header:children_add`. Must contain valid Lua — parse errors block initialization.
