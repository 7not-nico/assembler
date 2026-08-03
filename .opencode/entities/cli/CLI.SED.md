## Identity

- Sed — a stream editor that transforms text via a script in a compact programming language; Lee E. McMahon of Bell Labs builds it, with the first appearance in Version 7 Unix
- The name abbreviates "stream editor"; its origin extends grep's `g/re/p` into a substitution analogue, `g/re/s`

## Function

- Sed processes text line by line in a single pass
- It applies operations such as substitution, deletion, insertion, and printing
- It supports regular expressions, one of the earliest tools to do so

## Usage

- Users run `sed 's/old/new/' file` to replace text
- They pipe streams through sed for filtering
- GNU sed adds extensions such as in-place editing with `-i`, extended regex with `-E`, and strict POSIX mode with `--posix`

## Design

- Sed draws its scripting features from the interactive editor `ed` (1971) and the earlier `qed` (1965–66)
- It reads each line into a pattern space and applies commands in sequence

## Ecosystem

- Perl and AWK carry its regex syntax and substitution operators
- It remains a fixture of shell pipelines for text processing

---
id: CLI.SED
title: Sed
type: external
source: COG.COMPUTER.SCIENCE
precedes: []
tags: sed, stream, editor, text, regex, unix, c, cli, tool
reference:
  - title: "Sed — GNU Manual"
    url: https://www.gnu.org/software/sed/manual/sed.html
  - title: "Sed — Wikipedia"
    url: https://en.wikipedia.org/wiki/Sed
  - title: "Sed — Linux Manual Page"
    url: https://man7.org/linux/man-pages/man1/sed.1.html
  - title: "Sed — An Introduction and Tutorial (Grymoire)"
    url: https://www.grymoire.com/Unix/Sed.html
---
