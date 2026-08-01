**FM Operator** — atomic building block of FM synthesis. Self-contained unit combining sine-wave oscillator, amplifier, and envelope generator. Configurable per algorithm as carrier (output routed to audio) or modulator (output routed to phase input of another operator). Frequency specified as ratio relative to base pitch (integer → harmonic, non-integer → inharmonic). DX7-style envelope: 8-parameter rate/level (R1–R4, L1–L4). Modulator output level controls modulation index → harmonic complexity. Self-feedback enabled per operator (scaled 0–7). Phase modulation input for operator chaining.

---

id: TERM.FM.OPERATOR
title: FM Operator
source: assembler
tags: sound-synthesis,fm-synthesis,digital-audio,operator
terms: [TERM.FM.SYNTHESIS, TERM.FM.DX7, TERM.FM.ALGORITHM]
patterns: []
related: []
reference:
  - title: Synths.pw FM Op Module
    url: https://synths.pw/modules/fm-operator
  - title: Architolk Operators Carriers and Modulators
    url: https://docs.architolk.nl/dxfm2/operators
  - title: MusicTech FM Synthesis Explained
    url: https://musictech.blog/fm-synthesis-explained/
---