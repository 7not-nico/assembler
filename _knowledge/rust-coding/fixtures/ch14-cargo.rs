// source: https://doc.rust-lang.org/stable/book/ch14-00-more-about-cargo.html
// module: ch14 — doc comments, doc tests, cfg attributes, conditional compilation
// compile: rustc --test ch14-cargo.rs -o /tmp/ch14-cargo && /tmp/ch14-cargo

//! This crate demonstrates Cargo and documentation features.
//!
//! Inner doc comments (`//!`) describe the crate or module.
//! Outer doc comments (`///`) describe individual items.

#![allow(dead_code)]

/// Adds two numbers.
///
/// # Example
///
/// ```
/// let result = add(2, 3);
/// assert_eq!(result, 5);
/// ```
fn add(a: i32, b: i32) -> i32 {
    a + b
}

/// Divides two numbers. Returns None if denominator is zero.
///
/// # Example
///
/// ```
/// let result = safe_div(10.0, 2.0);
/// assert_eq!(result, Some(5.0));
///
/// let result = safe_div(1.0, 0.0);
/// assert_eq!(result, None);
/// ```
fn safe_div(a: f64, b: f64) -> Option<f64> {
    if b == 0.0 { None } else { Some(a / b) }
}

/// Greets a person by name.
///
/// # Arguments
///
/// * `name` - A string slice holding the person's name.
///
/// # Returns
///
/// A greeting string.
fn greet(name: &str) -> String {
    format!("Hello, {name}!")
}

// ── Conditional compilation with cfg ──

#[cfg(target_os = "linux")]
fn platform() -> &'static str {
    "linux"
}

#[cfg(target_os = "windows")]
fn platform() -> &'static str {
    "windows"
}

#[cfg(not(any(target_os = "linux", target_os = "windows")))]
fn platform() -> &'static str {
    "other"
}

/// Only compiled when `test` feature or test mode is active
#[cfg(test)]
fn test_helper() -> i32 {
    42
}

/// Feature-gated function (requires feature "extra" in Cargo.toml)
#[cfg(feature = "extra")]
fn extra_feature() -> &'static str {
    "extra feature is enabled"
}

fn main() {
    println!("add: {}", add(2, 3));
    println!("safe_div: {:?}", safe_div(10.0, 2.0));
    println!("greet: {}", greet("Rust"));

    // Platform detection via cfg
    println!("platform: {}", platform());

    // Doc tests are verified via `cargo test`, not directly in this binary
    // Run `cargo doc --open` to see the generated documentation
    // Run `cargo test` to run doc tests
}

// ── Tests ──

#[cfg(test)]
mod unit {
    use super::*;

    #[test]
    fn add_works() {
        assert_eq!(add(2, 3), 5);
    }

    #[test]
    fn safe_div_works() {
        assert_eq!(safe_div(10.0, 2.0), Some(5.0));
    }

    #[test]
    fn safe_div_zero() {
        assert_eq!(safe_div(1.0, 0.0), None);
    }

    #[test]
    fn greet_works() {
        assert_eq!(greet("Alice"), "Hello, Alice!");
    }

    #[test]
    fn cfg_platform_exists() {
        let p = platform();
        assert!(p == "linux" || p == "windows" || p == "other");
    }

    #[test]
    fn test_helper_works() {
        assert_eq!(test_helper(), 42);
    }
}
