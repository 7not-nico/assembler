#![allow(non_snake_case)]
//! YAML frontmatter and backmatter parser — port of _rb/frontmatter.rb
//! ring: 0 (PURE)
//! contract: parse_frontmatter parses YAML between --- delimiters at file start.
//!   parse_backmatter parses YAML between --- delimiters at file end.
//!   parse_metadata tries frontmatter first, falls back to backmatter.
//! purity: pure (no I/O, regex + serde_yaml only)

use regex::Regex;
use serde::Deserialize;
use std::collections::HashMap;

#[derive(Debug, Clone, Default, Deserialize)]
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

pub struct RawMetadata {
    pub frontmatter: Option<Frontmatter>,
    pub backmatter: Option<Frontmatter>,
}

/// Parse YAML frontmatter between `---` delimiters at file start
pub fn parseFrontmatter(text: &str) -> Option<Frontmatter> {
    let re = Regex::new(r"(?s)\A---\s*\n(.*?)\n---\s*\n").ok()?;
    let caps = re.captures(text)?;
    let yaml_str = caps.get(1)?.as_str();
    serde_yaml::from_str(yaml_str).ok()
}

/// Parse YAML backmatter between `---` delimiters at file end
pub fn parseBackmatter(text: &str) -> Option<Frontmatter> {
    let re = Regex::new(r"(?s)---\s*\n(.*?)\n---\s*\z").ok()?;
    let caps = re.captures(text)?;
    let yaml_str = caps.get(1)?.as_str();
    serde_yaml::from_str(yaml_str).ok()
}

/// Try frontmatter first, fall back to backmatter
pub fn parseMetadata(text: &str) -> Option<Frontmatter> {
    parseFrontmatter(text).or_else(|| parseBackmatter(text))
}
