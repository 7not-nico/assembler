---
id: REF.PERSON.TIMELINE
title: "Person Event Timeline — Seed-Driven Year-Based Events"
source: PROT.PERSON.SCHEMA
related: [PROT.PERSON.SCHEMA, PROT.SCHEMA.DATE.PRECISION, PROT.SCHEMA.FOLDER]
summary: "Person events are defined in seed data (_schemas/seeds/02-events.sql) and linked via person_events junction table. Event definitions are a controlled vocabulary; person_events.description overrides events.title for person-specific narrative."
ref: "Events live in _schemas/seeds/02-events.sql. person_events table stores person-event links with year, month, day, location, description. PRIMARY KEY (person_id, event_id, year) allows repeat instances. syncPersons writes persons table only; events are seed-maintained."
tags: [entity, person, timeline, event, schema, seed, data]
---

Events defined in seed data, linked via `person_events` junction table. Event catalog is a controlled vocabulary; person-specific narrative stored in the link.

## Protocol

1. **Events live in seed data** — event definitions are stored in `events(id TEXT PRIMARY KEY, title TEXT REQUIRED)` table, populated by `_schemas/seeds/02-events.sql`. Person–event links are stored in `person_events(person_id, event_id, year, month, day, location, description)`, where `description` overrides the canonical `events.title` for person-specific narrative. Sort order per PROT.SCHEMA.DATE.PRECISION: `ORDER BY year ASC, month ASC NULLS LAST, day ASC NULLS LAST`. PRIMARY KEY `(person_id, event_id, year)` allows repeat instances of the same event type.

2. **Sync persons only** — `syncPersons` writes to the `persons` table only. Events are maintained in seed files; frontmatter excluded.

## Schema

### person_events table

| Column | Type | Notes |
|--------|------|-------|
| person_id | TEXT REQUIRED | FK → persons(id) |
| event_id | TEXT REQUIRED | FK → events(id) |
| year | INTEGER REQUIRED | Calendar year |
| month | INTEGER | Month 1-12 (per PROT.SCHEMA.DATE.PRECISION) |
| day | INTEGER | Day 1-31 (per PROT.SCHEMA.DATE.PRECISION) |
| location | TEXT | Where the event took place |
| description | TEXT | Person-specific narrative; overrides events.title when non-NULL |
| PRIMARY KEY | (person_id, event_id, year) | Unique per person per event type per year |

## Gotchas

| Antipattern | Detection | Redirect |
|-------------|-----------|----------|
| Events in frontmatter | Person file has `events:` key in frontmatter | Move event data to `_schemas/seeds/02-events.sql` per PROT.SCHEMA.DATE.PRECISION |

## Enforcement

`initDB()` loads seed files including event definitions and person-event links. `syncPersons` writes only the `persons` table. `read-validate` verifies person frontmatter fields (no events in frontmatter). `read-projection` shows person detail with rendered events via JOIN to `events` table, sorted per PROT.SCHEMA.DATE.PRECISION.

## Applicability

All person entities in `.opencode/entities/persons/`. Applies when a person entity has a timeline of events.

## See also

- `ILL.PERSON.EVENT.CREATE` — seed-driven event creation walkthrough
- `PROT.PERSON.SCHEMA` — person entity identity and subtypes
- `PROT.SCHEMA.DATE.PRECISION` — temporal precision schema for event month/day fields
- `PROT.SCHEMA.FOLDER` — seed file placement convention
- `PER.EDSGER.W.DIJKSTRA` — first physical person entity with event timeline
- `PER.ACM` — first jurisdictional person entity with event timeline
