// ring: 0 (PURE)
//! Frontmatter field audit

pub fn id(frontmatter: &crate::parse::Frontmatter) -> Option<String> {
    match &frontmatter.id {
        Some(s) if !s.is_empty() => None,
        _ => Some("id: required field absent".to_string()),
    }
}

pub fn title(frontmatter: &crate::parse::Frontmatter) -> Option<String> {
    match &frontmatter.title {
        Some(s) if !s.is_empty() => None,
        _ => Some("title: required field absent".to_string()),
    }
}

pub fn source(frontmatter: &crate::parse::Frontmatter) -> Option<String> {
    match &frontmatter.source {
        Some(s) if !s.is_empty() => None,
        _ => Some("source: required field absent".to_string()),
    }
}

pub fn status(frontmatter: &crate::parse::Frontmatter) -> Option<String> {
    match &frontmatter.status {
        Some(s) if ["active", "draft", "deprecated"].contains(&s.as_str()) => None,
        Some(s) => Some(format!("status: must be active/draft/deprecated, got '{}'", s)),
        None => Some("status: required field absent".to_string()),
    }
}

pub fn tag(frontmatter: &crate::parse::Frontmatter) -> Option<String> {
    match &frontmatter.tags {
        Some(taglist) if !taglist.is_empty() => None,
        Some(_) => Some("tags: empty array".to_string()),
        None => Some("tags: required field absent".to_string()),
    }
}

pub fn audit(frontmatter: &crate::parse::Frontmatter) -> Vec<String> {
    let mut list = Vec::new();
    for check in &[id as fn(&crate::parse::Frontmatter) -> Option<String>, title, source, status, tag] {
        if let Some(msg) = check(frontmatter) { list.push(msg); }
    }
    list
}

#[cfg(test)]
mod test {
    use super::*;
    use crate::parse::Frontmatter;

    #[test]
    fn id_absent_case() {
        let frontmatter = Frontmatter::default();
        assert!(id(&frontmatter).is_some());
    }

    #[test]
    fn id_present_case() {
        let frontmatter = Frontmatter { id: Some("MAX.DRY".to_string()), ..Default::default() };
        assert!(id(&frontmatter).is_none());
    }
}
