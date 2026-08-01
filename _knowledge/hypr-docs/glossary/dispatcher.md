# dispatcher.md

A dispatcher is a compositor action invoked by a keybind or runtime dispatch.

In Lua config, dispatchers are tables returned by `hl.dsp.*` constructors — they describe an action without invoking it. They feed into `hl.bind()` or `hl.dispatch()`. Table contents are not guaranteed stable.

Dispatcher categories: general (`exec_cmd`, `focus`, `layout`, `dpms`, `pass`), window (`move`, `swap`, `center`, `cycle_next`, `pin`, `set_prop`, `drag`, `resize`), group (`toggle`, `next`, `prev`, `lock`), workspace (`toggle_special`), submap.

`hyprctl dispatch` is shorthand for `eval 'hl.dispatch(...)'`.
