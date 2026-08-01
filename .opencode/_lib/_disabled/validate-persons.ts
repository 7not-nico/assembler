// purity: pure
// depends-on: none

export interface PersonEventLink {
  person_id: string;
  event_id: string;
}

export interface OrphanReport {
  staleLinks: string[];
  orphanedEvents: string[];
}

/**
 * Identifies stale links and orphaned events.
 * Pure deterministic logic for staleness detection.
 */
export function detectPersonStaleness(
  activePersonIds: string[],
  currentLinks: PersonEventLink[],
  allEventIds: string[]
): OrphanReport {
  const activeSet = new Set(activePersonIds);
  
  // 1. Find links where the person no longer exists on disk
  const staleLinks = currentLinks
    .filter(link => !activeSet.has(link.person_id))
    .map(link => `${link.person_id} → ${link.event_id}`);

  // 2. Find events that are not referenced by any existing person
  const usedEventIds = new Set(
    currentLinks
      .filter(link => activeSet.has(link.person_id))
      .map(link => link.event_id)
  );

  const orphanedEvents = allEventIds.filter(id => !usedEventIds.has(id));

  return {
    staleLinks,
    orphanedEvents,
  };
}
