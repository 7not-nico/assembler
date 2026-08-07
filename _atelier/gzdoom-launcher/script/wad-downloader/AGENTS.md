# AMANDA wad-downloader — Agent Instructions

## Identity

- serves as the agent instruction file for the wad-downloader script project
- instantiates a bash-first downloader for the idgames archive under `script/wad-downloader/`
- states final absolute states per `RUL.AGENTS.STATE`

## Domain

This project downloads WADs from the idgames archive (`levels/` tree) into the launcher's `wad/custom/`. The gamers.org mirror serves the fetch channel; the doomworld frontend serves discovery. The flow iterates in bash; the Python+uv purity-ring path (httpx-retries) stands documented as the fallback.

## Structure

- `scripts/fetch-index.sh` — atomic read: fetch one directory index, list zip/dir links; `curl -sL` follows Apache 301 trailing-slash redirects; `<1000`-byte size guard with 3 tries / 3 s backoff; emits `ZIPS=`/`DIRS=` keyed lines
- `scripts/fetch-wad.sh` — atomic write: download one zip, verify the archive; retry loop (`rm -f` partial → `curl -sL` → `7z t`, 3 tries / 3 s backoff); emits `WAD=`/`SIZE=` keyed lines
- `scripts/download.sh` — orchestrator: stage 1 index presence check → stage 2 fetch → stage 3 verify; emits `DOWNLOADED=1`/`TARGET=`; stops the chain on failure
- `scripts/batch-download.sh` — batch orchestrator: loops `download.sh` over a list file; emits `DONE=`/`FAILED=`/`TOTAL=`; non-zero on any failure
- `top-rated-picks.txt` — curated pick list from the doomworld Top Rated frontend (12 paths, one per line, `#` comments allowed)
- destination default `wad/custom/` at the launcher root (resolved via `BASH_SOURCE` walk-up)

## Runtime

```bash
bash scripts/fetch-index.sh "levels/doom2/a-c" --zips    # list zips in a bucket (685 in a-c)
bash scripts/fetch-wad.sh "levels/doom/Ports/d-f/e1m8b.zip" /tmp/stage   # download + verify one zip
bash scripts/download.sh "levels/doom/Ports/d-f/e1m8b.zip" wad/custom    # full chain into the launcher
```

- Archive base: `https://www.gamers.org/pub/idgames` (challenge-free Apache index); leaf pattern `levels/{game}/{bucket}/name.zip`
- Discovery: `https://www.doomworld.com/idgames/?top` — Top Rated form (count/votes), Cloudflare-gated for curl, browser-only
- `mirror.serversurfer.com` DNS-fails; `doomworld.com/idgames/` files return 403 to curl — both bypassed by design
- Verified downloads: `wad/custom/e1m8b.zip` (220,162 B; e1m8b.wad + e1m8b.txt, 7z t clean)

## Integrity

- Every zip passes the `7z t` archive test before a `WAD=` line prints; partial bodies fail the test and retry
- Directory indices pass the `<1000`-byte size guard before parsing; a 301 redirect body (260 B) never parses as a listing
- Scripts run `set -uo pipefail`; diagnostics go to stderr; keyed result lines carry machine state to the next stage

## Precedence chain

Downloader work advances in chain order; each gate passes before the next stage runs.

```text
probe -> fetch-index -> fetch-wad -> verify -> stage
```

- `probe` — channel reachable (gamers.org 200; doomworld browser-only)
- `fetch-index` — listing parsed and counted (`ZIPS=` > 0)
- `fetch-wad` — zip body lands in the destination
- `verify` — `7z t` passes; `WAD=`/`SIZE=` lines emitted
- `stage` — the zip moves into `wad/custom/` and shows up via `-file`

The forbidden state is a staged zip whose archive test never passed, or a listing parsed from a redirect body.

## Reports and todos

- bitacora records live under the workspace root `.opencode/_bitacora/` per the root `AGENTS.md`
- every command pipes through `bash .opencode/_bitacora/bitacora-log.sh {name} -- {command}`; exec-level detail runs `tracexec log --` as the command
- completion report: `.opencode/_bitacora/task-report/20260806-wad-downloader.md`
