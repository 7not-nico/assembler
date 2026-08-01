# r2-illustration-targets — Violation Output

Checks: only patterns and nexus may be illustrated.

Columns: `Illustration | Target | TargetType | Violation`

- `Illustration` — entity with `illustrates` field.
- `Target` — entity ID in the `illustrates` array.
- `TargetType` — resolved entity type of target.
- `Violation` — description.

Violation: "illustrated entity is {type} — only patterns/nexus allowed."
