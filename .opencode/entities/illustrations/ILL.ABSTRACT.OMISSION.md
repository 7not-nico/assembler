---
id: ILL.ABSTRACT.OMISSION
title: "Abstract Omission Walkthrough — Cleaning a Draft Abstract"
source: SPEC.ENTITY.DISTINCTION.BOUNDARY
summary: "Walkthrough of reviewing a draft research abstract against the omission rules — removing citations, trimming background, defining acronyms, and aligning claims with data."
illustration: "A draft abstract contains citations, undefined acronyms, excessive background, and a claim absent from the full paper. Each violation triggers a fix per the omission rules."
tags: writing,academic,abstract,walkthrough,research
related: [CON.ABSTRACT]
---

## Context

A draft abstract for a findings paper needs review before submission. The omission rules provide a structured checklist: remove citations from the abstract body, trim excessive background, define acronyms on first use, and align claims with the full paper's data. This walkthrough traces each violation through to resolution.

## Walkthrough

### Step 1: Remove citations from the abstract body

OMISSION rule 3: citations do not belong in an abstract — they break the reader's flow and compete with the paper's own claims for attention.

**Before:** "Recent work has shown that transformers (Vaswani et al., 2017) achieve state-of-the-art results on biological sequence modeling (Mao et al., 2025)."

**After:** "Transformers achieve state-of-the-art results on biological sequence modeling."

Citations removed. Attribution moves to the full paper body where the context can accommodate them.

### Step 2: Trim excessive background

OMISSION rule 2: background information that any reader of the venue already knows dilutes the contribution signal.

**Before:** "Proteins are linear chains of amino acids that fold into three-dimensional structures. Predicting these structures from sequence alone has been a long-standing challenge in computational biology."

**After:** "Protein structure prediction remains a central challenge in computational biology."

Deleted: the chain-of-amino-acids definition — obvious to the venue audience. The gap between sequence and structure is the known context.

### Step 3: Define acronyms on first use

OMISSION rule 5: undefined acronyms isolate readers outside the subfield.

**Before:** "mRNA therapeutics require precise UTR design for cell-specific expression."

**After:** "Messenger RNA (mRNA) therapeutics require precise untranslated region (UTR) design for cell-specific expression."

Both `mRNA` and `UTR` expanded on first use. Subsequent mentions use the acronym alone.

### Step 4: Align claims with data

OMISSION rule 4: every claim in the abstract must have corresponding evidence in the full paper body.

**Claim:** "RNALens achieves 15% improvement over existing methods."

**Evidence check:** Results table shows 15% improvement on the HEK293T cell line. The abstract says "achieves superior performance" across multiple cell types. The claim overstates the scope.

**Fix:** "RNALens achieves 15% improvement over existing methods on HEK293T cells, with consistent gains across muscle tissue."

Scope narrowed to match the data. The claim now exactly matches the results table.

### Step 5: Verify alignment

The cleaned abstract:
- Zero citations
- One sentence of background, trimmed to the venue's knowledge baseline
- Two acronyms expanded on first use
- Claim scope matches the results table

All omission rules satisfied. The abstract now passes the checklist.

## See also

- `CON.ABSTRACT` — abstract definition and structural requirements
