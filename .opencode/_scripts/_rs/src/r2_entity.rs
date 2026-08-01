//! Entity file loading — port of _rb/entity.rb
//! ring: 2 (LOCAL-READ)
//! contract: load_entities reads .md files from an entity type directory, parses frontmatter.
//! purity: io (std::fs::read_to_string)

use crate::r0_frontmatter as frontmatter;
use crate::r2_paths as paths;

#[derive(Debug, Clone)]
pub struct EntityEntry {
    pub entity_type: String,
    pub id: String,
    pub title: String,
    pub frontmatter: frontmatter::Frontmatter,
    pub file_path: String,
}

pub fn loadEntities(entity_type: &str) -> Vec<EntityEntry> {
    let files = paths::entityFiles(entity_type);
    let mut entries = Vec::new();
    for path in &files {
        let text = match std::fs::read_to_string(path) {
            Ok(t) => t,
            Err(_) => continue,
        };
        let fm = match frontmatter::parseMetadata(&text) {
            Some(f) => f,
            None => continue,
        };
        let id = fm.id.clone().unwrap_or_else(|| {
            path.file_stem().and_then(|s| s.to_str()).unwrap_or("unknown").to_string()
        });
        let title = fm.title.clone().unwrap_or_default();
        entries.push(EntityEntry {
            entity_type: entity_type.to_string(),
            id,
            title,
            frontmatter: fm,
            file_path: path.to_string_lossy().to_string(),
        });
    }
    entries
}

pub fn loadAllEntities() -> Vec<EntityEntry> {
    let types = paths::entityTypes();
    let mut all = Vec::new();
    for t in types {
        all.extend(loadEntities(&t));
    }
    all
}
