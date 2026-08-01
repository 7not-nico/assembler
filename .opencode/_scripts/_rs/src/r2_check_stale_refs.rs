#![allow(non_snake_case)]
//! Stale cross-reference check — detect references to non-existent entity Ids in .md files
//! ring: 2 (LOCAL-READ)
//! contract: regex-scan all .md files for entity Id patterns,
//!   flag Ids that don't exist in the current entity set.
//! purity: io (reads all .md files via WalkDir)

use std::collections::HashSet;
use crate::r2_entity::EntityEntry;
use crate::r2_paths;
use crate::r0_violation::Fault;

fn isFalsePositive(entityIdentifier: &str) -> bool {
    let _lowerCased = entityIdentifier.to_lowercase();
    let falsePositivePatterns = [
        "pat.no.env", "pat.file.as", "pat.no.relative", "pat.no.shared",
        "pat.patlib.query", "pat.study.after", "pat.schema.as",
        "pat.yaml.inline", "pat.read.vs",
        "ill.entity.pipeline", "nex.entity.pipeline",
        "prot.meta.project.structure", "prot.meta.toon",
    ];
    falsePositivePatterns.iter().any(|pattern| _lowerCased.contains(pattern))
}

pub fn checkStaleRefs(entries: &[EntityEntry]) -> Vec<Fault> {
    let mut _Faults = Vec::new();
    let _knownIdentifiers: HashSet<&str> = entries.iter().map(|entry| entry.id.as_str()).collect();

    let _projectRoot = r2_paths::_Root.clone();
    let _EntityPattern = regex::Regex::new(r"\b(PROT|PAT|NEX|ILL|REF|MAX|SPEC|PER|COG|CON|DEF|TERM|SKL|CMD|RUL|PRE|ABS|LING|BIO|CHE|TAX|ML|INV|APO|MAN|ARC|NOTE)\.[A-Z][A-Z0-9.]*").unwrap();

    for directoryEntry in walkdir::WalkDir::new(&_projectRoot).into_iter().filter_map(|_result| _result.ok()) {
        if !directoryEntry.file_type().is_file() || !directoryEntry.file_name().to_string_lossy().ends_with(".md") {
            continue;
        }
        let relativePath = directoryEntry.path().to_string_lossy();
        if relativePath.contains("target/") || relativePath.contains("node_modules/") || relativePath.contains(".git/") {
            continue;
        }
        let fileContent = match std::fs::read_to_string(directoryEntry.path()) {
            Ok(fileContent) => fileContent,
            Err(_) => continue,
        };
        let mut _flaggedIdentifiers: HashSet<String> = HashSet::new();
        for capture in _EntityPattern.captures_iter(&fileContent) {
            let _matchedText = match capture.get(0) {
                Some(matched) => matched.as_str(),
                None => continue,
            };
            if _matchedText.split('.').count() < 3 { continue; }
            if _knownIdentifiers.contains(_matchedText) { continue; }
            if isFalsePositive(_matchedText) { continue; }
            if _flaggedIdentifiers.insert(_matchedText.to_string()) {
                let filePath = directoryEntry.path().strip_prefix(&_projectRoot).unwrap_or(directoryEntry.path());
                _Faults.push(Fault {
                    id: _matchedText.to_string(),
                    entity_type: "crossref".to_string(),
                    field: "reference".to_string(),
                    value: filePath.to_string_lossy().to_string(),
                    problem: "potential stale reference to non-existent entity".to_string(),
                });
            }
        }
    }
    _Faults
}
