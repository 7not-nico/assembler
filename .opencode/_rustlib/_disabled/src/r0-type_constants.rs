// ring: 0 (PURE)
//! Entity type constants — PascalCase singular descriptors

pub static EntityType: &[&str] = &[
    "patterns", "terms", "skills", "rules", "commands",
    "protocols", "abstractions", "persons", "illustrations",
    "maxims", "cognitions", "concepts", "definitions",
    "taxonomies", "biology", "chemistry", "references",
    "nexus", "apologias", "precepts", "specifications",
    "investigations", "manifests", "archives", "notes",
    "identities", "linguistics", "algorithms",
];

pub const ValidStateProfile: &[&str] = &[
    "stateless", "stateful-reader", "stateful-writer",
    "stateful-auditor", "hybrid",
];

pub const ValidStatus: &[&str] = &["active", "draft", "deprecated"];

pub const EntityBodyType: &[&str] = &[
    "patterns", "terms", "cognitions", "concepts", "definitions",
    "skills", "rules", "protocols", "abstractions", "linguistics",
    "apologias", "persons", "illustrations", "maxims",
];

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_entity_count() {
        assert_eq!(EntityType.len(), 28);
    }

    #[test]
    fn test_maxims_in_list() {
        assert!(EntityType.contains(&"maxims"));
    }
}
