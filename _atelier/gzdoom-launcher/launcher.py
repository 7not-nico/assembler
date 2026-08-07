#!/usr/bin/env python3
"""gzdoom launcher — thin entry; logic lives in deps/ purity rings."""

import sys

from deps.build import command, folder_label, parse_picks
from deps.launch import (
    binary,
    menu,
    menu_multi,
    run,
    scan,
    scan_map,
    scan_mods,
)
from schema import const

GAME = const.GAME
LEVEL = const.LEVEL
EXT = const.EXT
root = const.root
wad = const.wad
map = const.map
mod = const.mod
save = const.save

__all__ = [
    "EXT",
    "GAME",
    "LEVEL",
    "binary",
    "command",
    "folder_label",
    "map",
    "menu",
    "menu_multi",
    "mod",
    "parse_picks",
    "root",
    "run",
    "save",
    "scan",
    "scan_map",
    "scan_mods",
    "wad",
]

if __name__ == "__main__":
    save.mkdir(exist_ok=True)
    sys.exit(run(sys.argv[1:]))
