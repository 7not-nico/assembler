# Epub statistics — qalc

Measurements of `ZScript.epub` computed with `qalc 5.12.0` (Qalculate). Inputs come from the `7z t` archive test and the `epub-maker-build` run.

## Inputs

```text
Compressed size    215,266 B   (BYTES from the build run)
Uncompressed size  1,026,367 B (Size: from 7z t)
Chapters           251         (h1 headings in the merged document)
Pages              125         (sidebar links from ZScript.html)
```

## Calculations

```text
Quantity              Expression                    Result
Compressed size       215266 bytes to KiB           210.221 KiB
Uncompressed size     1026367 bytes to KiB          1002.312 KiB
Compression ratio     1026367/215266                4.768×
Chapters per page     251/125                       2.008
Compression savings   100 - 215266/1026367*100      79.03%
```

## Interpretation

- The book stores ~1 MiB of HTML content in 210 KiB — the source pages repeat boilerplate (sidebar, navigation, styles), so zip compresses them well.
- Every source page averages ~2 h1 chapters, consistent with the merge stage appending full `<main>` blocks from each sidebar page.
- The 79% savings mean the epub reads as a compact single-file book; storage cost stays negligible next to the WAD assets in the launcher's `wad/`.

## Command

```bash
qalc --terse "215266 bytes to KiB"
qalc --terse "1026367/215266"
qalc --terse "251/125"
qalc --terse "100 - 215266/1026367*100"
```

Bitacora: `qalc-epub` logs under `.opencode/_bitacora/task-stdout/` (`20260806-232452-*`).
