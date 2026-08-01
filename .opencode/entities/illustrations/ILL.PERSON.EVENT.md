---
id: ILL.PERSON.EVENT
title: "Person Event Timeline — Seed-Driven Event Creation"
source: PROT.PERSON.SCHEMA
summary: "Walkthrough of creating a person event timeline: define event type in seed SQL, link via person_events junction table with year-based sort order, display via read-projection JOIN."
illustration: "A new person event (PhD award) requires three steps: add event definition to 02-events.sql, insert person_events link row with year/location/description, verify via read-projection which JOINs events to persons."
illustrates: [REF.PERSON.EVENT.TIMELINE]
tags: person,walkthrough,event,timeline,seed,schema
related: [PROT.PERSON.SCHEMA, REF.SCHEMA.DATE.PRECISION]
---
## Context

A new person entity `PER.JANE.DOE` needs a timeline. The first event is receiving a PhD in 2010. The event system requires three steps: event definition, person-event link, verification.

## Walkthrough

### Step 1: Define the event type

Add a row to `_schemas/seeds/02-events.sql`:

```sql
INSERT OR REPLACE INTO events (id, title) VALUES
  ('EVT.PHD.AWARD', 'Doctoral Degree Awarded');
```

The `events` table is a controlled vocabulary. Event types are reusable across persons — `EVT.PHD.AWARD` can link to any person.

### Step 2: Link the event to the person

Add a `person_events` row:

```sql
INSERT INTO person_events (person_id, event_id, year, month, day, location, description)
VALUES (
  'PER.JANE.DOE',
  'EVT.PHD.AWARD',
  2010,
  6,
  15,
  'MIT',
  'PhD in Computer Science'
);
```

The `description` field stores person-specific narrative. When `description` is non-NULL, it overrides the canonical `events.title` for display. The sort order follows `ORDER BY year ASC, month ASC NULLS LAST, day ASC NULLS LAST`.

### Step 3: Verify the timeline

`read-projection` renders the timeline:

```
PER.JANE.DOE — Jane Doe
  2010-06-15: PhD in Computer Science — MIT
```

The JOIN across three tables (`persons → person_events → events`) produces the sorted timeline.

## Schema in use

```
events              person_events          persons
┌──────────┐       ┌────────────────┐     ┌──────────┐
│ id: EVT  │──┐    │ person_id      │────▶│ id: PER  │
│ title    │  │    │ event_id       │     │ title    │
└──────────┘  └────│ year (PK)      │     │ subtype  │
                   │ month          │     └──────────┘
                   │ day            │
                   │ location       │
                   │ description    │
                   │ PK: (pid, eid, year)
                   └────────────────┘
```

## Key insight

Decoupling event definitions from person entities enables event reuse across persons. `EVT.PHD.AWARD` links to both `PER.JANE.DOE` (PhD 2010, MIT) and `PER.JOHN.SMITH` (PhD 2005, Stanford). Each link carries its own year, location, and description — the event type is shared, the instance is specific.

## See also

- `REF.PERSON.EVENT.TIMELINE` — the event timeline protocol this illustrates
- `PROT.PERSON.SCHEMA` — person entity identity and subtypes
- `REF.SCHEMA.DATE.PRECISION` — temporal precision schema for event month/day fields
- `REF.SCHEMA.FOLDER` — seed file placement convention
