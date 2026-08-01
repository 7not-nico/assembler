// ring: 0 (PURE)
//! Shared entity data structs — camelCase fields

use crate::parse::Frontmatter;

#[derive(Debug, Clone)]
pub struct EntityEntry {
    pub entityType: String,
    pub id: String,
    pub title: String,
    pub frontmatter: Frontmatter,
    pub filePath: String,
}

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct SearchResult {
    pub entityType: String,
    pub entityId: String,
    pub score: f64,
    pub source: Option<String>,
}

impl EntityEntry {
    pub fn new(entityType: &str, id: &str, title: &str, frontmatter: Frontmatter, filePath: &str) -> Self {
        Self {
            entityType: entityType.to_string(),
            id: id.to_string(),
            title: title.to_string(),
            frontmatter,
            filePath: filePath.to_string(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_entity_entry() {
        let fm = Frontmatter { id: Some("MAX.DRY".to_string()), ..Default::default() };
        let entry = EntityEntry::new("maxims", "MAX.DRY", "DRY", fm, "path.md");
        assert_eq!(entry.id, "MAX.DRY");
    }
}
