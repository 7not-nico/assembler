// exports: validateEntityContent
// purity: pure
// depends-on: parse

import { validateEntityFile } from "./parse"

export function validateEntityContent(
  text: string,
  type: "pattern" | "term" | "skill" | "apologia" | "protocol" | "ref" | "nexus" | "person" | "illustration" | "maxim" | "ml" | "bash" | "ruby",
  validStateProfiles: readonly string[],
): string[] {
  const violations: string[] = []

  const r = validateEntityFile(text, type)
  if (!r.yaml) violations.push(...r.violations)

  if (type === "skill" && r.yaml) {
    const profile = (r.yaml as Record<string, unknown>)["state-profile"]
    if (profile && !validStateProfiles.includes(profile as string)) {
      violations.push(`Invalid state-profile '${profile}'`)
    }
  }

  return violations
}
