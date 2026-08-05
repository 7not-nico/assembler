---
id: MORPHISM.VALIDATED.ARGUMENT.LIST
title: Validated Argument List — Required, Enumerated, Named Error
layer: morphism/
purpose: "A required argument validated against an enumerated valid-list — the error names the valid set, so a caller sees the choices without consulting docs."
naming: validated-argument-list.md
tags: [morphism, argument, validation, valid-list, required, error]
status: active
---
# VALIDATED-ARGUMENT-LIST.md

**Layer:** morphism/
**Naming:** `validated-argument-list.md` — code morphism, reusable structure.
**Composes with:** `morphism/atomic-tool-contract.md`; derived from `study/` + `fixture/` proof.

## Morphism

A required argument validates against an enumerated valid-list; missing and invalid values both fail with an error that names the valid set — the caller sees the choices without consulting docs.

## Structure

```bash
VALID_LIST="a b c d"                          # the enumerated set (from the schema)
[ -n "$ARG" ] || { echo "ERROR $NAME required: one of ${VALID_LIST// /, }" >&2; exit 1; }
case " $VALID_LIST " in
  *" $ARG "*) ;;
  *) echo "ERROR invalid $NAME '$ARG' — valid: ${VALID_LIST// /, }" >&2; exit 1 ;;
esac
```

Invariant: the argument is required (no silent default); the valid-list is the single source of truth; both failure modes exit 1 and name the valid set; the list comes from the schema, never hardcoded.

## Verification

Call without the argument — `ERROR ... required: one of a, b, c, d`; call with a value outside the list — `ERROR invalid ... 'x' — valid: a, b, c, d`; call with a valid value — proceeds.

## Instance

`instantiator/romsfun/browse-romsfun.sh` console argument (2026-08-05) — replaced the silent `CONSOLE="super-nintendo"` default; the 12-slug valid-list comes from `SCHEMA_CONSOLE_VALID`. Commit `8ea2bc5`.
