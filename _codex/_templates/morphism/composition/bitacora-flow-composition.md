---
id: PATTERN.COMPOSITION.BITACORA.FLOW
title: Bitacora Flow Composition — Record, Frame, Port, Wrap
layer: pattern/composition/
purpose: "How the bitacora flow composes: record-lifecycle opens, stream-tee-frame frames, purity-port-pipeline proves+ports, wrapper-delegation exposes."
naming: bitacora-flow-composition.md
tags: [pattern, composition, morphism, bitacora, flow, record, frame]
status: active
---
# BITACORA-FLOW-COMPOSITION.md

**Layer:** pattern/composition/
**Naming:** `bitacora-flow-composition.md` — code morphism, reusable structure.
**Composes with:** `pattern/composition/shared-binary-composition.md` (base form); derived from `study/` + `fixture/` proof.

## Morphism

The bitacora flow composes as one lifecycle across rings: the record lifecycle opens todo/log/report, the stream-tee frame carries every command, the purity-port pipeline proves in python then ports to Go, and wrappers expose the entry.

## Composition

```text
step 1  open     record-lifecycle       todo → task-stdout → report, no-clobber per topic
step 2  frame    stream-tee-frame       one handle, io.MultiWriter, header/live/tail
step 3  prove    purity-port-pipeline   typed python (r0 pure + r4 io), full matrix green
step 4  port     purity-port-pipeline   Go: pure core (record/body/frame) + io (write/run)
step 5  share    internal-shared-package  internal/codex walk-up — one home
step 6  wrap     wrapper-delegation     wrapper/run-bitacora.sh → shell → binary
step 7  verify   atomic-tool-contract   exit 0/1/2/127 matrix + trace evidence
```

Invariant: the lifecycle (step 1) and the frame (step 2) define the flow's contract; the port (steps 3–4) preserves it; the share (step 5) removes duplication; the wrapper (step 6) exposes it; the matrix (step 7) proves it.

## Verification

Run the 14-case matrix against the Go binary: todo/report open (0), no-clobber (1), missing-arg (2), run success (0)/failure (1)/empty (2)/missing-cmd (127), trace (0), no-subcommand (2); the trace log carries the `<tracer>` exec-tree line; unit tests pass with no setup.

## Instance

The bitacora flow (2026-08-05) — `shell/bitacora-todo.sh` + `shell/bitacora-run.sh` + `shell/bitacora-report.sh` (record-lifecycle), `_shared/cmd/bitacora/` (stream-tee-frame + purity-port-pipeline + internal-shared-package), `wrapper/bitacora-*.sh` (wrapper-delegation); 14/14 matrix + 10 unit tests green.
