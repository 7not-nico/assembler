---
id: PROT.LIB.PURITY.BOUNDARY
title: "Lib Purity Boundary — Pure vs IO Module Split"
source: assembler
related: [PROT.LIB.CONTRACT, PROT.LIB.ENFORCEMENT]
summary: "Modules declare a purity level — pure, io, or db. Pure code imports only pure code; io code hosts side effects at the edges."
protocol: "Every lib module declares its purity level. Pure modules import only from pure modules, builtins, or packages. IO modules host side effects. DB modules sit between. The import direction follows the purity allowance matrix."
enforcement: Tool
status: active
priority: 3
tags: [lib, purity, boundary, functional, side-effects, imports]
---

Purity is the line between computation and effect. A module declares which side it lives on; the import graph enforces the split.

## Protocol

1. **Declare purity at module top** — the contract block states `// purity: pure|io|db` in the first lines.
2. **Pure modules import only from pure modules, builtins, or packages** — no io-layer imports in pure code.
3. **IO modules host side effects** — filesystem, network, and process calls live at the io layer.
4. **DB modules sit between** — database access imports controlled sets and stays out of pure modules.
5. **Import direction follows the allowance matrix** — pure imports pure; io imports pure and io; db imports its path modules.
6. **The boundary holds under composition** — combined logic splits into dedicated modules rather than crossing the line.

## Gotchas

- Pure module importing an io module: extract the io call into the io layer and pass the result in.
- Side effect hidden in a pure function: move the effect to an io module; keep the pure function effect-free.
- Db access from pure code: route through a db module and receive data as arguments.

## Enforcement

Tool — `rust-lint` and the script toolchain audits flag cross-purity imports. The `check` family reports purity violations per module.

## Applicability

Applies to every lib module in `.opencode/_lib/` and subproject `lib/` layers. Excluded: entry-point scripts, which orchestrate across layers by design.

## See also

- `PROT.LIB.CONTRACT` — module contract block
- `PROT.LIB.ENFORCEMENT` — lifecycle enforcement
- `REF.LIB.DIRECTION` — import direction reference
