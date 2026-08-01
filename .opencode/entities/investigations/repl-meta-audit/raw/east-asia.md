# East Asia — REPL Research

**Date:** 2026-07-11
**Region:** East Asia (Japan, South Korea, China, Taiwan, Hong Kong)
**Domain filters:** `.ac.jp`, `.ac.kr`, `.ac.cn`, `.edu.cn`, `.edu.hk`, `.edu.tw`
**Language:** Japanese, Korean, Chinese (Mandarin), English
**Rating:** PASS (9+ relevant academic sources)

## Queries

| # | Query | Tool | Result count | Rating |
|---|-------|------|-------------|--------|
| 1 | `REPL "read-eval-print" site:ac.jp OR site:ac.kr OR site:ac.cn OR site:edu.hk site:edu.tw` | Parallel | ~8 | WARN — OIT Japan found |
| 2 | `REPL インタラクティブ プログラミング site:ac.jp OR site:ac.kr` | Parallel | ~5 | FAIL |
| 3 | `"REPL" "read eval print" 编程 交互 site:ac.cn OR site:edu.cn` | Parallel | ~6 | FAIL |
| 4 | `"REPL" OR "read-eval-print" site:ac.cn OR site:edu.cn OR site:ac.kr OR site:edu.hk OR site:edu.tw programming` | Exa | ~10 | PASS — Korea, SJTU, CityU, NPTU |
| 5 | `REPL read eval print loop 中国 大学 编程 课程` | Exa | ~10 | PASS — NJU, XMU, Beijing Jiaotong |

## Sources Fetched

| Source | Institution | Country | Key content | Methodology |
|--------|-------------|---------|-------------|-------------|
| [oit.ac.jp](https://www.oit.ac.jp/labs/rd/rssrv/kobayashi-lab/~yagshi/lectures/pg1slide04.pdf) | Osaka Institute of Technology | Japan | Programming Exercises I lecture slides (Kobayashi & Seo). Defines REPL in Japanese: "Read-Eval-Print Loop 略して REPL". Step-by-step animated explanation of R-E-P-L cycle with Python REPL examples. | Course lecture material |
| [plrg.korea.ac.kr](https://plrg.korea.ac.kr/courses/cose215/2024_1/slides/lec2.pdf) | Korea University | South Korea | COSE215 Scala lecture slides (Park Jihyeok, 2024). Slide titled "Read-Eval-Print-Loop (REPL)". | Course lecture material |
| [cida.uos.ac.kr](https://cida.uos.ac.kr/teaching/2025_1_programming_languages/practice_1/tutorial.html) | University of Seoul | South Korea | OCaml tutorial in Korean. Defines utop as "read-eval-print-loop (REPL)" similar to Python's IDLE. Explains REPL interaction with double semicolon syntax. | Course tutorial |
| [prl.korea.ac.kr](https://prl.korea.ac.kr/courses/cose212/2023/pl-book.pdf) | Korea University | South Korea | Programming Languages textbook (Oh Hakjoo). Defines REPL as "대화형 프로그램 실행 도구" (interactive program execution tool). Uses OCaml REPL example. | University textbook |
| [ropas.snu.ac.kr](https://ropas.snu.ac.kr/~ta/4541.664A/25/tour-of-ocaml.pdf) | Seoul National University | South Korea | OCaml tutorial (Lee Jaeho). Compares UTop to "Python의 REPL". Covers UTop installation and usage. | Graduate course tutorial |
| [jhc.sjtu.edu.cn](https://jhc.sjtu.edu.cn/~yutingwang/study/functional_programming.html) | Shanghai Jiao Tong University | China | Functional Programming study guide. Mentions "OCaml programs may be directly run in an read-eval-print loop (REPL)". | Course study material |
| [download.cucdc.com](http://download.cucdc.com/wenku/0861f82675094794a0846e222d0f74a7.html) | Nanjing University | China | SICP course PPT. Defines "Read-Eval-Print Loop (REPL)" with diagram: input string → Read → expression → Eval → value → Print → output string, in a while True loop. | Course lecture material |
| [www.cs.cityu.edu.hk](https://www.cs.cityu.edu.hk/~ccha23/cs1302book/Lecture1/Introduction%20to%20Computer%20Programming.html) | City University of Hong Kong | Hong Kong | CS1302 course. Mentions REPL in context of Unicorn CPU emulator. | Course material |
| [dblab.xmu.edu.cn](https://dblab.xmu.edu.cn/blog/926/) | Xiamen University | China | Scala blog post (Lin Ziyu). Describes "REPL（Read-Eval-Print Loop，交互式解释器）" in context of Spark/Scala programming. | Academic blog / course supplement |
| [junwu.nptu.edu.tw](https://junwu.nptu.edu.tw/dokuwiki/doku.php?id=swift%3Afirstcourse) | National Pingtung University | Taiwan | Swift programming course. Two full sections on REPL: "REPL是Read-Eval-Print-Loop的縮寫，可以翻譯為「讀取-執行-輸出-循環」". Covers REPL commands, exit, examples. | Course lecture material |

## Additional References

- Chinese Wikipedia: [读取-求值-输出循环](https://zh.wikipedia.org/wiki/%E8%AF%BB%E5%8F%96-%E6%B1%82%E5%80%BC-%E8%BE%93%E5%87%BA%E5%BE%AA%E7%8E%AF)
- Korean Wikipedia: REPL entry (referenced from Korea Univ textbook)
- Japanese Wikipedia: REPL entry (referenced from OIT slides)
- CS61A Chinese translation on learncs.site: REPL explanation in Chinese

## Gaps

- No Japanese university sources beyond OIT — possibly more exist within LMS walls
- No Korean sources from top-tier universities like KAIST, POSTECH, Yonsei (though Korea Univ and SNU are both SKY-tier)
- Chinese sources from .edu.cn were hard to crawl via parallel-search — Exa found more via topical queries
- Mainland Chinese .edu.cn domains have varying accessibility depending on hosting

## Key Takeaways

1. **East Asia is the strongest region for REPL academic coverage** after NA — REPL is systematically taught across Japan, Korea, China, Taiwan, and Hong Kong
2. REPL is consistently taught as a **fundamental interactive programming concept** in CS1 courses
3. Languages vary: Japan uses Python, Korea uses OCaml/Scala, China uses Python/Scheme/Scala, Taiwan uses Swift
4. The (loop (print (eval (read)))) formulation appears in Chinese-language SICP courses (NJU)
5. Terminology is well-established in local languages: Japanese keeps "REPL", Korean uses "REPL (대화형 프로그램 실행 도구)", Chinese uses "交互式解释器" or "读取-求值-输出循环"
