# wads.tsv — custom WAD registry

One file for all WADs; one line per WAD; tab-separated; header row present.

```text
file	size_bytes	date	source	header	game	kind	title	author
```

- `file` — archive name in `wad/custom/` (e.g. `scythex.zip`)
- `title` — WAD title from the idgames listing
- `author` — author(s) from the listing
- `game` — base game: `doom`, `doom2`
- `kind` — scale: `map` (single map), `maps` (2–9 maps), `episode` (full episode replacement), `megawad` (large multi-episode)
- `size_bytes` — verified archive size on disk (byte-exact)
- `date` — release date `MM/DD/YY` from the listing
- `source` — idgames archive path (gamers.org mirror leaf)
- `header` — WAD header probe: `PWAD` (custom), `IWAD` (standalone)

## Conventions

- Every row traces to a verified download: `7z t` archive pass + PWAD header probe.
- Tabs separate fields; titles and authors keep commas/quotes verbatim.
- `wad/custom/` loads via `-file`; the launcher never surfaces these as IWADs.
- Add one row per acquired WAD; keep `size_bytes` byte-exact from `stat -c%s`.

## Current state

- 15 WADs registered; 15 archives in `wad/custom/`, all `7z t` clean.
- Registry maintained by the wad-downloader project (`script/wad-downloader/AGENTS.md`).
