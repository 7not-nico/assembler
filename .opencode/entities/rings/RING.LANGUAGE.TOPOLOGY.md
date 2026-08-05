**Language Ring Topology** — four language rings order the pattern design by capability. Lower rings sit inward; higher rings sit outward. Ordinal precedence governs the design: r0 → r1 → r2 → r3. Design starts at the innermost ring (r0 bash). Design moves one ring outward when the current ring does not suffice. Ring r3 (go and rust) terminates the chain. Before moving into an outer Ring, ask for input on how to proceed.

## Rings

```
r0  bash + perl      innermost ring — the design base
r1  python + ruby       scripts tied to a schema
r2  typescript  OpenCode extension
r3  go + rust   outermost ring — the capability terminus
```

Ring r0 (bash and perl) forms imperative shells. The shells wrap tool wrappers, launch pipelines, and command sequences. Ring r0 holds the design base.

Ring r1 (python + ruby) processes scripts tied to a schema. The scripts read and write through SQL schemas. Functional style governs the code. Ruby serves when bash lacks logic that models data.

Ring r2 (typescript) extends OpenCode functionality. IPC tools, plugins, and MCP servers live under `.opencode/tools/`. The tools use shared `_lib/` modules. Typed boundaries wrap the imperative shell.

Ring r3 (go and rust) powers systems and high-performance logic. ANN backends, binary transports, and computational kernels form the core. Go serves concurrency and compile speed. Rust serves speed and safety. Ring r3 holds the capability terminus.

## Ordinal precedence

The chain r0 → r1 → r2 → r3 governs the design. Lower rings sit inward; higher rings sit outward. Design starts at the innermost ring that suffices — r0 first. Design moves one ring outward when the current ring does not suffice. A pattern rests at the lowest (innermost) ring that satisfies its task.

## Escalation rule

Design starts at r0. Design moves to r1 when r0 does not suffice. Design continues ring by ring to r3. Ring r3 terminates the chain. No ring beyond it exists.

## Applicability

All pattern design in the workspace: tool creation, scripts that automate, and core-logic builds.

---
id: RING.LANGUAGE.TOPOLOGY
title: Language Ring Topology — r0 Bash Inward to r3 Go/Rust Outward
source: assembler
summary: "Four language rings order the pattern design by capability: r0 bash, r1 ruby, r2 typescript, r3 go and rust. Lower rings sit inward; higher rings sit outward. Ordinal precedence r0→r3 governs the design; patterns start at the innermost ring and move one ring outward when the current ring does not suffice. Ring r3 terminates the chain."
specifies: Four ordinal language rings with inward-to-outward escalation for pattern design
tags: [language, ring, topology, escalation, bash, ruby, typescript, go, rust, specification]
status: active
---
