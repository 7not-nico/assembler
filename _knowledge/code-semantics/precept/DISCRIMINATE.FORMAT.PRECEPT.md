# DISCRIMINATE.FORMAT.PRECEPT — put format definitions in format/, procedures in precept/

Format definitions and precepts serve different purposes. Place each in its correct directory.

`format/` holds structural rules — field enumerations, template shapes, syntax constraints, naming conventions. A format file answers "what shape must this artifact take?" Example: `FRONTMATTER.ROLE.FILE.md` — ten frontmatter fields with types and examples.

`precept/` holds workflow procedures — research-then-write cycles, sequential steps, ordering constraints. A precept answers "in what order must these actions execute?" Example: `DRAFT.ONE.ROLE.AT.TIME.md` — write one role per cycle, wait for review.

Decision rule: content that defines a structure or template goes in `format/`. Content that defines a process or procedure goes in `precept/`. If the content can be used as a checklist, it is a precept. If it can be used as a reference card, it is a format.

Composes with: none.
