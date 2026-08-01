// purity: pure
// depends-on: none

export interface EventLink {
  event_id: string;
  person_id: string;
}

export interface EventUsageReport {
  unused: string[];
  lonely: { event: string; person: string }[];
}

export function validateEventUsage(
  allEventIds: string[],
  currentLinks: EventLink[]
): EventUsageReport {
  const personCount = new Map<string, Set<string>>()
  for (const link of currentLinks) {
    if (!personCount.has(link.event_id)) personCount.set(link.event_id, new Set())
    personCount.get(link.event_id)!.add(link.person_id)
  }

  const unused: string[] = []
  const lonely: { event: string; person: string }[] = []

  for (const id of allEventIds) {
    const persons = personCount.get(id)
    if (!persons || persons.size === 0) {
      unused.push(id)
    } else if (persons.size === 1) {
      lonely.push({ event: id, person: [...persons][0] })
    }
  }

  unused.sort()
  lonely.sort((a, b) => a.event.localeCompare(b.event))

  return { unused, lonely }
}
