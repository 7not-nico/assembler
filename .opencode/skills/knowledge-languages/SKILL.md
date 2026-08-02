---
name: knowledge-languages
description: Use this skill when answering programming-language questions — dispatch bash, ruby, go, rust, typescript to role and ring conventions per ref/{language}.md.
state-profile: stateless
nexus: NEX.TOOL.CHOICE
---

**Trigger**

A programming-language question starts — dispatch to the per-language reference. The role and the ring select the language.

**Procedure**

1. Match the language to its file — `ref/bash.md`, `ref/ruby.md`, `ref/go.md`, `ref/rust.md`, `ref/typescript.md`.
2. Read the file before code.
3. Apply the role test per `SPEC.LANGUAGE.ROLE.MAP` — schema SQL selects ruby; speed/binary/kernel selects rust or go; command/process sequencing selects bash; OpenCode extension selects typescript.
4. Apply the ring test per `SPEC.LANGUAGE.RING.TOPOLOGY` — start r0 (bash); escalate one ring outward when it does not suffice; r3 terminates the chain.
5. Follow the file's style and naming per `SPEC.CODE.ELEMENT.NAME`.

**Gotchas**

- Let the role and the ring select the language — the reference file matches the task
- Read the reference file before code — the file informs the style and naming
- Match the naming and style to the file's rules — each language carries its own convention
