# VERIFY.CROSS.REFERENCE — cross-reference sections before asserting claims

Before asserting any claim about a language's semantics, verify the claim by cross-referencing across multiple sections of the specification.

Procedure:
1. Read the relevant section of the official specification
2. Find the corresponding section in an alternate source (implementation source, alternative spec, or tutorial)
3. Compare the two descriptions for agreement
4. If they agree, note both sources in the citation
5. If they disagree, document the discrepancy — do not silently pick one
6. Only after cross-referencing may the claim be asserted in the semantic analysis file

This applies recursively: claims about the relationship between two sections require reading both sections and confirming the relationship.
