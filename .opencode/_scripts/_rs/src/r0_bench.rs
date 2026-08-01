#![allow(non_snake_case)]
//! Timing helpers — port of _rb/bench.rb
//! ring: 0 (PURE)
//! contract: Stopwatch wraps Instant for elapsed time measurement with human-readable formatting.
//! purity: pure (std::time::Instant only, no I/O)

use std::time::Instant;

pub struct Stopwatch {
    start: Instant,
    label: String,
}

impl Stopwatch {
    pub fn start(label: &str) -> Self {
        Self {
            start: Instant::now(),
            label: label.to_string(),
        }
    }

    pub fn elapsed(&self) -> String {
        let d = self.start.elapsed();
        format_duration(d)
    }

    pub fn finish(&self) -> String {
        let d = self.start.elapsed();
        format!("  [{}] {}", format_duration(d), self.label)
    }
}

fn format_duration(d: std::time::Duration) -> String {
    let total_ms = d.as_millis();
    if total_ms < 1000 {
        format!("{}ms", total_ms)
    } else if total_ms < 60_000 {
        format!("{:.1}s", total_ms as f64 / 1000.0)
    } else {
        format!("{:.1}m", total_ms as f64 / 60_000.0)
    }
}
