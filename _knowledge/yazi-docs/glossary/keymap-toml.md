# keymap.toml

keymap.toml is the keybinding configuration file of Yazi — 8 layers of keymaps.

Layers: `[[mgr]]`, `[[tasks]]`, `[[spot]]`, `[[pick]]`, `[[input]]`, `[[confirm]]`, `[[cmp]]`, `[[help]]`. Each has `prepend_keymap` (higher priority than default) and `append_keymap` (lower priority). Yazi runs the first matching key. Key notation: `<C-a>` Ctrl, `["g", "b"]` sequences, per-OS binds.
