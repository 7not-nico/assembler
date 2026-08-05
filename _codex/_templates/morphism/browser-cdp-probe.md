---
id: PATTERN.BROWSER.CDP.PROBE
title: Browser CDP Probe — One Instance, Port Probe, Connect
layer: morphism/
purpose: "A shared persistent Chromium runs one instance per profile on a CDP port; tools probe the port first, guard the profile lock, then connect over CDP."
naming: browser-cdp-probe.md
tags: [pattern, morphism, browser, cdp, probe, chromium]
status: active
---
# BROWSER-CDP-PROBE.md

**Layer:** morphism/
**Naming:** `browser-cdp-probe.md` — code morphism, reusable structure.
**Composes with:** `morphism/shared-deps-binary.md`; derived from `study/` + `fixture/` proof.

## Morphism

A shared persistent Chromium runs one instance per profile on a CDP port; launch probes the port first (idempotent), guards the `SingletonLock`, and consumers attach via `connectOverCDP` — never a second instance.

## Structure

```text
start:   port_up "$PORT" (deps/browser.sh)  → ALREADY, exit 0
lock:    [ -e "$PROFILE/SingletonLock" ]    → LOCK + holder identity, exit 1
launch:  nohup "$CHROME" --remote-debugging-port="$PORT" ... --profile-dir="$PROFILE"
probe:   _shared/bin/portup {port}          — GET /json/version, 2s timeout, exit 0|1
attach:  connectOverCDP("http://127.0.0.1:{port}")   — scripts and MCP alike
```

Invariant: one instance per profile; the port probe precedes every launch; the lock guard fails fast with the holder's identity.

## Verification

Probe an up port (exit 0) and a down port (exit 1); double-launch asserts `ALREADY`; a locked profile asserts `LOCK` + holder; a consumer connects over CDP without spawning.

## Instance

`shell/start-browser.sh` + `start-browser-headless.sh` + `instantiator/deps/browser.sh` + `_shared/cmd/portup` (2026-08-05) — CDP 9222 headed / 9223 headless; extensions and cookies live in the original profile.
