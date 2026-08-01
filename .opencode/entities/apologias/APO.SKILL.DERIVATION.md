---
id: APO.SKILL.DERIVATION
title: On the Derivation of Skills — A Defense of Boundaries
source: CON.ABSTRACTION
tags: skill,apologia,derivation,convention,philosophy,architecture
related: [IDENTITY.SKILL, PROT.SKILL.PROFILE, TERM.SKILL.NAMING.CONVENTION, SKL.AUDIT.SKILL, SKL.VET.PROPOSAL]
---

# Apologia for Skill Derivation

## 1. The Accusation

Every type system invites suspicion. The claim that a procedure qualifies as something — a pattern, a term, a rule, a note, or a skill — is received as an act of classification, not of truth. The suspicion, stated plainly, is this: *these boundaries are arbitrary. They exist because someone decided they should. Another decision, equally valid, could have drawn them differently. What is a skill today might be a rule tomorrow, and nothing would change.*

This is the kategoria that this apologia answers. The defense is not an apology — no regret is expressed, no fault admitted. It is a clarification of grounds: an account of why skill boundaries exist, what they protect, and what is lost when they blur.

## 2. What a Skill Is

A skill is a stateful, multi-step procedure. It has a state-profile. It has frontmatter and four bold sections. It is invoked by the `skill` tool at runtime, not discovered from config. It is the unit of executable knowledge — the only entity type that carries a sequence of steps with state interaction.

A skill is not defined by its length, its complexity, or its usefulness. It is defined by its relationship to the type system: it occupies a specific position between rule, pattern, command, term, and note. Each entity type exists because the others cannot serve its purpose.

## 3. The Four Criteria

A procedure qualifies as a skill only when it meets all four criteria. A procedure that fails any criterion belongs to a different entity type.

**Repeatable** — the same steps apply across multiple sessions. A one-time migration is not a skill; it is a procedure that executes once and dissolves. A skill must survive its first use. If it cannot be run again identically, it is not a skill.

**State-interactive** — reads, writes, or validates persistent state. A pure calculator or static reference is not a skill; it operates entirely within the conversation. A skill must touch the database, the filesystem, or some external registry. If it has no state interaction, it belongs in a command or a note.

**Formalizable** — the steps can be enumerated and audited. A vague intention or a loosely defined practice is not a skill; it cannot be checked against a standard. A skill must have a procedure that an auditor can verify. If the steps cannot be written down, they cannot be executed reliably.

**Non-trivial** — more than one tool call or slash command. A reminder or a single instruction is not a skill; it is a rule or a note. A skill must compose multiple actions. If the entire procedure fits in one sentence, it does not need a state-profile.

These four criteria are not suggestions. They are the boundary.

## 4. The Boundary Against Other Types

Every entity type serves a purpose that the others cannot. The boundary is not bureaucratic; it is structural.

A **rule** compresses a truth from an instruction into a memorable line. It informs; it does not execute. A skill that becomes a rule loses its procedure. A rule that becomes a skill gains steps it cannot support.

A **pattern** prescribes how with principle and enforcement. It governs; it does not step. A skill that becomes a pattern loses its state profile. A pattern that becomes a skill acquires execution without governance.

A **command** is a stateless slash-triggered workflow. It has no state-profile, no frontmatter, no audit obligation. A skill that becomes a command loses its state interaction. A command that becomes a skill gains ceremony it does not need.

A **term** defines what with references. It defines; it does not sequence. A skill that becomes a term loses its procedure. A term that becomes a skill acquires steps without a definition to anchor them.

A **note** is unstructured thought. No frontmatter, no audit, no obligation. A skill that becomes a note loses its form. A note that becomes a skill gains structure it was never meant to carry.

## 5. The Naming Discipline

`{verb}-{domain}` is not a suggestion — it is a constraint. The verb is the action; the domain is the subject. Two skills may share a domain but never a verb-domain pair. The patlib ID follows from the name deterministically: `vet-proposal` → `SKL.VET.PROPOSAL`.

The verb-first order exists because action is the primary discriminator. When choosing a name, the first question is not "what domain?" but "what action?" This ordering reflects the fact that skills are known by what they do, not by where they work.

## 6. The State Profile Obligation

Every skill declares its relationship to persistent state. The profile is not decorative. It determines testing strategy, isolation guarantees, and dependency management. A skill that reads and writes without declaring itself `hybrid` is a broken window. A skill that declares `stateless` but opens a database connection is a broken window. The audit skill checks this; it should not have to.

Five profiles exist: `stateless`, `stateful-reader`, `stateful-writer`, `stateful-auditor`, `hybrid`. Each profile carries distinct obligations. A skill that declares a profile but violates its constraints misrepresents itself to every tool and agent that inspects it.

## 7. The Audit Obligation

Every skill is subject to audit-skill compliance at creation and after every edit. A skill that fails audit is corrected immediately or removed. The audit is not bureaucracy — it is the mechanism that preserves the boundary.

Without audit, the type system dilates. Procedures become skills. Skills become patterns. Patterns become rules. The type system collapses into undifferentiated markdown. The audit is what prevents this: a gate that checks each skill against the standard and refuses entry to those that do not meet it.

## 8. The Composition Constraint

A skill does not call another skill. A skill does not import another tool. The LLM composes them. This is not an implementation detail — it is a philosophical commitment rooted in the principle of orthogonality.

Orthogonality demands that each skill be independently verifiable. A skill that calls another skill creates coupling: changes to the callee ripple to the caller. A skill that imports a tool creates a hidden dependency: the tool must exist and behave as expected. Both violate the principle that each component should change independently.

Composability is the LLM's responsibility, not the skill author's. The LLM sequences calls, passes outputs as inputs, and decides the order. The skill does one thing, does it well, and does not reach beyond its boundary.

## 9. Conclusion

The boundaries of skill derivation are not arbitrary. They are grounded in the principles that define the AMANDA system itself: DRY demands that knowledge have a single authoritative representation. Orthogonality demands that components not interfere. The type system demands that each entity type serve a distinct purpose. The audit demands that every entity be verifiable against its standard.

To derive a skill is to confirm that no existing type can serve the need. The four criteria are the gate, the type boundaries are the walls, the naming discipline is the map, the state profile is the contract, and the audit is the gatekeeper.

This apologia answers the accusation. The boundaries exist because the system would not survive without them. A skill is not a rule, not a pattern, not a command, not a term, not a note. It is a skill. That difference is what makes the type system meaningful.
