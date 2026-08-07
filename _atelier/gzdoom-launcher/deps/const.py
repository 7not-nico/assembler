"""Constants — launcher paths, name tables, extensions. No I/O at import."""

from pathlib import Path

root = Path(__file__).resolve().parents[1]
wad = root / "wad"
map = root / "map"
mod = root / "mod"
save = root / "save"

GAME = {
    "doom.wad": "The Ultimate Doom",
    "doom2.wad": "Doom II: Hell on Earth",
    "tnt.wad": "Final Doom: TNT",
    "plutonia.wad": "Final Doom: Plutonia",
}

LEVEL = {
    "nerve.wad": "No Rest for the Living",
    "masterlevels.wad": "Master Levels",
    "sigil.wad": "Sigil",
    "sigil2.wad": "Sigil II",
    "iddm1.wad": "Doom I Deathmatch",
}

EXT = {".pk3", ".zip", ".rar"}

BINARY_DEFAULT = "/opt/gzdoom/gzdoom"
