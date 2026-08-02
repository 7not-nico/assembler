# Go

**Role** — Go serves systems and high-performance logic: goroutine-parallel workers, binary-transport services; parallel work and compile speed favor it. `SPEC.LANGUAGE.ROLE.MAP` governs.

**Ring** — r3, the terminus ring, with rust. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.

**Style**

- Use goroutines + channels for parallel work; prefer interfaces; return errors explicitly.
- Format with gofmt; contain panics within boundaries.

**Naming** — `SPEC.CODE.ELEMENT.NAME` governs:

- Name the struct with one singular abstract Upper word.
- Name the function with one singular concrete lowercase word.
- Name the method camelCase with `[subjectNoun] + agentiveNoun`; the agentive joins the verb root with `{vowel}r`; drop the subject when it shadows a function name.

**Home** — binary-transport services and parallel workers live under the toolchain.

**Select** — the task needs parallel work or compile speed; binary protocols run at scale.

**Escalate** — r3 terminates the chain. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.
