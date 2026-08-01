---
id: NEX.LIB.STACK
title: Lib Handler — io Orchestration, Pure Formatting
source: assembler
summary: DB access logic extracts into io handlers in lib/. Read handlers return raw data for formatting; write handlers normalize, serialize, write, and sync. Transport stays thin.
composition: Separate orchestration from formatting and write-side concerns. io handlers encapsulate all DB/filesystem logic. Transport layers wire handler results to the agent.
enforcement: Convention
related: []
tags: [architecture, lib, handler, pattern, separation, purity, io, formatting, write]
status: active
priority: 3
---

Each lib handler encapsulates a complete data operation. It manages its own I/O lifecycle, delegates query building to pure functions, and returns raw data. Format modules handle text conversion at the transport layer.

### Read handler stack

```
transport (MCP tool / CLI)   ← thin, calls handler + formatter
  handler (lib/*.ts, io)      ← queries DB, returns raw data
  formatter (lib/format-*.ts, pure)  ← data → text
```

### Write handler stack

```
transport (plugin)            ← thin, calls handler
  handler (lib/*.ts, io)       ← normalize → serialize → write → sync → return message
```

Write handlers follow the same purity contract with three differences:
- Status message return — returns confirmation string directly. Formatters stay unused.
- Side effects — writes filesystem (.md file) then synchronizes to DB.
- Plugin-only transport — transport is always an OpenCode plugin. MCP and CLI handle read operations.

### Handler contract

- `// purity: io` — manages `initDB()` + `connect()` + `close()` internally
- `// depends-on:` — declares all internal lib dependencies with purity
- Returns `Record<string, unknown>[]` or structured result objects
- Format module imports stay in transport layers. Handlers return data only.

### Benefits

1. **DRY** — MCP and CLI tools share the same data access. Inline SQL stays in handlers. Transport layers call handlers and formatters only.
2. **Testable** — handlers return plain objects; formatters are pure functions.
3. **Extensible** — new entity type needs one update to the read metadata module. Both MCP and CLI immediately support it.
4. **Consistent** — every tool follows the same architecture. Adding a new MCP tool requires three lines of handler glue.
5. **Separation clear** — read handlers return data for formatters. Write handlers return status messages. Transport layers choose the right handler for the operation.

### See also

- `ILL.LIB.HANDLER.STACK` — walkthrough of read handler orchestration
- `ILL.TOOL.HANDLER.READ` — read handler implementation walkthrough
- `TERM.PURITY.PROTOCOL` — purity level definitions and depends-on annotation
- `TERM.LIB.MODULE` — lib module conventions

## References

- Dijkstra, E.W. — *The Structure of the THE-Multiprogramming System*. Communications of the ACM, Vol. 11, No. 5, May 1968, pp. 341–346. DOI: [10.1145/363095.363143](https://doi.org/10.1145/363095.363143)
- Parnas, D.L. — *On the Criteria To Be Used in Decomposing Systems into Modules*. Communications of the ACM, Vol. 15, No. 12, December 1972, pp. 1053–1058. DOI: [10.1145/361598.361623](https://doi.org/10.1145/361598.361623)
- Dijkstra, E.W. — *On the Role of Scientific Thought* (EWD 447). 1974. URL: [https://www.cs.utexas.edu/~EWD/transcriptions/EWD04xx/EWD447.html](https://www.cs.utexas.edu/~EWD/transcriptions/EWD04xx/EWD447.html)
- Ritchie, D.M. and Thompson, K. — *The UNIX Time-Sharing System*. Communications of the ACM, Vol. 17, No. 7, July 1974, pp. 365–375. DOI: [10.1145/361011.361061](https://doi.org/10.1145/361011.361061)
- Garlan, D. and Shaw, M. — *An Introduction to Software Architecture*. In Advances in Software Engineering and Knowledge Engineering, Vol. II, World Scientific, 1993. Also CMU-CS-94-166. DOI: [10.1184/r1/6603365.v1](https://doi.org/10.1184/r1/6603365.v1)
- Wadler, P. and Peyton Jones, S. — *Imperative Functional Programming*. Proceedings of the 20th ACM SIGPLAN-SIGACT Symposium on Principles of Programming Languages (POPL 93), pp. 71–84. DOI: [10.1145/158511.158524](https://doi.org/10.1145/158511.158524)
- Martin, R.C. — *The Dependency Inversion Principle*. C++ Report, Vol. 8, No. 6, June 1996, pp. 61–66. URL: [https://web.archive.org/web/20110714224327/http://www.objectmentor.com/resources/articles/dip.pdf](https://web.archive.org/web/20110714224327/http://www.objectmentor.com/resources/articles/dip.pdf)
- Cockburn, A. — *Hexagonal Architecture (Ports and Adapters)*. 2005. URL: [https://alistair.cockburn.us/hexagonal-architecture](https://alistair.cockburn.us/hexagonal-architecture)
