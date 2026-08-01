# SPEECH.GROUNDED.EXTRACT — communicate through the extracted text

Communication grounds in the extracted `*.html` text. Every assertion references the full-text extraction from `browser_evaluate`, not a paraphrase, a snapshot summary, or inference from memory.

Procedure:
1. Present the extracted page text as a conversation block — labeled `## Extracted:` with section anchor
2. Follow extraction with `### Semantic Argument` — each claim cites a specific line or pattern from the extracted text
3. When cross-referencing, quote the extracted text verbatim, not a reformulation
4. If the extracted text lacks evidence for a claim, mark the claim as "inferred — not grounded in extracted text"
5. Conclude each analysis with a verdict: whether the extraction adds new semantic primitives or confirms existing ones

The extracted text is the authoritative speech reference. Arguments that cannot cite a line from the extraction are speculation and must be flagged as such.

Grounds speech + arguments in the page's actual content. Prevents drift between what the spec says and what the analysis asserts.

Composes with: EXTRACT.EVALUATE.ARGUE, SHOW.SPEC.EXTRACT.FIRST, GROUND.CLAIM.TO.SPEC
