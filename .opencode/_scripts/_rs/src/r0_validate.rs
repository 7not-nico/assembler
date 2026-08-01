#![allow(non_snake_case)]
//! Field validation — port of _rb/validate.rb
//! ring: 0 (PURE)
//! contract: check_required validates field presence. check_field validates type, enum, pattern, min_length.
//! purity: pure (no I/O)

use regex::Regex;

#[derive(Debug, Clone)]
pub struct FieldRules {
    pub r#type: String,
    pub enum_values: Option<Vec<String>>,
    pub pattern: Option<Regex>,
    pub min_length: Option<usize>,
    pub minimum: Option<i64>,
}

/// Returns Some(error) if a required field is missing from frontmatter
pub fn checkRequired(frontmatter: &crate::r0_frontmatter::Frontmatter, field: &str) -> Option<String> {
    let present = match field {
        "id" => frontmatter.id.is_some(),
        "title" => frontmatter.title.is_some(),
        "source" => frontmatter.source.is_some(),
        "summary" => frontmatter.summary.is_some(),
        "protocol" => frontmatter.protocol.is_some(),
        "status" => frontmatter.status.is_some(),
        "tags" => frontmatter.tags.is_some(),
        _ => false,
    };
    if present {
        None
    } else {
        Some(format!("required field '{}' absent", field))
    }
}

/// Validate a serde_yaml::Value against field rules. Returns list of _Faults.
pub fn checkField(value: &serde_yaml::Value, rules: &FieldRules) -> Vec<String> {
    let mut _Faults = Vec::new();

    match rules.r#type.as_str() {
        "string" => match value {
            serde_yaml::Value::String(s) if !s.trim().is_empty() => {
                if let Some(min) = rules.min_length {
                    if s.trim().len() < min {
                        _Faults.push(format!("min length {}", min));
                    }
                }
            }
            _ => _Faults.push("must be non-empty string".to_string()),
        },
        "integer" => match value {
            serde_yaml::Value::Number(n) => {
                if let Some(min) = rules.minimum {
                    if n.as_i64().is_none_or(|v| v < min) {
                        _Faults.push(format!("must be integer >= {}", min));
                    }
                }
            }
            _ => _Faults.push("must be integer".to_string()),
        },
        "array" => match value {
            serde_yaml::Value::Sequence(_) => {}
            _ => _Faults.push("must be array".to_string()),
        },
        _ => {}
    }

    if let Some(enum_vals) = &rules.enum_values {
        let s = match value {
            serde_yaml::Value::String(s) => s.clone(),
            serde_yaml::Value::Number(n) => n.to_string(),
            other => format!("{:?}", other),
        };
        if !enum_vals.contains(&s) {
            _Faults.push(format!("must be one of {}", enum_vals.join("/")));
        }
    }

    if let Some(re) = &rules.pattern {
        if let serde_yaml::Value::String(s) = value {
            if !re.is_match(s) {
                _Faults.push("pattern mismatch".to_string());
            }
        }
    }

    _Faults
}
