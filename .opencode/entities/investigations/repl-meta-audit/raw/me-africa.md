# Middle East & Africa — REPL Research

**Date:** 2026-07-11
**Region:** Middle East and Africa (Israel, South Africa, Egypt, Morocco, Saudi Arabia, UAE, Turkey, Iran, Nigeria, Kenya, Ethiopia)
**Domain filters:** `.ac.il`, `.ac.za`, `.ac.eg`, `.ac.ma`, `.edu.sa`, `.ac.ae`, `.edu.tr`, `.ac.ir`, `.edu.ng`, `.ac.ke`
**Language:** English, Hebrew, Arabic, Turkish
**Rating:** WARN (3 relevant academic sources found via Exa after refinement)

**Note:** Parallel-search struggled with this region's academic domains. Switched to Exa for second pass which succeeded in finding sources from Technion (Israel), METU (Turkey), and UCT (South Africa).

## Queries

| # | Query | Tool | Result count | Rating |
|---|-------|------|-------------|--------|
| 1 | `"Read-Eval-Print Loop" OR REPL site:ac.il OR site:ac.za OR site:ac.eg OR site:ac.ma OR site:edu.sa OR site:ac.ae` | Parallel | ~6 | FAIL |
| 2 | `REPL "read eval print" site:edu.tr OR site:ac.ir OR site:edu.ng OR site:ac.ke` | Parallel | ~5 | FAIL |
| 3–9 | Various refinements (Hebrew, Turkish, Arabic, specific domains) | Parallel | ~5 each | FAIL |
| 10 | `"read-eval-print loop" OR "REPL" programming AFRICA university` | Exa | ~10 | PASS — UCT, Sathyabama found |
| 11 | `"REPL" OR "read-eval-print" MIDDLE EAST university computer science` | Exa | ~10 | PASS — Technion, METU found |
| 12 | `"REPL" OR "read-eval-print" site:ac.il Israeli university course` | Exa | ~10 | PASS — Technion RESL |
| 13 | `"read-eval-print loop" OR "REPL" site:edu.sa OR site:ac.ae OR site:edu.eg` | Exa | ~10 | FAIL — Arab universities only had general programming courses |

## Sources Fetched

| Source | Institution | Country | Key content | Methodology |
|--------|-------------|---------|-------------|-------------|
| [cs.technion.ac.il](https://csaws.cs.technion.ac.il/~yahave/blog/resl.html) | Technion — Israel Institute of Technology | Israel | RESL (Read-Eval-Synth Loop) extends REPL with program synthesis. Replaces Print with Synth. Sketch-based synthesis with holes (`??`). OOPSLA 2020 paper by Peleg, Gabay, Itzhaky, Yahav. | Peer-reviewed conference paper (ACM OOPSLA) |
| [cs.technion.ac.il](https://www.cs.technion.ac.il/he/events/view-event.php?evid=3555) | Technion — Israel Institute of Technology | Israel | CS department seminar on REPL-based program synthesis by Dr. Hila Peleg (PhD Technion, postdoc UCSD). "Program synthesis to augment programming process using read-eval-print loops (REPL)." | Academic department seminar |
| [open.metu.edu.tr](https://open.metu.edu.tr/bitstream/handle/11511/89679/12626259.pdf) | Middle East Technical University (METU) | Turkey | PhD thesis on K-12 programming education. References REPL as interactive programming concept in context of teaching text-based coding. | PhD dissertation (METU) |
| [docs.cs.uct.ac.za](https://docs.cs.uct.ac.za/java/oracle-jdk-17/docs/specs/man/jshell.html) | University of Cape Town (UCT) | South Africa | Java JShell documentation hosted on UCT CS department. Defines JShell as "interactively evaluate declarations, statements, and expressions in a read-eval-print loop (REPL)." | Technical documentation (Oracle JDK 17) on UCT CS infra |

## Gaps

- No Arabic-language REPL course materials found from Saudi, Egyptian, or UAE universities despite searching edu.sa, ac.ae, edu.eg
- Parallel-search MCP failed to crawl ME/Africa academic domains effectively — Exa succeeded where parallel could not
- Arab Gulf universities (Saudi Arabia, UAE) host programming courses on platforms like satr.tuwaiq.edu.sa but none mention REPL specifically
- Sub-Saharan Africa beyond South Africa: no sources found

## Key Takeaways

1. **Technion (Israel)** produces the strongest REPL-related research in the region — RESL (Read-Eval-Synth Loop) is a significant extension to REPL published at ACM OOPSLA
2. METU (Turkey) references REPL in CS education thesis context
3. UCT (South Africa) hosts JShell/REPL documentation on its CS department infrastructure
4. The initial FAIL rating was a tool limitation — parallel-search could not crawl these domains deeply; Exa succeeded with topical (non-domain-filtered) queries
5. Israel punches above its weight in programming language research relative to other ME/Africa countries
