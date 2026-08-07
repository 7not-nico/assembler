"""Fixture — scan_mods(): archives (.pk3/.zip/.rar) and directories under mod/.

Run:   uv run python fixture/scan-mods-test.py
Proves the mod menu collects every loadable mod before a launch.
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
    """Exercise the mod scan against the live mod/ layout."""
    listed = launcher.scan_mods()
    names = [p.name for p in listed]
    check("sorted", names == sorted(names))
    archives = [p for p in launcher.mod.iterdir() if p.is_file() and p.suffix.lower() in launcher.EXT]
    dirs = [p for p in launcher.mod.iterdir() if p.is_dir()]
    check("every archive listed", all(p.name in names for p in archives))
    check("every dir listed", all(p.name in names for p in dirs))
    check("mod root only", all(p.parent == launcher.mod for p in listed))


if __name__ == "__main__":
    run()
