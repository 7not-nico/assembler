#![allow(non_snake_case)]
//! Entity precedes check — precedes targets must exist with no dependency cycles
//! ring: 2 (LOCAL-READ)
//! contract: every precedes target must be an existing entity Id.
//!   Tortoise-Hare cycle detection on precedes chains.
//! purity: io (reads EntityEntry fields)

use std::collections::{HashMap, HashSet};
use crate::r2_entity::EntityEntry;
use crate::r0_violation::Fault;

pub fn checkPrecedes(entries: &[EntityEntry]) -> (Vec<Fault>, Vec<String>) {
    let mut _Faults = Vec::new();
    let mut _detectedCycles = Vec::new();

    let _entityTable: HashMap<&str, &str> = entries.iter().map(|entry| (entry.id.as_str(), entry.entity_type.as_str())).collect();

    // Build precedes lookup table
    let mut _precedesTable: HashMap<&str, Vec<String>> = HashMap::new();
    for _entry in entries {
        if let Some(ref precedesList) = _entry.frontmatter.precedes {
            _precedesTable.insert(_entry.id.as_str(), precedesList.clone());
        }
    }

    // Check each precedes target exists
    for _entry in entries {
        let _targetList = match &_entry.frontmatter.precedes {
            Some(_targetList) => _targetList,
            None => continue,
        };
        for targetIdentifier in _targetList {
            if !_entityTable.contains_key(targetIdentifier.as_str()) {
                _Faults.push(Fault {
                    id: _entry.id.clone(),
                    entity_type: _entry.entity_type.clone(),
                    field: "precedes".to_string(),
                    value: targetIdentifier.clone(),
                    problem: "precedes target not found among entities".to_string(),
                });
            }
        }
    }

    // Cycle detection using Tortoise-Hare algorithm
    let mut _visitedIdentifiers: HashSet<&str> = HashSet::new();
    for _startIdentifier in _entityTable.keys() {
        if _visitedIdentifiers.contains(_startIdentifier) {
            continue;
        }
        let mut _traversalPath: Vec<&str> = Vec::new();
        let mut _currentIdentifier = Some(*_startIdentifier);
        loop {
            let _currentId = match _currentIdentifier {
                Some(_currentId) => _currentId,
                None => break,
            };
            if !_entityTable.contains_key(_currentId) {
                break;
            }
            if _traversalPath.contains(&_currentId) {
                let _cycleIndex = _traversalPath.iter().position(|&_visitedId| _visitedId == _currentId).unwrap();
                _detectedCycles.push(_traversalPath[_cycleIndex..].to_vec().join(" → "));
                break;
            }
            _visitedIdentifiers.insert(_currentId);
            _traversalPath.push(_currentId);
            _currentIdentifier = _precedesTable.get(_currentId).and_then(|_targetList| _targetList.first().map(|_firstTarget| _firstTarget.as_str()));
        }
    }

    (_Faults, _detectedCycles)
}
