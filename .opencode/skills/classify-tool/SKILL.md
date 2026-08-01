---
name: classify-tool
description: Use this skill when classifying a tool file — it walks through a decision tree to classify any .opencode/tools/ file by automata I/O model
state-profile: hybrid
related: []
patterns: ["NEX.TOOL.SEQUENCE", "PROT.TOOL.SCOPE", "PROT.TOOL.AUTOMATON"]
---
**Procedure**

When classifying a tool:

1. **Pre-check** — read line 1 of the tool file. If `// @toolclass <CODE>` is present, report current class. Ask user: reclassify or skip

2. **Read source** — list all I/O operations: `Bun.file()`, `fs.readFile` / `fs.writeFile`, `queryAll` / `queryOne` / `.run()`, stdin / stdout, `fetch()` (network)

3. **Read check** — any read operation at all? (file, DB, stdin, network)

4. **Write check** — any write operation at all? (file, DB, stdout, network)

5. **Direction check** — input source and output target are the same tape (same file, same table) or separate?

6. **Classify by table**:

   | Reads? | Writes? | Same tape? | Class |
   |--------|---------|------------|-------|
   | Yes    | False   | —          | RECG  |
   | Yes    | Yes     | False      | TRNS  |
   | False  | Yes     | —          | GENR  |
   | Yes    | Yes     | True       | SGNL  |

7. Report class + reasoning with source line references

8. On confirmation — write `// @toolclass <CODE>` at line 1 of the tool file. If line 1 is already an import or other statement, insert a new line 1 and shift existing content down.

**Gotchas**

- I/O via imported libs may be invisible in the tool file alone — read import chain if behavior is ambiguous
- Async patterns (`await Bun.file().text()`, `Promise.all`) maintain class — only read/write presence matters
- `sync-watch.ts` is legacy shebang — classify manually as TRNS (reads files, watches)
- Subproject tools may have their own classification — respect project-local scoping per PROT.TOOL.SCOPE
- Tool reading and writing same file/table is SGNL only if write depends on read — otherwise TRNS with overlapping tapes
- Each tool belongs to exactly one class — mutually exclusive per PROT.TOOL.AUTOMATON

**Rules**

- Classification follows PROT.TOOL.AUTOMATON — authoritative standard
- Every tool has exactly one class — mutually exclusive
- Every tool produces or consumes data — reads and writes required. Absence of both is flagged as error
- Annotation goes at line 1: `// @toolclass <CODE>`
- After adding annotation, re-run `audit-tool` to verify coverage
