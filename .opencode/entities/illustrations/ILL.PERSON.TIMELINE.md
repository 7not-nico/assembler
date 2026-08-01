---
id: ILL.PERSON.TIMELINE
title: "Person Timeline Create — Entity and Event Setup"
source: PROT.PERSON.SCHEMA
summary: "Walkthrough of creating a person entity with a year-based timeline — .md file for identity, seed data for events, junction links."
illustration: "A new person entity PER.ALAN.TURING stores identity in .md frontmatter. Events defined in seed SQL and linked via person_events junction table."
illustrates: [PROT.PERSON.SCHEMA]
tags: person,timeline,walkthrough,entity,events,seed
related: [REF.SCHEMA.DATE.PRECISION, SPEC.ENTITY.ROUTING.TABLE, PROT.SCHEMA.FORMAT]
---
## Context

A new person entity for Alan Turing needs to be added to the system. The entity needs identity metadata (name, type) and a timeline of key events. Events are shared — some may link to other persons or organizations.

## Walkthrough

1. Create the person `.md` file at `.opencode/entities/persons/alan-turing.md`. The frontmatter stores identity and metadata only — no inline events.

```yaml
---
id: PER.ALAN.TURING
title: "Alan Turing"
subtype: physical
source: assembler
tags: [mathematics, computer-science, cryptography]
---
```

2. Add a biography in the body text after the closing `---`. The body provides narrative detail beyond what the timeline captures.

3. Define events in `_schemas/seeds/02-events.sql`. Each event has an `id` and `title`. Event definitions are reusable across persons.

```sql
INSERT OR REPLACE INTO events (id, title) VALUES
  ('EVT.BIRTH', 'Birth'),
  ('EVT.PHD', 'Received PhD'),
  ('EVT.AWARD.TURING', 'Received ACM Turing Award');
```

4. Link events to the person in the same seed file. The `person_events` table stores the person-event link with year and optional location.

```sql
INSERT OR REPLACE INTO person_events (person_id, event_id, year, location, description) VALUES
  ('PER.ALAN.TURING', 'EVT.BIRTH', 1912, 'London, UK', NULL),
  ('PER.ALAN.TURING', 'EVT.PHD', 1938, 'Princeton, USA', 'PhD from Princeton University under Alonzo Church');
```

5. Run `write-sync --type persons` to sync the person to patlib. The events are loaded by `initDB()` from seed files.

6. Verify by running `read-projection --type persons --id PER.ALAN.TURING` to see the person detail with rendered timeline.

## Key insight

Events are decoupled from person entities. The same event type (`EVT.PHD`) can link to multiple persons. A person's `person_events.description` overrides the canonical `events.title` for person-specific narrative. The seed-driven approach keeps events queryable and reusable while the `.md` file stays focused on identity.

## See also

- `PROT.PERSON.SCHEMA` — abstract person entity rules
- `REF.SCHEMA.DATE.PRECISION` — temporal precision for event dates
- `PROT.SCHEMA.FORMAT` — seed file format
- `SPEC.ENTITY.ROUTING.TABLE` — PER.* prefix registration
