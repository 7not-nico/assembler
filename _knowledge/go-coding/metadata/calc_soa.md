# calc_soa.go — all comments

Total comments: 11

## Header

- L1: ── Variant: SOA ── subject → object → action ─────────
- L2: 
- L3: Imperative shell: reads input, calls calc package, prints output.
- L4: All calculation logic is in calc/ — pure functions, no I/O.
- L5: All I/O helpers are in lib/ — shared across shells.
- L6: 
- L7: Usage:
- L8: go run . soa
- L9: ─────────────────────────────────────────────────────────
- L22: runSOA — shell: subject → object → action.

## Body

- L46: Call pure core — no logic in shell