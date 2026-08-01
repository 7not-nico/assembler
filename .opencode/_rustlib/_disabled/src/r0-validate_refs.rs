// ring: 0 (PURE)
//! Reference link integrity validation
//! port of _lib/validate-refs.ts

/// A cross-reference link between entities
#[derive(Debug, Clone)]
pub struct ReferenceLink {
    pub sourceType: String,
    pub sourceId: String,
    pub targetId: String,
}

/// Report of orphaned reference links
#[derive(Debug, Clone)]
pub struct ReferenceIntegrityReport {
    pub orphanTerms: Vec<ReferenceLink>,
    pub orphanPatterns: Vec<ReferenceLink>,
}

/// Reference integrity check across term and pattern links
pub fn referenceIntegrity(
    termLinks: &[ReferenceLink],
    patternLinks: &[ReferenceLink],
    validTermIds: &[String],
    validPatternIds: &[String],
) -> ReferenceIntegrityReport {
    let termSet: std::collections::HashSet<&str> = validTermIds.iter().map(|s| s.as_str()).collect();
    let patternSet: std::collections::HashSet<&str> = validPatternIds.iter().map(|s| s.as_str()).collect();

    let orphanTerms: Vec<ReferenceLink> = termLinks.iter()
        .filter(|link| !termSet.contains(link.targetId.as_str()))
        .cloned()
        .collect();

    let orphanPatterns: Vec<ReferenceLink> = patternLinks.iter()
        .filter(|link| !patternSet.contains(link.targetId.as_str()))
        .cloned()
        .collect();

    ReferenceIntegrityReport { orphanTerms, orphanPatterns }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_reference_integrity_clean() {
        let result = referenceIntegrity(&[], &[], &["TERM.A".to_string()], &[]);
        assert!(result.orphanTerms.is_empty());
        assert!(result.orphanPatterns.is_empty());
    }

    #[test]
    fn test_reference_integrity_orphan_term() {
        let link = ReferenceLink {
            sourceType: "protocols".to_string(),
            sourceId: "PROT.TEST".to_string(),
            targetId: "TERM.MISSING".to_string(),
        };
        let result = referenceIntegrity(&[link], &[], &["TERM.A".to_string()], &[]);
        assert_eq!(result.orphanTerms.len(), 1);
    }
}
