// ring: 0 (PURE)
//! Frontmatter field audit

/// Id field — must be present
pub fn id(fm: &crate::parse::Frontmatter) -> Option<String> {
    match &fm.id {
        Some(s) if !s.is_empty() => None,
        _ => Some("id: required field absent".to_string()),
    }
}

/// Title field — must be present
pub fn title(fm: &crate::parse::Frontmatter) -> Option<String> {
    match &fm.title {
        Some(s) if !s.is_empty() => None,
        _ => Some("title: required field absent".to_string()),
    }
}

/// Source field — must be present
pub fn source(fm: &crate::parse::Frontmatter) -> Option<String> {
    match &fm.source {
        Some(s) if !s.is_empty() => None,
        _ => Some("source: required field absent".to_string()),
    }
}

/// Summary field — must be present
pub fn summary(fm: &crate::parse::Frontmatter) -> Option<String> {
    match &fm.summary {
        Some(s) if !s.is_empty() => None,
        _ => Some("summary: required field absent".to_string()),
    }
}

/// Status field — active/draft/deprecated
pub fn status(fm: &crate::parse::Frontmatter) -> Option<String> {
    match &fm.status {
        Some(s) if ["active", "draft", "deprecated"].contains(&s.as_str()) => None,
        Some(s) => Some(format!("status: must be active/draft/deprecated, got '{}'", s)),
        None => Some("status: required field absent".to_string()),
    }
}

/// Tags field — must be non-empty
pub fn tag(fm: &crate::parse::Frontmatter) -> Option<String> {
    match &fm.tags {
        Some(t) if !t.is_empty() => None,
        Some(_) => Some("tags: empty array".to_string()),
        None => Some("tags: required field absent".to_string()),
    }
}

/// Frontmatter field audit
pub fn audit(fm: &crate::parse::Frontmatter) -> Vec<String> {
    let mut v = Vec::new();
    for check in &[id as fn(&crate::parse::Frontmatter) -> Option<String>, title, source, status, tag] {
        if let Some(msg) = check(fm) { v.push(msg); }
    }
    v
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::parse::Frontmatter;

    #[test]
    fn test_id_absent() {
        let fm = Frontmatter::default();
        assert!(id(&fm).is_some());
    }

    #[test]
    fn test_id_present() {
        let fm = Frontmatter { id: Some("MAX.DRY".to_string()), ..Default::default() };
        assert!(id(&fm).is_none());
    }
}
