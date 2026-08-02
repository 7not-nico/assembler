# Functional Ruby

**Role** — Ruby processes script tasks tied to a schema: `.opencode/_scripts/` and `script/` folders; it reads and writes through `.sql` definitions and sqlite3 databases. `SPEC.LANGUAGE.ROLE.MAP` governs.

**Ring** — r1. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.

**Style**

- Compose pure functions; keep side effects light.
- House fixtures under `.opencode/_scripts/fixtures`.

**Naming** — `SPEC.CODE.ELEMENT.NAME` governs (Ruby: method):

- Name the method camelCase with `[subjectNoun] + agentiveNoun`; the agentive joins the verb root with `{vowel}r`; drop the subject when it shadows a function name.
- Name the constant with one singular abstract PascalCase word.
- Declare variables at file top as one singular concrete lowercase descriptor.

**Knowledge** — `_knowledge/ruby/` holds atomic files: proc, lambda, closure, composition, curry, anonymous-params, to-proc, strings, symbols, arrays, hashes, integers, floats, enumerables, files, regexp, exceptions. Official docs: `docs.ruby-lang.org/en/3.4/{Class}.html`.

**Select** — the task manipulates schema-backed data through SQL.

**Escalate** — r1 moves to r2 (typescript) when the task needs the OpenCode runtime. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.
