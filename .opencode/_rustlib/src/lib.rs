//! assembler_core — functional core for AMANDA assembler
//! Ring 0 (PURE): pure functions, no I/O, no side effects
//!
//! Naming per precepts:
//!   Structs: one word, singular abstract noun, Upper
//!   Functions: one word, singular concrete noun, lower
//!   Variables: one word, singular descriptor, lower, no verbs
//!   No gerunds, no nominalizations

#[path = "r0-vector.rs"] pub mod vector;
#[path = "r0-index.rs"]  pub mod index;
