# TypeScript

**Role** — TypeScript extends the OpenCode runtime: IPC tools, plugins, MCP servers under `.opencode/tools/`; shared `_lib/` modules; Bun runtime. `SPEC.LANGUAGE.ROLE.MAP` governs.

**Ring** — r2. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.

**Style**

- Construct imperative shells with static TypeScript: typed boundaries wrap the imperative layer.
- Keep the engine core logic in Rust.
- Carry contract headers, explicit return types, purity annotations in files.

**Format** — format before new work:

- Run `bun format` on the file when biome lives in `.opencode/package.json`; install with `bun add -d @biomejs/biome`.
- Run `bunx tsc --noEmit` after formatting; clean type-check output precedes new code.
- Fall back to manual cleanup when biome misses: align two-space indents, strip trailing whitespace, keep lines under 120, double-quote strings.

**Naming** — `SPEC.CODE.ELEMENT.NAME` governs (TypeScript: class, function, method):

- Name the class with one singular abstract Upper word.
- Name the function with one singular concrete lowercase word.
- Name the method camelCase with `[subjectNoun] + agentiveNoun`; the agentive joins the verb root with `{vowel}r`; drop the subject when it shadows a function name.
- Declare variables at file top as one singular concrete lowercase descriptor.
- Name the constant with one singular abstract PascalCase word.

**Home** — `.opencode/tools/` hosts tools; the shared node_modules symlink carries deps; opencode.json registers MCP servers.

**Select** — the task extends the OpenCode agent runtime.
