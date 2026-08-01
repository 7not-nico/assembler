#![allow(non_snake_case)]
//! Entity source check — `source:` field must refer to a valid entity ID
//! ring: 2 (LOCAL-READ)
//! contract: source values that look like entity IDs must resolve to existing entities.
//!   URLs, "assembler", and "INSP.*" sources are exempt.
//! purity: io (reads EntityEntry fields)

use std::collections::HashSet;
use crate::r2_entity::EntityEntry;
use crate::r0_violation::Fault;

// Only values shaped like entity IDs (dotted uppercase prefix chain) undergo validation.
// Citation strings and prose sources skip the check.
fn isEntityIdShape(_value: &str) -> bool {
    let _IdShape = regex::Regex::new(r"^(PROT|PAT|NEX|ILL|REF|MAX|SPEC|PER|COG|CON|DEF|TERM|SKL|CMD|RUL|PRE|ABS|LING|BIO|CHE|TAX|ML|INV|APO|MAN|ARC|NOTE)\.[A-Z][A-Z0-9]*(\.[A-Z0-9]+)+$").unwrap();
    _IdShape.is_match(_value)
}

pub fn checkSource(entries: &[EntityEntry], _allIdentifiers: &HashSet<&str>) -> Vec<Fault> {
    let mut _Faults = Vec::new();
    for _entry in entries {
        let _sourceValue = match &_entry.frontmatter.source {
            Some(_sourceText) => _sourceText.trim().to_string(),
            None => continue,
        };
        if _sourceValue.starts_with("assembler") || _sourceValue.starts_with("http") || _sourceValue.starts_with("INSP") {
            continue;
        }
        if !isEntityIdShape(&_sourceValue) {
            continue;
        }
        if !_allIdentifiers.contains(_sourceValue.as_str()) {
            _Faults.push(Fault {
                id: _entry.id.clone(),
                entity_type: _entry.entity_type.clone(),
                field: "source".to_string(),
                value: _sourceValue,
                problem: "source does not match any known entity ID".to_string(),
            });
        }
    }
    _Faults
}
