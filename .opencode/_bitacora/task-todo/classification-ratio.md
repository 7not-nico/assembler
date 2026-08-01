# Classification ratio per MAX.KNOWLEDGE.CLASSIFICATION

COG:CON:DEF:TERM = 14:14:5:43 = 18.4%:18.4%:6.6%:56.6%  (qalc verified)

## Migration batches
- [ ] Batch A: COG — 12 remaining (14 total, 2 done)
- [ ] Batch B: CON — 14 items
- [ ] Batch C: DEF — 5 items
- [ ] Batch D: TERM — 43 items stay, update type field

## Each batch: create → delete → sync → verify
- [ ] create new file in target directory
- [ ] update source field per layer rules (COG→general, CON/DEF→COG.*, TERM→CON.*/DEF.*)
- [ ] delete old file from terms/
- [ ] sync target + terms
- [ ] cleanup stale term rows
- [ ] verify count: target += N, terms -= N
