# Learning Chain — walk precedence chain for Rust topics

Walk the Learning Precedence Chain for any Rust concept: `precept/` → `procedure/` → `note/` → `bitacora/` → `glossary/` → `reference/` → `fixtures/`.

## Triggers

- User starts a new Rust topic
- User asks to learn a concept from the ground up
- User asks for the authoritative source on a rule

## Workflow

1. **precept/** — read the action-domain rule. One rule per file. Declarative statement governing all work.
   - `precept/` names match action-domain: `source-playwright.md`, `write-bitacora.md`, `query-patlib.md`
   - Compose with matching `procedure/` when both exist

2. **procedure/** — read the procedural chain. Numbered steps. Atomic per workflow.
   - Same naming as precept — compose by matching domain
   - Example: `procedure/compose-web.md` composes with `precept/load-compose-web.md`

3. **note/** — read the chapter notes. Chapter number prefix.
   - `note/ch{number}-{topic}.md` — e.g. `ch08-collections.md`
   - Project aspect documentation

4. **bitacora/** — read session walkthroughs. Name describes the work.
   - `bitacora/{number}-{description}.md` — e.g. `003-ch13-procedure-chain.md`
   - Shows actual application of concepts

5. **glossary/** — term definition. One term per file. Declarative.
   - `glossary/{term}.md` — e.g. `ownership.md`
   - States what the thing IS
   - Registered in `glossary.db`

6. **reference/** — conventions and exceptions. Governs fixtures.
   - `reference/conventions.md` — naming, structure, prohibitions
   - `reference/element-name.md` — noun classification
   - `reference/exception.md` — documented overrides

7. **fixtures/** — raw learning code. Governed by conventions.
   - `fixtures/ch{number}-{aspect}.rs` — e.g. `ch10-traits.rs`
   - Header includes source, module, compile

## Violation rule

Advancing to a layer before completing prior layers is prohibited. Each layer must produce understanding before the next.

## References

- `AGENTS.md` — precedence chain definition, directory roles
- `reference/conventions.md` — code rules
- `reference/element-name.md` — naming spec
- `schema/glossary.sql` — glossary registry
