# Protocol violations found by atomic scripts

## 6 protocols missing ## Gotchas section

| Protocol | Missing section |
|---------------------------------|----------------|
| PROT.LINGUISTIC.NOTATION | ## Gotchas |
| PROT.META.COMPOSITION  | ## Gotchas |
| PROT.PLUGIN.LIFECYCLE | ## Gotchas |
| PROT.SCHEMA.AUGMENT  | ## Gotchas |
| PROT.SEARCH.EMBEDDING   | ## Gotchas |
| PROT.TOOL.MODEL     | ## Gotchas |

## 14 missing required body sections

| Protocol | Missing |
|---------------------------------|--------------------------|
| PROT.ILLUSTRATION.CROSSREF.SCOPE | ## Applicability |
| PROT.LIB.CONTRACT.ENFORCEMENT    | ## Applicability |
| PROT.LINGUISTIC.NOTATION  | ## Protocol, ## Enforcement |
| PROT.META.COMPOSITION   | ## Protocol, ## Enforcement |
| PROT.PLUGIN.LIFECYCLE | ## Applicability |
| PROT.SCHEMA.AUGMENT    | ## Protocol, ## Enforcement |
| PROT.SEARCH.EMBEDDING     | ## Enforcement |
| PROT.SEARCH.QUERY         | ## Protocol, ## Applicability |
| PROT.TOOL.HOOKS           | ## Applicability |
| PROT.TOOL.PLUGIN.STRUCTURE       | ## Applicability |

## 1 invalid enforcement

| Protocol | Current | Expected |
|--------------------------|-------------|-------------------------------|
| PROT.META.DOMAIN | Code review | Tool, Convention, or Review |

## Scripts used

- `r1-protocol-body-gotchas.rb`
- `r1-protocol-body-sections.rb`
- `r1-protocol-frontmatter-enforcement.rb`
- `r1-protocol-frontmatter-status.rb`
- `r1-protocol-frontmatter-tags.rb`

## Action items (tomorrow)

1. Add ## Gotchas to 6 protocols
2. Add missing sections to 9 protocols
3. Fix PROT.META.DOMAIN enforcement from "Code review" to "Review"
