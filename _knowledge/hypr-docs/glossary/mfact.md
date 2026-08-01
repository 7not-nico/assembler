# mfact.md

Mfact is the master layout's master-window size ratio.

`mfact = 0.55` (default) means the master window occupies 55% of the screen, slaves 45%. Range [0.0-1.0]. Configured via `hl.config({ master = { mfact = 0.7 } })`; changed at runtime via layout message `hl.dsp.layout("mfact 0.7 exact")` or relative delta `mfact +0.2` / `mfact -0.2`.
