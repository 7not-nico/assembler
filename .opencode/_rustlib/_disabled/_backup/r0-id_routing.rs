// ring: 0 (PURE)
//! Entity id to type routing

use regex::Regex;
use std::collections::HashMap;
use std::sync::LazyLock;

pub static PatlibIdRe: LazyLock<Regex> =
    LazyLock::new(|| Regex::new(r"\A([A-Z]{2,})((?:\.[A-Z][A-Z0-9.\/-]*)+)").unwrap());

pub static PrefixToType: LazyLock<HashMap<&'static str, &'static str>> = LazyLock::new(|| {
    let mut m = HashMap::new();
    m.insert("COG", "cognitions"); m.insert("CON", "concepts");
    m.insert("DEF", "definitions"); m.insert("TAX", "taxonomies");
    m.insert("TERM", "terms"); m.insert("IDENTITY", "identities");
    m.insert("BIO", "biology"); m.insert("CHE", "chemistry");
    m.insert("MAX", "maxims"); m.insert("ABS", "abstractions");
    m.insert("ALG", "algorithms"); m.insert("LING", "linguistics");
    m.insert("RUL", "rules"); m.insert("NEX", "nexus");
    m.insert("PROT", "protocols"); m.insert("PAT", "patterns");
    m.insert("ILL", "illustrations"); m.insert("REF", "references");
    m.insert("PER", "persons"); m.insert("PRE", "precepts");
    m.insert("SPEC", "specifications"); m.insert("INV", "investigations");
    m.insert("APO", "apologias"); m.insert("MAN", "manifests");
    m.insert("ARC", "archives"); m.insert("NOTE", "notes");
    m
});

/// Prefix portion of a patlib id
pub fn prefix(id: &str) -> Option<&str> {
    PatlibIdRe.captures(id).and_then(|c| c.get(1)).map(|m| m.as_str())
}

/// Entity type for a patlib id
pub fn entitytype(id: &str) -> Option<&'static str> {
    prefix(id).and_then(|p| PrefixToType.get(p).copied())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_prefix() {
        assert_eq!(prefix("MAX.DRY"), Some("MAX"));
    }

    #[test]
    fn test_entitytype() {
        assert_eq!(entitytype("MAX.DRY"), Some("maxims"));
    }
}
