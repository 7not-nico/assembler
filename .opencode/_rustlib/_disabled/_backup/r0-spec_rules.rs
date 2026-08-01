// ring: 0 (PURE)
//! Spec rule set

use crate::specTypes::{CheckType, Rule};

/// All 12 spec rules
pub fn rule() -> Vec<Rule> {
    vec![
        Rule { id: "POSITIVE_FRAMING".to_string(), title: "Positive framing required".to_string(), description: None, severity: "error".to_string(), checktype: CheckType::Proximity, threshold: Some(5.0), scope: "document".to_string(), suggestion: Some("Replace negative with positive instruction.".to_string()) },
        Rule { id: "RATIO_3_1".to_string(), title: "3:1 positive-to-negative ratio".to_string(), description: None, severity: "error".to_string(), checktype: CheckType::Ratio, threshold: Some(3.0), scope: "document".to_string(), suggestion: Some("Add more positive instructions.".to_string()) },
        Rule { id: "DECLARATIVE_REGISTER".to_string(), title: "Declarative register".to_string(), description: None, severity: "warn".to_string(), checktype: CheckType::ForbiddenPattern, threshold: None, scope: "line".to_string(), suggestion: Some("Use declarative phrasing.".to_string()) },
        Rule { id: "FORBIDDEN_PRIMING".to_string(), title: "No forbidden priming".to_string(), description: None, severity: "error".to_string(), checktype: CheckType::ForbiddenPattern, threshold: None, scope: "line".to_string(), suggestion: Some("Use X: excluded.".to_string()) },
        Rule { id: "CONSTRAINT_BUDGET".to_string(), title: "Constraint budget".to_string(), description: None, severity: "error".to_string(), checktype: CheckType::Count, threshold: Some(6.0), scope: "segment".to_string(), suggestion: Some("Reduce to <=6 constraints.".to_string()) },
        Rule { id: "STRUCTURAL_PREFERENCE".to_string(), title: "Structural preference".to_string(), description: None, severity: "warn".to_string(), checktype: CheckType::Ratio, threshold: Some(1.0), scope: "document".to_string(), suggestion: Some("Use structural constraints.".to_string()) },
        Rule { id: "HARD_STOP_REDIRECT".to_string(), title: "Hard stop redirect".to_string(), description: None, severity: "error".to_string(), checktype: CheckType::Proximity, threshold: Some(5.0), scope: "document".to_string(), suggestion: Some("Add positive redirect.".to_string()) },
        Rule { id: "CONJUNCTION_OPERATOR".to_string(), title: "No conjunction operators".to_string(), description: None, severity: "warn".to_string(), checktype: CheckType::ForbiddenPattern, threshold: None, scope: "line".to_string(), suggestion: Some("Use declarative listing.".to_string()) },
        Rule { id: "NEGATION_OPERATOR".to_string(), title: "No negation operators".to_string(), description: None, severity: "warn".to_string(), checktype: CheckType::ForbiddenPattern, threshold: None, scope: "line".to_string(), suggestion: Some("Use X: disabled.".to_string()) },
        Rule { id: "XOR_OPERATOR".to_string(), title: "XOR is unreliable".to_string(), description: None, severity: "warn".to_string(), checktype: CheckType::ForbiddenPattern, threshold: None, scope: "line".to_string(), suggestion: Some("Use IF/ELSE.".to_string()) },
        Rule { id: "IMPLICATION_OPERATOR".to_string(), title: "Implication is model-specific".to_string(), description: None, severity: "warn".to_string(), checktype: CheckType::ForbiddenPattern, threshold: None, scope: "line".to_string(), suggestion: Some("Use declarative.".to_string()) },
        Rule { id: "CONNECTIVE_FRAGILITY".to_string(), title: "No high-entropy connectives".to_string(), description: None, severity: "warn".to_string(), checktype: CheckType::ForbiddenPattern, threshold: None, scope: "line".to_string(), suggestion: Some("Use separate sentences.".to_string()) },
    ]
}
