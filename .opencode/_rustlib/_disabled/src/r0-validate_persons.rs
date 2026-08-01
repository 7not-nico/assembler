// ring: 0 (PURE)
//! Person event link staleness detection
//! port of _lib/validate-persons.ts
//! Function names are concrete singular nouns, not verbs

/// A link between a person entity and an event
#[derive(Debug, Clone)]
pub struct PersonEventLink {
    pub personId: String,
    pub eventId: String,

}

/// Report of stale links and orphaned events
#[derive(Debug, Clone)]
pub struct StalenessReport {
    pub staleLinks: Vec<String>,
    pub orphanedEvents: Vec<String>,
}

/// Staleness detection across person-event links
pub fn personStaleness(
    activePersonIds: &[String],
    currentLinks: &[PersonEventLink],
    allEventIds: &[String],
) -> StalenessReport {
    let activeSet: std::collections::HashSet<&str> = activePersonIds.iter().map(|s| s.as_str()).collect();

    let staleLinks: Vec<String> = currentLinks.iter()
        .filter(|link| !activeSet.contains(link.personId.as_str()))
        .map(|link| format!("{} → {}", link.personId, link.eventId))
        .collect();

    let usedEventIds: std::collections::HashSet<&str> = currentLinks.iter()
        .filter(|link| activeSet.contains(link.personId.as_str()))
        .map(|link| link.eventId.as_str())
        .collect();

    let orphanedEvents: Vec<String> = allEventIds.iter()
        .filter(|id| !usedEventIds.contains(id.as_str()))
        .cloned()
        .collect();

    StalenessReport { staleLinks, orphanedEvents }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_staleness_empty() {
        let result = personStaleness(&[], &[], &[]);
        assert!(result.staleLinks.is_empty());
        assert!(result.orphanedEvents.is_empty());
    }

    #[test]
    fn test_staleness_detects_orphan() {
        let result = personStaleness(
            &["PER.ALICE".to_string()],
            &[PersonEventLink { personId: "PER.BOB".to_string(), eventId: "EVT.X".to_string() }],
            &["EVT.X".to_string()],
        );
        assert_eq!(result.staleLinks.len(), 1);
        assert_eq!(result.orphanedEvents.len(), 0); // EVT.X still linked (just stale person)
    }

    #[test]
    fn test_staleness_detects_orphaned_event() {
        let result = personStaleness(
            &["PER.ALICE".to_string()],
            &[],
            &["EVT.UNUSED".to_string()],
        );
        assert_eq!(result.orphanedEvents.len(), 1);
    }
}
