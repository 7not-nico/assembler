#![allow(non_snake_case, non_upper_case_globals, clippy::redundant_closure_for_method_calls)]
//! assembler-scripts — shared library for entity auditing
//! ring: 0 (PURE)
//!
//! Ring topology per SPEC.CODE.RING.TOPOLOGY:
//!   r0 — PURE (no I/O): frontmatter, rings, patlib, validate, Fault, report, bench
//!   r2 — LOCAL-READ (filesystem): paths, entity, check_*

// Ring 0 — Pure (no I/O, no side effects)
pub mod r0_frontmatter;
pub mod r0_rings;
pub mod r0_patlib;
pub mod r0_validate;
pub mod r0_report;
pub mod r0_violation;
pub mod r0_bench;

// Ring 2 — Local read (reads entity files from .opencode/entities/)
pub mod r2_paths;
pub mod r2_entity;
pub mod r2_check_id_match;
pub mod r2_check_ring_match;
pub mod r2_check_source;
pub mod r2_check_precedes;
pub mod r2_check_stale_refs;
