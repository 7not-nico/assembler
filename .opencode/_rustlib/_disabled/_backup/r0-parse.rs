// ring: 0 (PURE)
//! YAML frontmatter and backmatter

use regex::Regex;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Clone, Default, Serialize, Deserialize)]
pub struct Frontmatter {
    pub id: Option<String>,
    pub title: Option<String>,
    pub source: Option<String>,
    pub summary: Option<String>,
    pub tags: Option<Vec<String>>,
    pub status: Option<String>,
    pub r#type: Option<String>,
    pub protocol: Option<String>,
    pub enforcement: Option<String>,
    pub priority: Option<i32>,
    pub related: Option<Vec<String>>,
    pub morphism: Option<String>,
    pub principle: Option<String>,
    pub precedes: Option<Vec<String>>,
    pub illustrates: Option<Vec<String>>,
    pub state_profile: Option<String>,
    pub description: Option<String>,
    pub reference: Option<String>,
    pub specifies: Option<String>,
    pub group: Option<String>,
    pub ring: Option<String>,
    pub naming: Option<String>,
    #[serde(flatten)]
    pub extra: HashMap<String, serde_yaml::Value>,
}

/// Frontmatter yaml at file start
pub fn frontmatter(text: &str) -> Option<Frontmatter> {
    let re = Regex::new(r"(?s)\A---\s*\n(.*?)\n---\s*\n").ok()?;
    let caps = re.captures(text)?;
    let yaml = caps.get(1)?.as_str();
    serde_yaml::from_str(yaml).ok()
}

/// Backmatter yaml at file end
pub fn backmatter(text: &str) -> Option<Frontmatter> {
    let re = Regex::new(r"(?s)---\s*\n(.*?)\n---\s*\z").ok()?;
    let caps = re.captures(text)?;
    let yaml = caps.get(1)?.as_str();
    serde_yaml::from_str(yaml).ok()
}

/// Frontmatter or backmatter
pub fn metadata(text: &str) -> Option<Frontmatter> {
    frontmatter(text).or_else(|| backmatter(text))
}

/// Raw yaml value from frontmatter
pub fn frontmatterraw(text: &str) -> Option<serde_yaml::Value> {
    let re = Regex::new(r"(?s)\A---\s*\n(.*?)\n---\s*\n").ok()?;
    let caps = re.captures(text)?;
    let yaml = caps.get(1)?.as_str();
    serde_yaml::from_str(yaml).ok()
}

/// Tags from yaml value (string or array)
pub fn tag(value: &serde_yaml::Value) -> Vec<String> {
    match value {
        serde_yaml::Value::String(s) => {
            s.split(',').map(|t| t.trim().to_string()).filter(|t| !t.is_empty()).collect()
        }
        serde_yaml::Value::Sequence(seq) => {
            seq.iter().filter_map(|v| v.as_str().map(|s| s.to_string())).collect()
        }
        _ => vec![],
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_frontmatter() {
        let text = "---\nid: MAX.DRY\ntitle: DRY\n---\nBody\n";
        let fm = frontmatter(text).unwrap();
        assert_eq!(fm.id, Some("MAX.DRY".to_string()));
    }

    #[test]
    fn test_tag_from_string() {
        let v = serde_yaml::Value::String("a,b".to_string());
        assert_eq!(tag(&v), vec!["a", "b"]);
    }
}
