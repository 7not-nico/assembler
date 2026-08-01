# Schema Seeds — `schema/*.sql`

Prefix follows PROT.SCHEMA.FORMAT:
- `ddl.sql` — DDL (unnumbered, runs first)
- `{NN}-{type}.sql` — upsert per entity type, numbered by knowledge ring

## Seed files

| File | Entity type | Ring | Fields |
|------|-------------|------|--------|
| `ddl.sql` | — | — | — |
| `00-maxims.sql` | maxims | architectonic R0 | 9 |
| `00-persons.sql` | persons | chronicle R0 | 5 |
| `01-cognitions.sql` | cognitions | encyclopedic R1 | 7 |
| `01-abstractions.sql` | abstractions | architectonic R1 | 6 |
| `01-linguistics.sql` | linguistics | architectonic R1 | 6 |
| `01-apologias.sql` | apologias | chronicle R1 | 5 |
| `01-investigations.sql` | investigations | chronicle R1 | 5 |
| `02-concepts.sql` | concepts | encyclopedic R2 | 9 |
| `02-definitions.sql` | definitions | encyclopedic R2 | 11 |
| `02-taxonomies.sql` | taxonomies | encyclopedic R2 | 8 |
| `02-archives.sql` | archives | chronicle R2 | 10 |
| `02-notes.sql` | notes | chronicle R2 | 3 |
| `03-terms.sql` | terms | encyclopedic R3 | 8 |
| `03-biology.sql` | biology | encyclopedic R3 | 8 |
| `03-nexus.sql` | nexus | architectonic R3 | 10 |
| `04-protocols.sql` | protocols | architectonic R4 | 11 |
| `05-patterns.sql` | patterns | architectonic R5 | 10 |
| `06-illustrations.sql` | illustrations | architectonic R6 | 8 |
| `06-references.sql` | references | architectonic R6 | 7 |
