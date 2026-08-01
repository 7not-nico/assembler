// exports: entitySourcePath, entityMtime
// purity: io (filesystem reads, depends on paths)
// depends-on: paths, fs

import { existsSync, statSync } from "fs"
import { join, dirname } from "path"
import {
  PATTERNS_DIR, TERMS_DIR, COGNITIONS_DIR, CONCEPTS_DIR, DEFINITIONS_DIR,
  SKILLS_DIR, APOLOGIAS_DIR, RULES_DIR, COMMANDS_YAML_DIR,
  PROTOCOLS_DIR, ABSTRACTIONS_DIR, LINGUISTICS_DIR, PERSONS_DIR,
  ILLUSTRATIONS_DIR, MAXIMS_DIR, TAXONOMY_DIR, ML_DIR, BASH_DIR, RUBY_DIR,
} from "./paths"

const TYPE_SOURCE_DIRS: Record<string, string> = {
  patterns: PATTERNS_DIR, maxims: MAXIMS_DIR,
  terms: TERMS_DIR, cognitions: COGNITIONS_DIR,
  concepts: CONCEPTS_DIR, definitions: DEFINITIONS_DIR,
  protocols: PROTOCOLS_DIR, illustrations: ILLUSTRATIONS_DIR,
  abstractions: ABSTRACTIONS_DIR, linguistics: LINGUISTICS_DIR,
  apologias: APOLOGIAS_DIR, persons: PERSONS_DIR,
  taxonomy: TAXONOMY_DIR,
  ml: ML_DIR,
  bash: BASH_DIR,
  ruby: RUBY_DIR,
}

export function entitySourcePath(type: string, id: string): string[] {
  const dir = TYPE_SOURCE_DIRS[type]
  if (dir) {
    const p = join(dir, `${id}.md`)
    return existsSync(p) ? [p] : []
  }
  if (type === "skills") {
    const name = id.replace(/^SKL\./, "").toLowerCase().replace(/\./g, "-")
    const p = join(SKILLS_DIR, name, "SKILL.md")
    return existsSync(p) ? [p] : []
  }
  if (type === "rules") {
    const yml = join(RULES_DIR, `${id}.yaml`)
    const md = join(dirname(RULES_DIR), `${id}.md`)
    const paths: string[] = []
    if (existsSync(yml)) paths.push(yml)
    if (existsSync(md)) paths.push(md)
    return paths
  }
  if (type === "commands") {
    const p = join(COMMANDS_YAML_DIR, `${id}.yaml`)
    return existsSync(p) ? [p] : []
  }
  return []
}

export function entityMtime(type: string, id: string): string | null {
  const paths = entitySourcePath(type, id)
  if (paths.length === 0) return null
  let latest = 0
  for (const p of paths) {
    const st = statSync(p)
    if (st.mtimeMs > latest) latest = st.mtimeMs
  }
  return new Date(latest).toISOString()
}
