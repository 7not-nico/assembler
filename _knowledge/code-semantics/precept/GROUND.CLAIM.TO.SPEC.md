# GROUND.CLAIM.TO.SPEC — ground every claim in an adjacent spec quote

Every semantic assertion in a role file must be immediately preceded by the spec paragraph that supports it. No claim stands alone without its grounded reference.

## Structure

Each section in a role file follows this order:

1. Section header with spec section reference in parentheses: `### Concept name (§Spec Section)`
2. Blockquote `>` containing the verbatim or trimmed spec paragraph
3. Analysis paragraph that interprets or restates the spec claim
4. Optional code example demonstrating the concept

## Example

```
### Method lookup chain (§Method Lookup)

> When you send a message, Ruby looks up the method that matches the name of
> the message for the receiver. Methods are stored in classes and modules so
> method lookup walks these, not the objects themselves.

Ruby dispatches by walking the class ancestry chain — prepended modules,
the class itself, included modules, then repeat for each superclass.
```

The blockquote is not optional. It is the ground. Without it, the analysis paragraph is speculation.

## Rules

1. Every `###` section must reference its spec section in the header.
2. Every section must begin with a `>` blockquote from that spec section.
3. The blockquote must be from the official language specification, not a tutorial or blog.
4. Analysis paragraphs restate or interpret the blockquote — they do not introduce unsupported claims.
5. The YAML frontmatter `sources` list must include the URL for each referenced section.

## What grounding prevents

- Claims from memory without verification
- Plausible-sounding but incorrect assertions about language behavior
- Analysis that drifts from what the spec actually says
- Orphan claims that cannot be traced back to a source paragraph

Composes with: SHOW.SPEC.EXTRACT.FIRST, CITE.SOURCE.CROSSCHECK, PREFER.OFFICIAL.REFERENCE, WRITE.BROWSER.FIRST
