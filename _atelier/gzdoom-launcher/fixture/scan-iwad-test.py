"""Fixture — scan(): IWAD candidates, non-recursive, wad/custom/ excluded.

Run:   uv run python fixture/scan-iwad-test.py
Proves the IWAD menu candidate set stays clean before any launch.
"""

import sys
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root))

import launcher  # noqa: E402


def check(name, cond):
    """Assert one fixture expectation and print the outcome."""
    if not cond:
        raise AssertionError(f"FAIL: {name}")
    print(f"ok   {name}")


def run():
    """Exercise the IWAD scan against the live wad/ layout."""
    candidates = launcher.scan()
    names = [p.name for p in candidates]
    check("non-empty", len(candidates) > 0)
    check("sorted", names == sorted(names))
    check("root wad only", all(p.parent == launcher.wad for p in candidates))
    check("custom excluded", all("custom" not in str(p) for p in candidates))
    check("standalone present", "doom.wad" in names and "doom2.wad" in names)
    check("all wad suffix", all(p.suffix == ".wad" for p in candidates))


if __name__ == "__main__":
    run()
