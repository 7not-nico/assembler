---
id: PATTERN.DIVE.COPY.CARRIER
title: Dive Copy Carrier — Tooling Rides into Every Dive
layer: pattern/
purpose: "copy-templates.sh carries the tool chain (shell files, deps/, _shared/) into a dive copy, so copied tooling resolves exactly like the canonical tree."
naming: dive-copy-carrier.md
tags: [pattern, morphism, copy, dive, carrier]
status: active
---
# DIVE-COPY-CARRIER.md

**Layer:** pattern/
**Naming:** `dive-copy-carrier.md` — code morphism, reusable structure.
**Composes with:** `pattern/location-aware-walk-up.md`; derived from `study/` + `fixture/` proof.

## Morphism

A dive copy carries the tool chain — shell files, `deps/`, `_shared/` — verbatim alongside the copied scripts, so every copy resolves its dependencies exactly like the canonical tree.

## Structure

```text
copy-templates.sh {target}
    SHELL_FILES=(start-browser.sh start-browser-headless.sh run-logged.sh slugify.sh)  → $TARGET/
    shell/deps/   → $TARGET/deps/      (copies source deps/{logger,browser,paths}.sh)
    _shared/      → $TARGET/_shared/   (deps exec the _shared/bin Go binaries)
    landing:      $TARGET under _codex/ → walk-up resolution succeeds
```

Invariant: a copy carries its full dependency closure; nothing resolves back into the source tree; copies outside `_codex/` fail walk-up with the hint, never silently.

## Verification

Copy into `_codex/` and into `/tmp/opencode/`; assert both carry `deps/` + `_shared/`; run the copied `run-logged.sh` — the `_codex/` copy logs, the `/tmp` copy fails with the resolution hint.

## Instance

`shell/copy-templates.sh` (2026-08-05) — dive copies carry `deps/` + `_shared/`; the copied `run-logged.sh` records `# exit: 0` from inside `_codex/`.
