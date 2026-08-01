// ring: 0 (PURE)
//! Spec audit report format

use std::collections::BTreeMap;
use crate::specTypes::{AuditOutcome, Rule};

/// Audited report string
pub fn audited(result: &AuditOutcome) -> String {
    let ec = result.defects.iter().filter(|d| d.severity == "error").count();
    let wc = result.defects.iter().filter(|d| d.severity == "warn").count();
    let s = format!("Score: {}/100 — {} errors, {} warnings across {} rules.", result.score, ec, wc, result.total);
    if result.defects.is_empty() { return format!("{} All passed.", s); }
    let mut by: BTreeMap<usize, Vec<&crate::specTypes::Defect>> = BTreeMap::new();
    for d in &result.defects { by.entry(d.line).or_default().push(d); }
    let mut body = vec![s, String::new()];
    for (line, ds) in by {
        body.push(format!("Line {}:", line));
        for d in ds {
            let tag = if d.severity == "error" { "ERR" } else { "WARN" };
            body.push(format!("  [{}] {}: {}", tag, d.rule, d.message));
            if let Some(ref sug) = d.suggestion { body.push(format!("         -> {}", sug)); }
        }
    }
    body.join("\n")
}

/// Rule list string
pub fn rulelist(rules: &[Rule]) -> String {
    rules.iter().map(|r| {
        let d = r.description.as_ref().map(|d| d.as_str()).unwrap_or("");
        format!("{} [{}] {}\n  {}\n  Type: {:?} | Scope: {}", r.id, r.severity, r.title, d, r.checktype, r.scope)
    }).collect::<Vec<_>>().join("\n\n")
}
