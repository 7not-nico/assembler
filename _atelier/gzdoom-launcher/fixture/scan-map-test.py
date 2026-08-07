"""Fixture — scan_map(): permanent packs + game-split temporal dirs, case-insensitive.

Run:   uv run python fixture/scan-map-test.py
Proves every .wad entry in map/doom1-tmp + map/doom2-tmp (any case) surfaces
in the map menu before a launch.
"""

import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root))

import launcher


def check(name, cond):
    """Assert one fixture expectation and print the outcome."""
    if not cond:
        raise AssertionError(f"FAIL: {name}")
    print(f"ok   {name}")


def run():
    """Exercise the map scan against the live map/ layout."""
    paths = [str(p) for p in launcher.scan_map()]
    check("sorted by path", paths == sorted(paths))
    for name in (
        "nerve.wad",
        "masterlevels.wad",
        "sigil.wad",
        "sigil2.wad",
        "iddm1.wad",
    ):
        check(f"permanent {name}", name in [p.name for p in launcher.scan_map()])
    for d in ("doom1-tmp", "doom2-tmp"):
        for p in (launcher.map / d).glob("*"):
            if p.is_file() and p.name.lower().endswith(".wad"):
                check(
                    f"temp listed {d}/{p.name}",
                    p.name in [p.name for p in launcher.scan_map()],
                )
    check(
        "no nested drift",
        all(
            p.parent == launcher.map or p.parent.name.endswith("-tmp")
            for p in launcher.scan_map()
        ),
    )


if __name__ == "__main__":
    run()
