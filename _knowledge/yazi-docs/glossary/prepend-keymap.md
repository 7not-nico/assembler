# prepend-keymap

prepend_keymap inserts keybindings before the default keymap in a Yazi keymap layer.

Higher priority than defaults — Yazi runs the first matching key. Each layer (`mgr`, `tasks`, etc.) supports `prepend_keymap` and `append_keymap` attributes. Used to override default binds without copying the whole preset file. Also available for open, icon, previewer, and preloader rules.
