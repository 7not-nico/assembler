"""Fixture — command(): the exact gzdoom command line.

Run:   uv run python fixture/command-build-test.py
Proves -iwad/-savedir placement, -file ordering for maps then mods,
and the binary preference (self-contained /opt/gzdoom/gzdoom).
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
    """Exercise command() with controlled path inputs (no disk access needed)."""
    gz = launcher.binary
    iwad = launcher.wad / "doom.wad"
    m1 = launcher.map / "nerve.wad"
    m2 = launcher.map / "doom1-tmp" / "e1m8b.wad"
    mo = launcher.mod / "relighting-v4.pk3"

    check("binary preferred", gz == "/opt/gzdoom/gzdoom")
    bare = launcher.command(gz, iwad, [], [])
    check("binary first", bare[0] == gz)
    check("iwad flag", bare[1:3] == ["-iwad", str(iwad)])
    check("savedir flag", bare[3:5] == ["-savedir", str(launcher.save)])

    with_maps = launcher.command(gz, iwad, [m1, m2], [])
    check("maps -file", with_maps[5:] == ["-file", str(m1), "-file", str(m2)])

    full = launcher.command(gz, iwad, [m1], [mo])
    check("maps then mods", full[5:] == ["-file", str(m1), "-file", str(mo)])
    check(
        "dry-run shape",
        " ".join(bare) == f"{gz} -iwad {iwad} -savedir {launcher.save}",
    )


if __name__ == "__main__":
    run()
