// ring: 0 (PURE)
//! Entity audit formatter

use crate::violation::Defect;

#[derive(Debug, Clone)]
pub struct EntityAuditOutcome {
    pub path: String,
    pub entitytype: String,
    pub score: u32,
    pub defect: Vec<Defect>,
}

pub fn entityreport(outcome: &EntityAuditOutcome) -> String {
    let summary = format!("File: {} ({})\nScore: {}/100 — {} defect(s).",
        outcome.path, outcome.entitytype, outcome.score, outcome.defect.len());

    if outcome.defect.is_empty() {
        return format!("{} All pass.", summary);
    }

    let detail: Vec<String> = outcome.defect.iter()
        .map(|d| format!("  Line {}: [{}] {}", d.line, d.severity, d.message))
        .collect();
    format!("{}\n{}", summary, detail.join("\n"))
}

pub fn entityreportall(result: &[EntityAuditOutcome]) -> String {
    if result.is_empty() { return "No file audited.".to_string(); }

    let pass = result.iter().filter(|r| r.defect.is_empty()).count();
    let fail: Vec<&EntityAuditOutcome> = result.iter().filter(|r| !r.defect.is_empty()).collect();
    let summary = format!("Audit {} file(s): {} pass, {} fail.", result.len(), pass, fail.len());

    if fail.is_empty() { return format!("{} All clean.", summary); }

    let mut output = vec![summary, String::new()];
    for outcome in fail {
        output.push(entityreport(outcome));
    }
    output.join("\n")
}
