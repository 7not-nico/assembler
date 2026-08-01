//! assembler_core — functional core for the AMANDA assembler
//! Ring 0 (PURE): pure functions, no I/O, no side effects
//!
//! Naming per precepts:
//!   Structs: singular abstract noun in Upper (PascalCase)
//!   Functions: singular concrete noun in lower (lowercase)
//!   Methods: camelCase with action verbs
//!   Constants: singular descriptor in PascalCase, no verbs
//!   Variables: singular descriptor in lowercase, no verbs
//!   No gerunds, no nominalizations

// ── Ring 0: Pure ──
#[path = "r0-parse.rs"]             pub mod parse;
#[path = "r0-id_routing.rs"]        pub mod id_routing;
#[path = "r0-ring_topology.rs"]     pub mod ring_topology;
#[path = "r0-type_constants.rs"]    pub mod type_constants;
#[path = "r0-rank.rs"]              pub mod rank;
#[path = "r0-validate.rs"]          pub mod validate;
#[path = "r0-report.rs"]            pub mod report;
#[path = "r0-violation.rs"]         pub mod violation;
#[path = "r0-safe_commands.rs"]     pub mod safe_commands;
#[path = "r0-burst.rs"]             pub mod burst;
#[path = "r0-entity_text.rs"]       pub mod entity_text;
#[path = "r0-spec_types.rs"]        pub mod spec_types;
#[path = "r0-spec_audit.rs"]        pub mod spec_audit;
#[path = "r0-structs.rs"]           pub mod structs;
#[path = "r0-arxiv_types.rs"]       pub mod arxiv_types;
#[path = "r0-arxiv_parse.rs"]       pub mod arxiv_parse;
#[path = "r0-arxiv_format.rs"]      pub mod arxiv_format;
#[path = "r0-audit_format.rs"]      pub mod audit_format;
#[path = "r0-compartment_audit.rs"] pub mod compartment_audit;
#[path = "r0-compartment_format.rs"]pub mod compartment_format;
#[path = "r0-entity_format.rs"]     pub mod entity_format;
#[path = "r0-spec_format.rs"]       pub mod spec_format;
#[path = "r0-spec_rules.rs"]        pub mod spec_rules;
#[path = "r0-validate_persons.rs"]  pub mod validate_persons;
#[path = "r0-validate_refs.rs"]     pub mod validate_refs;
