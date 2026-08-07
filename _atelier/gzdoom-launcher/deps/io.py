"""Io ring — filesystem, stdin/stdout, subprocess. Imports the pure ring."""

import shutil
import subprocess
import sys
from pathlib import Path

from deps import const
from deps.pure import command, folder_label, parse_picks

binary = const.BINARY_DEFAULT
if not Path(binary).is_file():
    binary = shutil.which("gzdoom") or "/usr/local/bin/gzdoom"


def scan():
    """Return the sorted IWAD candidates from the wad/ folder."""
    return sorted(p for p in const.wad.glob("*.wad") if p.is_file())


def scan_map():
    """Return the sorted map packs from the map/ folder, incl. temporal doom1-tmp/ and doom2-tmp/ wads."""
    base = sorted(p for p in const.map.glob("*.wad") if p.is_file())
    temps = [
        p
        for d in ("doom1-tmp", "doom2-tmp")
        for p in (const.map / d).glob("*")
        if p.is_file() and p.name.lower().endswith(".wad")
    ]
    return sorted([*base, *temps])


def scan_mods():
    """Return the sorted loadable mods from the mod/ folder."""
    found = (
        list(const.mod.glob("*.pk3"))
        + list(const.mod.glob("*.zip"))
        + list(const.mod.glob("*.rar"))
    )
    found += [p for p in const.mod.iterdir() if p.is_dir()]
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


def menu_multi(candidates, label, allow_all=False):
    """Print the numbered list grouped by folder; accept comma picks, optional 'all'."""
    if not candidates:
        return []
    hint = ", 'all'," if allow_all else ","
    print(f"{label} available (comma numbers{hint} enter for none):")
    groups = []
    for p in candidates:
        g = folder_label(p)
        if not groups or groups[-1][0] != g:
            groups.append([g, []])
        groups[-1][1].append(p)
    shown = 0
    multi = len(groups) > 1
    for g, items in groups:
        if multi:
            print(g)
        for p in items:
            shown += 1
            size = p.stat().st_size / (1024 * 1024)
            print(f"  {shown:>2}. {p.name:<40} {size:6.1f} MB")
    raw = input(f"pick {label}: ").strip()
    if raw == "":
        return []
    if allow_all and raw.lower() == "all":
        return candidates
    return [candidates[i - 1] for i in parse_picks(raw, len(candidates))]


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
                path = const.wad / name
                print(" ".join(command(binary, path, [], [])))
                return 0
    for flag in argv:
        if flag.startswith("--iwad="):
            name = flag.split("=", 1)[1]
            path = const.wad / name
            if not path.is_file():
                print(f"missing: {path}", file=sys.stderr)
                return 1
            subprocess.run(command(binary, path, [], []), check=False)
            return 0
    candidates = scan()
    if not candidates:
        print(f"no IWAD found in {const.wad}", file=sys.stderr)
        return 1
    path = menu(candidates, const.GAME)
    picks_map = menu_multi(scan_map(), "maps")
    picks_mod = menu_multi(scan_mods(), "mods", allow_all=True)
    subprocess.run(command(binary, path, picks_map, picks_mod), check=False)
    return 0
