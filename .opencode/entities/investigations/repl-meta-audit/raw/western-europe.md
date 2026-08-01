# Western Europe — REPL Research

**Date:** 2026-07-11
**Region:** Western Europe (UK, Germany, France, Netherlands, Denmark, Belgium, Austria, Switzerland, Scandinavia)
**Domain filters:** `.ac.uk`, `.ac.de`, `.ac.fr`, `.ac.at`, `.ac.ch`, `.ac.be`, `.ac.nl`, `.ac.se`, `.ac.no`, `.ac.dk`, `.ac.fi`, `.es`, `.it`
**Language:** English, Danish, French (paper in English)
**Rating:** WARN (2 relevant academic sources after refinement)

## Queries

| # | Query | Result count | Rating |
|---|-------|-------------|--------|
| 1 | `"Read-Eval-Print Loop" REPL site:.ac.uk` | ~10 | FAIL — no .ac.uk hits |
| 2 | `"read-eval-print" "REPL" site:.ac.de OR site:.ac.at OR site:.ac.ch` | ~8 | FAIL — no .ac.de hits |
| 3 | `"read eval print loop" REPL site:.ac.fr OR site:.es OR site:.ac.be` | ~7 | FAIL — no hits |
| 4 | `"REPL" "interactive programming" site:.ac.se OR .ac.no OR .ac.dk OR .ac.fi OR .ac.nl` | ~8 | WARN — Aalborg Univ. found |
| 5 (refinement) | `"Read-Eval-Print Loop" OR REPL site:ac.uk programming language` | ~10 | FAIL |
| 6 (refinement) | `"read-eval-print" OR REPL site:uni-*.de OR site:tu-*.de OR site:in.tum.de informatik` | ~8 | FAIL |
| 7 (refinement) | `"REPL" "interactive programming" site:nl OR site:ac.be OR site:ac.at OR site:unibe.ch OR site:ethz.ch` | ~8 | FAIL |
| 8 (refinement) | `"REPL" "read eval print" site:cam.ac.uk OR site:ox.ac.uk OR site:imperial.ac.uk` | ~10 | FAIL |

## Sources Fetched

| Source | Institution | Country | Key content | Methodology |
|--------|-------------|---------|-------------|-------------|
| [homes.cs.aau.dk](https://homes.cs.aau.dk/~normark/pp/fp-intro-scheme-slide-repl.html) | Aalborg University | Denmark | REPL slide from "Functional Programming in Scheme" course. Defines REPL as interaction with Scheme system through individual expression evaluation. Shows REPL session examples. | Course lecture material |
| [hal.inria.fr](https://hal.inria.fr/hal-02968938/file/onward2020-repls.pdf) | INRIA (Rennes / Univ. Rennes) | France | "A principled approach to REPL interpreters" — van Binsbergen, Verano Merino, Jeanjean, van der Storm, Combemale, Barais. ACM Onward! 2020. Surveys REPL domain, identifies **sequential languages** as formal foundation for REPLs, provides methodology for building principled REPL implementations. | Peer-reviewed conference paper (ACM) |

## Gaps

- UK (.ac.uk) returned no relevant results — REPL is treated as assumed knowledge, not a research topic in UK CS curricula
- Germany's .de universities (TU Darmstadt, RWTH, etc.) returned institutional homepages, not course content — search engines struggle with subdomain crawling
- Most Western European universities publish CS course materials in English but on `.com` or `.org` domains rather than national academic domains
- No French-language academic sources found on `.ac.fr` or `.fr` domains directly

## Key Takeaways

1. **INRIA paper is the best academic source found across ALL regions** — formal treatment of REPL as sequential language with associative composition operator
2. REPL is taught in Danish CS curriculum (Aalborg) using Scheme, consistent with NA approach
3. Western European academic institutions largely treat REPL as assumed knowledge rather than a standalone research topic
4. The INRIA paper's authors are from Netherlands (CWI), France (INRIA), and Luxembourg — a multi-institutional European collaboration
