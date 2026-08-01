# r2-related-validate — Violation Output

Checks: `related` connects only within same knowledge ring + group.

Columns: `ID | Type | Group | Ring | Related | RelGroup | RelRing | Violation`

- `ID` — entity with the `related` field.
- `Type` — its entity type directory.
- `Group` / `Ring` — its knowledge ring position.
- `Related` — the entity ID in the `related` array.
- `RelGroup` / `RelRing` — the target's knowledge ring position.
- `Violation` — description.

Two violation types:
- `cross-group related: A → B` — A and B are in different groups.
- `cross-ring related: R2 → R1` — same group but different ring.
