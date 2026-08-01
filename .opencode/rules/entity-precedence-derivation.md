At entity creation, derive its meaning and ring by tracing what precedes it outer→inner.

Scope: entity-level. Applies at every entity declaration.

Rule: before declaring any entity, ask "what precedes this?" and trace the derivation chain outward until a cognition dead end. The entity defaults to an unmeaning term (Ring 4). Each answered "what precedes" narrows its ring and meaning. Set `precedes:` to inner declared entities (empty if leaf). The ring layer (R1-R4) is the output of this derivation.

Cycle rule: when `precedes` declares a closed loop (traversing returns to a visited entity), the cycle detects a domain. An encompassing term must exist as the domain's bracket. The encompassing term's `source` points to the grounding concept; its `precedes` points to the cycle start. All cycle members share the same source domain concept.

Composes with `RUL.ENTITY.DERIVATION` — one of 1 entity derivation rules.
