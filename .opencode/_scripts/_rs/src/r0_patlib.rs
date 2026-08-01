//! PATLIB Id routing — port of _rb/patlib.rb
//! ring: 0 (PURE)
//! contract: _PatlibIdRe matches patlib entity Ids.
//!   _PrefixToType maps prefix to entity type name.
//! purity: pure (no I/O, no side effects)

use regex::Regex;
use std::collections::HashMap;
use std::sync::LazyLock;

pub static _PatlibIdRe: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"\A([A-Z]{2,})((?:\.[A-Z][A-Z0-9.\/-]*)+)").unwrap());

pub static _PrefixToType: LazyLock<HashMap<&'static str, &'static str>> = LazyLock::new(|| {
    let mut _prefixTable = HashMap::new();
    _prefixTable.insert("COG", "cognitions"); _prefixTable.insert("CON", "concepts");
    _prefixTable.insert("DEF", "definitions"); _prefixTable.insert("TAX", "taxonomies");
    _prefixTable.insert("TERM", "terms"); _prefixTable.insert("IDENTITY", "identities");
    _prefixTable.insert("BIO", "biology"); _prefixTable.insert("CHE", "chemistry");
    _prefixTable.insert("MAX", "maxims"); _prefixTable.insert("ABS", "abstractions");
    _prefixTable.insert("ALG", "algorithms"); _prefixTable.insert("LING", "linguistics");
    _prefixTable.insert("RUL", "rules"); _prefixTable.insert("NEX", "nexus");
    _prefixTable.insert("PROT", "protocols"); _prefixTable.insert("PAT", "patterns");
    _prefixTable.insert("ILL", "illustrations"); _prefixTable.insert("REF", "references");
    _prefixTable.insert("PER", "persons"); _prefixTable.insert("PRE", "precepts");
    _prefixTable.insert("SPEC", "specifications"); _prefixTable.insert("INV", "investigations");
    _prefixTable.insert("APO", "apologias"); _prefixTable.insert("MAN", "manifests");
    _prefixTable.insert("ARC", "archives"); _prefixTable.insert("NOTE", "notes");
    _prefixTable
});

/// Extract prefix from a PATLIB entity Id
pub fn idPrefix(Id: &str) -> Option<&str> {
    _PatlibIdRe
        .captures(Id)
        .and_then(|capture| capture.get(1))
        .map(|matched| matched.as_str())
}

/// Map entity Id to its type name, e.g. "PROT.TOOL.CUSTOM" -> Some("protocols")
pub fn idToType(Id: &str) -> Option<&'static str> {
    idPrefix(Id).and_then(|prefix| _PrefixToType.get(prefix).copied())
}

/// Map entity Id to its ring information via type lookup
pub fn idToRingInfo(Id: &str) -> Option<(&'static str, u32)> {
    let resolvedType = idToType(Id)?;
    crate::r0_rings::typeToRing(resolvedType)
}

/// Map source field (which is a PATLIB Id) to ring information
pub fn sourceToRingInfo(sourceIdentifier: &str) -> Option<(&'static str, u32)> {
    idToRingInfo(sourceIdentifier)
}
