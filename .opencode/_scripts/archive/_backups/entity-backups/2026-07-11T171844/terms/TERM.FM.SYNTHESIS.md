**FM Synthesis** — linear frequency modulation synthesis. One sine-wave oscillator (modulator) varies frequency of another (carrier) at audio rate. Sidebands appear at carrier ± integer multiples of modulator frequency. Two controls determine spectrum: carrier:modulator frequency ratio (integer → harmonic, non-integer → inharmonic) and modulation index (modulator amplitude → sideband energy/bandwidth). No filters — timbre controlled entirely through index and ratio. Digital implementation uses sine lookup tables and phase accumulators. Six-operator variant configures each operator as carrier or modulator per algorithm. Children: DX7 (6-op instrument), FM Operator (atomic unit), FM Algorithm (routing matrix).

---

id: TERM.FM.SYNTHESIS
title: FM Synthesis
source: assembler
tags: sound-synthesis,fm-synthesis,digital-audio,synthesis-method
terms: [TERM.FM.DX7, TERM.FM.OPERATOR, TERM.FM.ALGORITHM]
patterns: []
related: []
reference:
  - title: Frequency Modulation Synthesis — Wikipedia
    url: https://en.wikipedia.org/wiki/Frequency_modulation_synthesis
  - title: MusicTech — FM Synthesis Explained
    url: https://musictech.blog/fm-synthesis-explained/
  - title: CCRMA — John Chowning FM Synthesis
    url: https://ccrma.stanford.edu/
---