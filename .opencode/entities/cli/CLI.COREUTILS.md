## Identity

- GNU Coreutils — the basic file, shell, and text manipulation utilities of the GNU operating system; the GNU Project builds it in C
- The GNU Project merges the earlier textutils, shellutils, and fileutils packages into one suite in September 2002

## Function

- Coreutils forms the expected base of every GNU/Linux system
- Each utility performs one fundamental task; over 100 commands ship in the suite
- The suite follows a common interface style: utilities accept long-named options such as `--help` and `--verbose`

## Usage

- Developers compose utilities in pipes — `cat file | grep pattern | wc -l` chains small tools into workflows
- Scripts call the utilities with long-named options for readability and portability

## Design

- The suite carries the GNU General Public License version 3, which replaces version 2 since July 2007
- Jim Meyering maintains the suite since the merge

## Ecosystem

- Alternatives include BusyBox, a single-executable C program for embedded systems
- uutils coreutils provides a Rust rewrite under the MIT license
- Many commands — cat, chmod, cp, ls, mv, rm, wc — trace their lineage to the first Unix versions

---
id: CLI.COREUTILS
title: GNU Coreutils
type: external
source: COG.COMPUTER.SCIENCE
precedes: []
tags: coreutils, gnu, file, shell, text, unix, c, cli, tool
reference:
  - title: "GNU Coreutils — Official Website"
    url: https://www.gnu.org/software/coreutils/
  - title: "GNU Coreutils — Savannah Project"
    url: https://savannah.gnu.org/projects/coreutils/
  - title: "GNU Coreutils — GitHub Mirror"
    url: https://github.com/coreutils/coreutils
  - title: "GNU Coreutils — Wikipedia"
    url: https://en.wikipedia.org/wiki/GNU_Core_Utilities
---
