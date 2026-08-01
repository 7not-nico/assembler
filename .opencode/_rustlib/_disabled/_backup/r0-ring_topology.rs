// ring: 0 (PURE)
//! Ring topology per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY

use std::collections::HashMap;
use std::sync::LazyLock;

#[derive(Debug, Clone)]
pub struct RingInfo {
    pub ring: u32,
    pub name: &'static str,
}

pub static RingGroup: LazyLock<HashMap<&'static str, Vec<RingInfo>>> = LazyLock::new(|| {
    let mut m: HashMap<&'static str, Vec<RingInfo>> = HashMap::new();
    m.insert("axiomatic", vec![
        RingInfo { ring: 0, name: "Maxim, Precept, Specification" },
        RingInfo { ring: 1, name: "Identity" },
        RingInfo { ring: 2, name: "Abstraction, Algorithm, Linguistic" },
    ]);
    m.insert("encyclopedic", vec![
        RingInfo { ring: 0, name: "Etymology" },
        RingInfo { ring: 1, name: "Cognition" },
        RingInfo { ring: 2, name: "Concept, Definition, Taxonomy" },
        RingInfo { ring: 3, name: "Term, Biology, Chemical" },
    ]);
    m.insert("composition", vec![
        RingInfo { ring: 0, name: "Protocol" },
        RingInfo { ring: 1, name: "Pattern" },
        RingInfo { ring: 2, name: "Nexus" },
        RingInfo { ring: 3, name: "Illustration, Reference" },
    ]);
    m.insert("architectonic", vec![
        RingInfo { ring: 0, name: "Rule" },
        RingInfo { ring: 1, name: "Command, Skill" },
        RingInfo { ring: 2, name: "Tool" },
    ]);
    m.insert("chronicle", vec![
        RingInfo { ring: 0, name: "Person" },
        RingInfo { ring: 1, name: "Investigation, Apologia, Manifest" },
        RingInfo { ring: 2, name: "Archive, Note" },
    ]);
    m
});

pub static TypeToRing: LazyLock<HashMap<&'static str, (&'static str, u32)>> = LazyLock::new(|| {
    let mut m: HashMap<&'static str, (&'static str, u32)> = HashMap::new();
    for (group, rings) in RingGroup.iter() {
        for ri in rings {
            for name in ri.name.split(", ") {
                let lc = name.to_lowercase();
                let plural = match lc.as_str() {
                    "maxim" => "maxims", "precept" => "precepts",
                    "specification" => "specifications", "identity" => "identities",
                    "abstraction" => "abstractions", "algorithm" => "algorithms",
                    "linguistic" => "linguistics", "etymology" => "etymologies",
                    "cognition" => "cognitions", "concept" => "concepts",
                    "definition" => "definitions", "taxonomy" => "taxonomies",
                    "term" => "terms", "biology" => "biology",
                    "chemical" => "chemistry", "protocol" => "protocols",
                    "pattern" => "patterns", "nexus" => "nexus",
                    "illustration" => "illustrations", "reference" => "references",
                    "rule" => "rules", "command" => "commands",
                    "skill" => "skills", "tool" => "tools",
                    "person" => "persons", "investigation" => "investigations",
                    "apologia" => "apologias", "manifest" => "manifests",
                    "archive" => "archives", "note" => "notes",
                    other => other,
                };
                let key: &'static str = Box::leak(plural.to_string().into_boxed_str());
                m.insert(key, (group, ri.ring));
            }
        }
    }
    m
});

/// Ring for a given entity type
pub fn typering(entity_type: &str) -> Option<(&'static str, u32)> {
    TypeToRing.get(entity_type).copied()
}

/// All rings
pub fn ringlist() -> Vec<(&'static str, u32, &'static str)> {
    let mut result = Vec::new();
    for (group, rings) in RingGroup.iter() {
        for ri in rings {
            result.push((group, ri.ring, ri.name));
        }
    }
    result
}

/// Ring for a patlib id
pub fn ringforid(id: &str) -> Option<(&'static str, u32)> {
    let et = crate::id_routing::entitytype(id)?;
    typering(et)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_typering() {
        let (group, ring) = typering("maxims").unwrap();
        assert_eq!(group, "axiomatic");
        assert_eq!(ring, 0);
    }
}
