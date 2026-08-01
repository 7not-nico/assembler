//! Ring topology per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY — port of _rb/rings.rb
//! ring: 0 (PURE)
//! contract: _RingGroups maps group _names to ring sequences. _TypeToRing maps entity type to (group, ring).
//! purity: pure (no I/O, no side effects)

use std::collections::HashMap;
use std::sync::LazyLock;

#[derive(Debug, Clone)]
pub struct RingInfo {
    pub ring: u32,
    pub name: &'static str,
}

pub static _RingGroups: LazyLock<HashMap<&'static str, Vec<RingInfo>>> = LazyLock::new(|| {
    let mut m: HashMap<&'static str, Vec<RingInfo>> = HashMap::new();

    m.insert(
        "axiomatic",
        vec![
            RingInfo {
                ring: 0,
                name: "Maxim, Precept, Specification",
            },
            RingInfo {
                ring: 1,
                name: "Identity",
            },
            RingInfo {
                ring: 2,
                name: "Abstraction, Algorithm, Linguistic",
            },
        ],
    );

    m.insert(
        "encyclopedic",
        vec![
            RingInfo {
                ring: 0,
                name: "Etymology",
            },
            RingInfo {
                ring: 1,
                name: "Cognition",
            },
            RingInfo {
                ring: 2,
                name: "Concept, Definition, Taxonomy",
            },
            RingInfo {
                ring: 3,
                name: "Term, Biology, Chemical",
            },
        ],
    );

    m.insert(
        "composition",
        vec![
            RingInfo {
                ring: 0,
                name: "Protocol",
            },
            RingInfo {
                ring: 1,
                name: "Pattern",
            },
            RingInfo {
                ring: 2,
                name: "Nexus",
            },
            RingInfo {
                ring: 3,
                name: "Illustration, Reference",
            },
        ],
    );

    m.insert(
        "architectonic",
        vec![
            RingInfo {
                ring: 0,
                name: "Rule",
            },
            RingInfo {
                ring: 1,
                name: "Command, Skill",
            },
            RingInfo {
                ring: 2,
                name: "Tool",
            },
        ],
    );

    m.insert(
        "chronicle",
        vec![
            RingInfo {
                ring: 0,
                name: "Person",
            },
            RingInfo {
                ring: 1,
                name: "Investigation, Apologia, Manifest",
            },
            RingInfo {
                ring: 2,
                name: "Archive, Note",
            },
        ],
    );

    m
});

/// Type name to ring mapping (e.g. "protocols" → Axiomatic R0, "patterns" → Composition R1)
pub static _TypeToRing: LazyLock<HashMap<&'static str, (&'static str, u32)>> =
    LazyLock::new(|| {
        let mut m: HashMap<&'static str, (&'static str, u32)> = HashMap::new();
        for (_groupName, rings) in _RingGroups.iter() {
            for _ringInfo in rings {
                let _names: Vec<&str> = _ringInfo.name.split(", ").collect();
                for name in _names {
                    let _key = name.to_lowercase();
                    m.insert(Box::leak(_key.into_boxed_str()), (*_groupName, _ringInfo.ring));
                }
            }
        }
        m
    });

pub fn typeToRing(entity_type: &str) -> Option<(&'static str, u32)> {
    _TypeToRing.get(entity_type).copied()
}

pub fn allRings() -> Vec<(&'static str, u32, &'static str)> {
    let mut _result = Vec::new();
    for (&group, rings) in _RingGroups.iter() {
        for _ringInfo in rings {
            _result.push((group, _ringInfo.ring, _ringInfo.name));
        }
    }
    _result
}
