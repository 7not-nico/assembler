#![allow(non_snake_case)]
//! Entity id-match check — frontmatter `id:` must match filename
//! ring: 2 (LOCAL-READ)
//! contract: for every entity entry, verify frontmatter id field equals the file stem.
//! purity: io (reads entity::EntityEntry)

use crate::r2_entity::EntityEntry;
use crate::r0_violation::Fault;

pub fn checkIdMatch(entries: &[EntityEntry]) -> Vec<Fault> {
    let mut _Faults = Vec::new();
    for _entry in entries {
        let _fileStem = std::path::Path::new(&_entry.file_path)
            .file_stem()
            .and_then(|stem_text| stem_text.to_str())
            .unwrap_or("");
        if _entry.id.is_empty() {
            _Faults.push(Fault {
                id: _fileStem.to_string(),
                entity_type: _entry.entity_type.clone(),
                field: "id".to_string(),
                value: "(missing)".to_string(),
                problem: "frontmatter id field is missing or empty".to_string(),
            });
        } else if _entry.id != _fileStem {
            _Faults.push(Fault {
                id: _fileStem.to_string(),
                entity_type: _entry.entity_type.clone(),
                field: "id".to_string(),
                value: format!("frontmatter id={}, filename={}", _entry.id, _fileStem),
                problem: "frontmatter id does not match filename".to_string(),
            });
        }
    }
    _Faults
}
