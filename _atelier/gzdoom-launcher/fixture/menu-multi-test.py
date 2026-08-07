"""Fixture — menu_multi(): comma picks, 'all' gating, empty, invalid-token handling.

Run:   uv run python fixture/menu-multi-test.py
Proves the multi-select parsing before the map/mod menus trust it, and that
'all' stays disabled for maps (loading every map pack would crash gzdoom).
"""

import builtins
import sys
import tempfile
from pathlib import Path

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root))

import launcher


def check(name, cond):
    """Assert one fixture expectation and print the outcome."""
    if not cond:
        raise AssertionError(f"FAIL: {name}")
    print(f"ok   {name}")


def pick(keys, candidates, allow_all=False):
    """Run menu_multi with a stubbed input and return the selected paths."""
    orig = builtins.input

    def stub(prompt="", k=keys):
        return k

    builtins.input = stub
    try:
        return launcher.menu_multi(candidates, "mods", allow_all=allow_all)
    finally:
        builtins.input = orig


def run():
    """Exercise the parsing against real files (menu_multi stats each path)."""
    with tempfile.TemporaryDirectory() as td:
        base = Path(td)
        fake = [base / "a.pk3", base / "b.pk3", base / "c.zip", base / "d.pk3"]
        for p in fake:
            p.write_text("x")
        names = [p.name for p in fake]

        check("empty returns none", pick("", fake) == [])
        check("all without allow_all returns none", pick("all", fake) == [])
        check(
            "all returns full order",
            [p.name for p in pick("all", fake, allow_all=True)] == names,
        )
        check(
            "ALL case-insensitive",
            [p.name for p in pick("ALL", fake, allow_all=True)] == names,
        )
        check("comma picks", [p.name for p in pick("1,3", fake)] == ["a.pk3", "c.zip"])
        check(
            "invalid token skipped",
            [p.name for p in pick("1,9,2", fake)] == ["a.pk3", "b.pk3"],
        )
        check(
            "whitespace tolerated",
            [p.name for p in pick(" 1 , 2 ", fake)] == ["a.pk3", "b.pk3"],
        )
        check("no candidates", pick("all", []) == [])


if __name__ == "__main__":
    run()
