#!/usr/bin/env python3
"""gzdoom launcher — picks an IWAD from wad/, maps from map/, mods from mod/, starts gzdoom."""

import shutil
import subprocess
import sys
from pathlib import Path

root = Path(__file__).resolve().parent
wad = root / "wad"
map = root / "map"
mod = root / "mod"
save = root / "save"

binary = "/opt/gzdoom/gzdoom"
if not Path(binary).is_file():
    binary = shutil.which("gzdoom") or "/usr/local/bin/gzdoom"

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


def scan():
    """Return the sorted IWAD candidates from the wad/ folder."""
    return sorted(p for p in wad.glob("*.wad") if p.is_file())


def scan_map():
    """Return the sorted map packs from the map/ folder."""
    return sorted(p for p in map.glob("*.wad") if p.is_file())


def scan_mods():
    """Return the sorted loadable mods from the mod/ folder."""
    found = list(mod.glob("*.pk3")) + list(mod.glob("*.zip")) + list(mod.glob("*.rar"))
    found += [p for p in mod.iterdir() if p.is_dir()]
    return sorted(p for p in found if p.is_dir() or p.name not in ("", "."))


def menu(candidates, names):
    """Print the numbered list and return the chosen path."""
    for i, p in enumerate(candidates, start=1):
        name = names.get(p.name, p.stem)
        size = p.stat().st_size / (1024 * 1024)
        print(f"  {i:>2}. {name:<28} {p.name:<16} {size:6.1f} MB")
    print(f"  {len(candidates) + 1:>2}. quit")
    while True:
        raw = input("pick a number: ").strip()
        if raw == "":
            continue
        choice = int(raw)
        if choice == len(candidates) + 1:
            sys.exit(0)
        if 1 <= choice <= len(candidates):
            return candidates[choice - 1]


def menu_multi(candidates, label):
    """Print the numbered list, accept comma picks, return selected paths."""
    if not candidates:
        return []
    print(f"{label} available (comma numbers, enter for none):")
    for i, p in enumerate(candidates, start=1):
        size = p.stat().st_size / (1024 * 1024)
        print(f"  {i:>2}. {p.name:<40} {size:6.1f} MB")
    raw = input(f"pick {label}: ").strip()
    if raw == "":
        return []
    picks = []
    for token in raw.split(","):
        token = token.strip()
        if token.isdigit() and 1 <= int(token) <= len(candidates):
            picks.append(candidates[int(token) - 1])
    return picks


def command(path, maps, mods):
    """Build the gzdoom command line for the chosen IWAD, maps, and mods."""
    argv = [binary, "-iwad", str(path), "-savedir", str(save)]
    for p in maps:
        argv += ["-file", str(p)]
    for p in mods:
        argv += ["-file", str(p)]
    return argv


def run(argv):
    """Dispatch CLI flags or launch the interactive menu."""
    if "--list" in argv:
        for p in scan():
            print(p.name)
        return 0
    if "--dry-run" in argv:
        for flag in argv:
            if flag.startswith("--iwad="):
                name = flag.split("=", 1)[1]
                path = wad / name
                print(" ".join(command(path, [], [])))
                return 0
    for flag in argv:
        if flag.startswith("--iwad="):
            name = flag.split("=", 1)[1]
            path = wad / name
            if not path.is_file():
                print(f"missing: {path}", file=sys.stderr)
                return 1
            subprocess.run(command(path, [], []), check=False)
            return 0
    candidates = scan()
    if not candidates:
        print(f"no IWAD found in {wad}", file=sys.stderr)
        return 1
    path = menu(candidates, GAME)
    picks_map = menu_multi(scan_map(), "maps")
    picks_mod = menu_multi(scan_mods(), "mods")
    subprocess.run(command(path, picks_map, picks_mod), check=False)
    return 0


if __name__ == "__main__":
    save.mkdir(exist_ok=True)
    sys.exit(run(sys.argv[1:]))
