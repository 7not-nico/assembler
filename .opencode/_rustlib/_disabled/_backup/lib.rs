//! assembler_core — functional core for the AMANDA assembler
//! Organized by ring level per SPEC.CODE.RING.TOPOLOGY.
//!
//! Ring 0 (PURE): pure functions, no I/O, no side effects
//! Ring 1 (DB-READ): entity-level DB queries (planned)
//! Ring 2 (LOCAL-READ): filesystem reads (planned)

// ── Ring 0: Pure ──
#[path = "r0-parse.rs"]         pub mod parse;
#[path = "r0-id_routing.rs"]    pub mod id_routing;
#[path = "r0-ring_topology.rs"] pub mod ring_topology;
#[path = "r0-type_constants.rs"] pub mod type_constants;
#[path = "r0-rank.rs"]          pub mod rank;
#[path = "r0-validate.rs"]      pub mod validate;
#[path = "r0-report.rs"]        pub mod report;
#[path = "r0-violation.rs"]     pub mod violation;
#[path = "r0-safe_commands.rs"] pub mod safe_commands;
#[path = "r0-burst.rs"]         pub mod burst;
#[path = "r0-entity_text.rs"]   pub mod entity_text;
#[path = "r0-spec_types.rs"]    pub mod spec_types;
#[path = "r0-spec_audit.rs"]    pub mod spec_audit;
#[path = "r0-structs.rs"]       pub mod structs;
