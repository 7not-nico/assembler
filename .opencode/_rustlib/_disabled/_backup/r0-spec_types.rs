// ring: 0 (PURE)
//! Spec audit types

#[derive(Debug, Clone)]
pub enum CheckType {
    ForbiddenPattern,
    Ratio,
    Proximity,
    Count,
}

#[derive(Debug, Clone)]
pub struct Rule {
    pub id: String,
    pub title: String,
    pub description: Option<String>,
    pub severity: String,
    pub checktype: CheckType,
    pub threshold: Option<f64>,
    pub scope: String,
    pub suggestion: Option<String>,
}

#[derive(Debug, Clone)]
pub struct Defect {
    pub rule: String,
    pub title: String,
    pub severity: String,
    pub line: usize,
    pub message: String,
    pub suggestion: Option<String>,
}

#[derive(Debug, Clone)]
pub struct AuditOutcome {
    pub score: u32,
    pub total: usize,
    pub defects: Vec<Defect>,
}
