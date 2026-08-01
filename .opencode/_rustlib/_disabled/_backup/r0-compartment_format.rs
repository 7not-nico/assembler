// ring: 0 (PURE)
//! Compartment audit result formatter
//! port of _lib/compartment-format.ts

use crate::compartmentAudit::{CompartmentAuditResult, CompartmentViolation};

/// Single violation line
fn violationLine(violations: &[CompartmentViolation]) -> String {
    if violations.is_empty() { "  OK".to_string() }
    else { violations.iter().map(|v| format!("  {}: {}", v.field, v.message)).collect::<Vec<_>>().join("\n") }
}

/// Single compartment audit result
pub fn compartmentResult(result: &CompartmentAuditResult) -> String {
    let status = if !result.present { "MISSING" }
                 else if result.violations.is_empty() { "PASS" }
                 else { "FAIL" };

    let mut lines = vec![format!("{} [{}]", result.name, status)];
    lines.push(format!("  Path: {}", result.path));
    if result.present {
        lines.push(violationLine(&result.violations));
    } else {
        lines.push("  No compartment.yaml found".to_string());
    }
    lines.join("\n")
}

/// Combined report across all audited subprojects
pub fn compartmentReportAll(results: &[CompartmentAuditResult]) -> String {
    if results.is_empty() { return "No subprojects found.".to_string(); }

    let passed = results.iter().filter(|r| !r.present || r.violations.is_empty()).count();
    let failed: Vec<&CompartmentAuditResult> = results.iter().filter(|r| r.present && !r.violations.is_empty()).collect();
    let missing: Vec<&CompartmentAuditResult> = results.iter().filter(|r| !r.present).collect();

    let summary = format!("Audited {} subprojects: {} compliant, {} with violations, {} without declarations.",
        results.len(), passed, failed.len(), missing.len());

    if failed.is_empty() && missing.is_empty() { return format!("{}\nAll clean.", summary); }

    let mut sections = vec![summary, String::new()];

    if !failed.is_empty() {
        sections.push("--- Violations ---".to_string());
        for r in &failed { sections.push(compartmentResult(r)); }
        sections.push(String::new());
    }

    if !missing.is_empty() {
        sections.push("--- Missing compartment.yaml ---".to_string());
        for r in &missing { sections.push(format!("  {}", r.name)); }
    }

    sections.join("\n")
}
