#![allow(non_snake_case)]
//! Entity ring-match check — ID prefix must match directory type
//! ring: 2 (LOCAL-READ)
//! contract: for every entity entry, verify its ID prefix maps to the directory it lives in.
//! purity: io (reads EntityEntry fields)

use crate::r2_entity::EntityEntry;
use crate::r0_patlib;
use crate::r0_violation::Fault;

pub fn checkRingMatch(entries: &[EntityEntry]) -> Vec<Fault> {
    let mut _Faults = Vec::new();
    for _entry in entries {
        let _entityPrefix = _entry.id.split('.').next().unwrap_or("");
        let _expectedType = r0_patlib::_PrefixToType.get(_entityPrefix).copied().unwrap_or("");
        if _expectedType.is_empty() {
            _Faults.push(Fault {
                id: _entry.id.clone(),
                entity_type: _entry.entity_type.clone(),
                field: "prefix".to_string(),
                value: _entityPrefix.to_string(),
                problem: "unrecognized entity prefix".to_string(),
            });
        } else if _expectedType != _entry.entity_type {
            _Faults.push(Fault {
                id: _entry.id.clone(),
                entity_type: _entry.entity_type.clone(),
                field: "prefix".to_string(),
                value: format!("prefix {} → {}, file in {}", _entityPrefix, _expectedType, _entry.entity_type),
                problem: "prefix-type mismatch".to_string(),
            });
        }
    }
    _Faults
}
