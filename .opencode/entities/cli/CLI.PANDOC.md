## Identity

- Pandoc — a universal markup converter; John MacFarlane, a UC Berkeley philosophy professor, builds it in Haskell, with the first release in August 2006
- The name combines the Greek "pan" — meaning all — with "doc" to signal its scope

## Function

- Pandoc converts a document from one markup format to another
- It reads dozens of input formats and writes even more output formats
- A CiteProc engine renders citations from BibTeX, BibLaTeX, CSL, or RIS data in styles such as APA, Chicago, or MLA

## Usage

- Writers run `pandoc input.md -o output.html` to convert between formats
- Lua filters transform the AST mid-pipeline for custom output
- Markdown-to-everything forms its most common path

## Design

- Pandoc parses input into an abstract syntax tree (AST), then renders that AST into the target format
- The two-phase design preserves headings, tables, and citations rather than formatting details

## Ecosystem

- Scholars use pandoc as a writing tool
- Publishers build workflows around it
- It stands as the standard Haskell document converter

---
id: CLI.PANDOC
title: Pandoc
type: external
source: COG.COMPUTER.SCIENCE
precedes: []
tags: pandoc, converter, markup, markdown, latex, haskell, document, cli, tool
reference:
  - title: "Pandoc — Official Website"
    url: https://pandoc.org
  - title: "Pandoc — User's Guide (Manual)"
    url: https://pandoc.org/MANUAL.html
  - title: "Pandoc — GitHub Repository"
    url: https://github.com/jgm/pandoc
  - title: "Pandoc — Wikipedia"
    url: https://en.wikipedia.org/wiki/Pandoc
---
