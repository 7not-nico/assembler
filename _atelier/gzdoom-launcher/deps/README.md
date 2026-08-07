# deps — launcher purity rings

Purity-split port of `launcher.py` per `PATTERN.PURITY.PORT.PIPELINE`: a pure core (ring 0, no I/O) and an io edge (ring 4, filesystem/stdin/stdout/subprocess). Same shape as the epub-maker instance (`deps/extract.py` pure, `deps/fetch.py` io). The fixture gate already proves the pure pieces; the split makes the boundary explicit and testable with no setup.

## Layout

```text
deps/
├── build.py       pure ring — deterministic, no side effects, no imports from io
└── launch.py      io ring — filesystem reads, stdin/stdout, subprocess; imports build
schema/
└── const.py       constants: root paths (wad/map/mod/save), GAME/LEVEL name tables,
                   EXT set, binary default — no I/O at import
```

deps/ file names are action verbs in singular form (epub-maker precedent: `fetch.py`, `extract.py`); constants live in `schema/const.py`, never in deps/.

`launcher.py` becomes a thin entry: imports from `deps`, keeps `if __name__ == "__main__"`, and re-exports the public functions so existing fixtures and call sites keep working unchanged.

## Ring assignment — function by function

```text
build.py (pure)                      launch.py (io)
─────────────────────                ─────────────────────
folder_label(p)                      binary discovery (is_file / shutil.which)
command(binary, path, maps, mods)    scan()          — wad/ glob
parse_picks(raw, n)                  scan_map()      — map/ + temp dirs glob
   (comma tokens -> indices)         scan_mods()     — mod/ globs + iterdir
                                     menu()          — stdin/stdout
                                     menu_multi()    — stdin/stdout, calls parse_picks
                                     run(argv)       — dispatch + subprocess
```

## Boundary rules

```text
launch.py imports build.py; build.py imports nothing local
pure functions never touch sys/os/files/subprocess; io owns every side effect
schema/const.py is shared, side-effect-free; launcher.py re-exports the io surface
```

- `parse_picks(raw, n)` extracts the tokenization from `menu_multi` (comma split, digit/range guard, empty → none) so the selection logic is pure and fixture-testable without stdin
- `command()` and `folder_label()` are already pure — they move as-is
- `menu_multi` keeps its `allow_all` flag; the flag logic stays in io (it owns input), `parse_picks` handles tokens only

## Fixture impact

- `fixture/scan-*.py` + `fixture/command-build-test.py` + `fixture/menu-multi-test.py` keep importing `launcher` — the re-export shim keeps them green
- New pure-ring unit tests (optional): `parse_picks` matrix (empty, single, comma, invalid, range) — no fs setup needed, proving the boundary
- Gate unchanged: `uv format -> ruff check -> fixture -> smoke -> integrity -> launch`

## Status

- [x] deps/const.py — constants moved out of launcher.py
- [x] deps/pure.py — folder_label, command(binary, ...), parse_picks
- [x] deps/io.py — scans, menus, run, binary discovery
- [x] launcher.py — thin entry + re-export shim (sorted __all__)
- [x] gates re-run: format, ruff (0 findings), fixture 8/8, smoke exit 0, pure-ring assert matrix
- [x] bitacora record + commit
