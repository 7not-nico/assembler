# Rust

**Role** — Rust powers core logic where speed and safety bind: ANN backends, binary transports, computational kernels; `_rustlib/target/release/assemble` (score | hit | unit over JSON stdin/stdout). `SPEC.LANGUAGE.ROLE.MAP` governs.

**Ring** — r3, the terminus ring. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.

**Style**

- Write functional Rust: pure functions, immutable data.
- Keep heavy compute predictable and parallel-safe.
- Guard standalone processes with the `import.meta.main` equivalent.

**Naming** — `SPEC.CODE.ELEMENT.NAME` governs (Rust: struct, fn, method):

- Name the struct with one singular abstract Upper word.
- Name the function with one singular concrete lowercase word.
- Name the method camelCase with `[subjectNoun] + agentiveNoun`; the agentive joins the verb root with `{vowel}r`; drop the subject when it shadows a function name.
- Name the constant with one singular abstract PascalCase word.

**Select** — the task needs raw speed, binary transport, or a computational kernel.

**Escalate** — r3 terminates the chain. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.
