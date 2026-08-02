# Bash / Shell

**Role** — Bash forms binary imperative shells: tool wrappers, orchestrators, automated flows. It clones repos, pipes logs, moves files, sequences commands. `SPEC.LANGUAGE.ROLE.MAP` governs.

**Ring** — r0 sits innermost and holds the design base. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.

**Style**

- Execute one task per shell.
- Open with `set -uo pipefail`.
- Guard shared resources before work.
- Emit one keyed result line (`KEY=value`); write diagnostics to stderr.
- Exit non-zero on failure.
- Name the task and the call in the header comment.

**Naming** — `SPEC.CODE.ELEMENT.NAME` governs:

- Name the function with one singular concrete lowercase word.
- Name the constant with one singular abstract PascalCase word.
- Declare variables at file top as one singular concrete lowercase descriptor.
- Name files `{action}-{subject}.sh`, lowercase dash-slug.

**Home** — `_templates/` holds shared tooling; `{repo}-repo/scripts/` holds dive scripts; `_templates/atomic-script-template.sh` scaffolds.

**Select** — the task sequences commands, files, and processes.

**Escalate** — r0 moves to r1 (ruby) when bash lacks logic that models data. `SPEC.LANGUAGE.RING.TOPOLOGY` governs.
