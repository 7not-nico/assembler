# Eastern Europe — REPL Research

**Date:** 2026-07-11
**Region:** Eastern Europe (Poland, Czech Republic, Slovakia, Hungary, Romania, Bulgaria, Ukraine, Russia, Baltic states)
**Domain filters:** `.pl`, `.cz`, `.sk`, `.hu`, `.ro`, `.bg`, `.edu.ua`, `.ru`
**Language:** Polish, Russian, English
**Rating:** WARN (2 relevant academic sources after refinement)

## Queries

| # | Query | Result count | Rating |
|---|-------|-------------|--------|
| 1 | `REPL "read-eval-print" site:edu.ru OR site:ru OR site:edu.ua OR site:ua` | ~6 | FAIL |
| 2 | `REPL "read eval print" site:edu.pl OR site:pl OR site:cz OR site:sk programowanie` | ~8 | WARN — Poland hits (PJWSTK, AGH) |
| 3 | `REPL "interaktiv" site:hu OR site:ro OR site:bg OR site:lt OR site:lv OR site:ee` | ~6 | FAIL |
| 4 (refinement) | `REPL "read-eval-print loop" site:pl OR site:cz OR site:sk OR site:hu OR site:ro OR site:bg` | ~7 | FAIL |
| 5 (refinement) | `REPL "чтение-вычисление-печать" OR "цикл" site:ru OR site:edu.ru` | ~5 | FAIL — only commercial/consumer hits |

## Sources Fetched

| Source | Institution | Country | Key content | Methodology |
|--------|-------------|---------|-------------|-------------|
| [repin.pjwstk.edu.pl](https://repin.pjwstk.edu.pl/xmlui/bitstream/handle/186319/867/thesis.pdf) | PJWSTK (Polish-Japanese Academy of Information Technology) | Poland | BSc thesis "Evolutionary Program Synthesis" (Yanushevskyi, 2021). Section 3.4 defines REPL: 4 parts (read, eval, print, loop), used as interactive interpreter to bypass compile stage. Applied to CSG tree rendering. English + Polish abstract. | BSc thesis (peer-reviewed for degree) |
| [home.agh.edu.pl](https://home.agh.edu.pl/~ligeza/wiki/lib/exe/fetch.php?media=presentations%3Apython_lisp.pdf) | AGH University of Science and Technology (Kraków) | Poland | Lecture slides "Introduction to Python and Lisp" (Nowaczyk, 2009). Lists "Read-Eval-Print Loop" as key Lisp concept alongside s-expressions, macros, and list processing. | Course lecture material |

## Additional Sources (non-academic)

| Source | Country | Content |
|--------|---------|---------|
| [netology.ru](https://netology.ru/glossariy/repl) | Russia | Russian glossary definition: "REPL (read-eval-print loop) — режим среды программирования, при котором вводимые пользователем данные принимаются и выполняются" |
| [ru.wikipedia.org](https://ru.wikipedia.org/wiki/REPL) | Russia | Russian Wikipedia page: defines REPL as "цикл 'чтение — вычисление — вывод'" with links to Paul Graham's implementation |

## Gaps

- No Russian university course materials found on .edu.ru or .ru domains
- No academic sources from Czech, Hungarian, Romanian, Bulgarian, Baltic, or Ukrainian universities
- Only Poland produced results — likely due to more English-language CS content indexed internationally
- Eastern European CS curricula treat REPL as assumed knowledge (same pattern as Western Europe)

## Key Takeaways

1. REPL used in Polish CS BSc thesis (PJWSTK, Warsaw) as tool for evolutionary program synthesis
2. AGH Kraków teaches REPL as fundamental Lisp concept in its CS curriculum
3. Russian-language educational definitions exist (Netology, Wikipedia) but lack institutional depth
4. Eastern Europe mirrors the pattern: REPL is foundational CS knowledge, not a standalone research topic
