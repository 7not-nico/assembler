**Signed and Unsigned** — whether a binary integer type interprets its most significant bit as a sign or as part of magnitude.

Signed types reserve the most significant bit for sign (0 = positive, 1 = negative) and represent negative values via two's complement. Unsigned types use all bits for magnitude only — the range shifts upward.

Same bit pattern, different interpretation. `0xFF` as `int8` is `-1`; as `uint8` it is `255`. The bits do not change — the interpretation does.

Signed and unsigned are not invented. They are a discovered distinction in binary representation. They exist in every digital system that represents integers. Two's complement dominates because addition circuits work identically for signed and unsigned — no special hardware needed.

---
id: CON.SIGNED.UNSIGNED
mode: theoretical
title: Signed and Unsigned
source: COG.COMPUTER.SCIENCE
tags: computer-science,data-types,binary,representation

---
