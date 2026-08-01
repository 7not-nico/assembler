# SECTION.BEFORE.WRITE — present each section's spec extract before writing

Each section of a role file must be presented in conversation — spec extract first, analysis second — before any file content is written. The conversation acts as a review gate for every grounded claim.

## Procedure

1. Present the spec blockquote for the section in conversation: `> "spec paragraph verbatim"`
2. State the analysis claim derived from it
3. Wait for user approval before including it in the file
4. Proceed to the next section only after approval

## Example

Agent presents:
```
> The default input and pattern-searching space. The following pairs are equivalent:
>   while (<STDIN>) { print; }     # $_ is implicit
>   while ($_ = <STDIN>) { print $_; }

Claim: $_ is the implicit Subject for input and pattern matching.
Proposing section: "Default subject: $_" with comparison of implicit vs explicit forms.
```

User approves → section goes into the file. User corrects → section adjusts.

## What this prevents

- Writing large blocks of analysis that contain unsupported claims
- Mixing grounded and speculative statements in the same section
- Writing an entire file that needs significant rework because its sections were never individually reviewed

Each section stands on its own spec ground. No section is written without its blockquote being conversationally approved first.

Composes with: SHOW.SPEC.EXTRACT.FIRST, GROUND.CLAIM.TO.SPEC, DRAFT.ONE.ROLE.AT.TIME
