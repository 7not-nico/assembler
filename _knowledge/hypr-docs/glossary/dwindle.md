# dwindle.md

Dwindle is the default tiling layout of Hyprland — a BSPWM-like binary tree layout.

Every window on a workspace is a member of a binary tree. Splits are dynamic: determined by the W/H ratio of the parent node (W > H → side-by-side, H > W → top-and-bottom). `preserve_split` makes them permanent.

Key options (`hl.config({ dwindle = {...} })`): `force_split`, `smart_split` (cursor triangle decides direction), `smart_resizing`, `default_split_ratio` (1.0 = 50/50), `split_bias`, `use_active_for_splits`, `split_width_multiplier`, `special_scale_factor`.

Layout messages: `splitratio`, `togglesplit`, `swapsplit`, `rotatesplit`, `preselect`, `movetoroot`.
