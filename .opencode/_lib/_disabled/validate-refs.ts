// purity: pure
// depends-on: none

export interface RefLink {
  source_type: string;
  source_id: string;
  target_id: string;
}

export interface RefIntegrityReport {
  orphanTerms: RefLink[];
  orphanPatterns: RefLink[];
}

export function validateRefIntegrity(
  termLinks: RefLink[],
  patternLinks: RefLink[],
  validTermIds: string[],
  validPatternIds: string[]
): RefIntegrityReport {
  const termSet = new Set(validTermIds)
  const patternSet = new Set(validPatternIds)

  const orphanTerms = termLinks
    .filter(l => !termSet.has(l.target_id))

  const orphanPatterns = patternLinks
    .filter(l => !patternSet.has(l.target_id))

  return { orphanTerms, orphanPatterns }
}
