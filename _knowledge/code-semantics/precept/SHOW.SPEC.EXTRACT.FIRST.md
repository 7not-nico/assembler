# SHOW.SPEC.EXTRACT.FIRST — show spec extract in conversation before semantic analysis

Writing a language semantic analysis file requires first locating the relevant specification paragraph, extracting its text, and presenting it in the conversation for user review.

Procedure:
1. Navigate to the official language specification via Playwright
2. Locate the section that defines the language's execution or evaluation model (the anchor for Subject-Object-Action tripartition analysis)
3. Extract the exact paragraph text from the specification
4. Present the paragraph text in the conversation for user review
5. Write the semantic analysis file only after user approves the extract

The spec paragraph must be visible verbatim in the conversation before the analysis file is written. This replaces speculation with grounded reference.

Composes with: WRITE.BROWSER.FIRST, CITE.SOURCE.CROSSCHECK, PREFER.OFFICIAL.REFERENCE
