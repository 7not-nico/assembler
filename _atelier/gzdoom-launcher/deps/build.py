"""Pure ring — deterministic logic, no I/O, no local imports."""

from schema import const


def folder_label(p):
    """Return the display label for a path's folder (doom1-tmp -> doom1)."""
    return p.parent.name.removesuffix("-tmp")


def command(binary, path, maps, mods):
    """Build the gzdoom command line for the chosen IWAD, maps, and mods."""
    argv = [binary, "-iwad", str(path), "-savedir", str(const.save)]
    for p in maps:
        argv += ["-file", str(p)]
    for p in mods:
        argv += ["-file", str(p)]
    return argv


def parse_picks(raw, n):
    """Comma tokens -> 1-based indices within 1..n; blank -> none; invalid skipped."""
    if raw.strip() == "":
        return []
    picks = []
    for token in raw.split(","):
        token = token.strip()
        if token.isdigit() and 1 <= int(token) <= n:
            picks.append(int(token))
    return picks
