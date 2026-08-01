// exports: PATLIB_ROOT, DB_PATH, SCHEMAS_DIR, PATTERNS_DIR, TERMS_DIR, BIO_DIR, CHEM_DIR, COGNITIONS_DIR, CONCEPTS_DIR, DEFINITIONS_DIR, SKILLS_DIR, APOLOGIAS_DIR, RULES_DIR, COMMANDS_YAML_DIR, PROTOCOLS_DIR, REFS_DIR, ABSTRACTIONS_DIR, PERSONS_DIR, ILLUSTRATIONS_DIR, MAXIMS_DIR, NEXUS_DIR, ML_DIR, BASH_DIR, RUBY_DIR, PRECEPTS_DIR, MCP_DB_PATH, MCP_SCHEMA_PATH, LLM_SPEC_SCHEMA_PATH, SEPARATOR
// purity: io
// depends-on: fs, path

import { existsSync } from "fs"
import { join, dirname } from "path"

function findRoot(marker: string): string {
  let dir = import.meta.dir
  while (dir !== '/') {
    if (existsSync(join(dir, '.opencode', marker))) return dir
    dir = dirname(dir)
  }
  return join(import.meta.dir, '..', '..')
}

export const PATLIB_ROOT = findRoot('_lib/paths.ts')
export const DB_PATH = join(PATLIB_ROOT, ".opencode", "patlib.db")
export const SCHEMAS_DIR = join(PATLIB_ROOT, ".opencode", "_schemas")
export const SEEDS_DIR = join(PATLIB_ROOT, ".opencode", "_schemas", "seeds")
export const ENTITIES_DIR = join(PATLIB_ROOT, ".opencode", "entities")
export const PATTERNS_DIR = join(ENTITIES_DIR, "patterns")
export const TERMS_DIR = join(ENTITIES_DIR, "terms")
export const BIO_DIR = join(ENTITIES_DIR, "biology")
export const CHEM_DIR = join(ENTITIES_DIR, "chemistry")
export const COGNITIONS_DIR = join(ENTITIES_DIR, "cognitions")
export const CONCEPTS_DIR = join(ENTITIES_DIR, "concepts")
export const DEFINITIONS_DIR = join(ENTITIES_DIR, "definitions")
export const SKILLS_DIR = join(PATLIB_ROOT, ".opencode", "skills")
export const APOLOGIAS_DIR = join(ENTITIES_DIR, "apologias")
export const RULES_DIR = join(PATLIB_ROOT, ".opencode", "rules", "yamls")
export const COMMANDS_YAML_DIR = join(PATLIB_ROOT, ".opencode", "commands", "yamls")
export const PROTOCOLS_DIR = join(ENTITIES_DIR, "protocols")
export const REFS_DIR = join(ENTITIES_DIR, "references")
export const ABSTRACTIONS_DIR = join(ENTITIES_DIR, "abstractions")
export const LINGUISTICS_DIR = join(ENTITIES_DIR, "linguistics")
export const PERSONS_DIR = join(ENTITIES_DIR, "persons")
export const IDENTITIES_DIR = join(ENTITIES_DIR, "identities")
export const ILLUSTRATIONS_DIR = join(ENTITIES_DIR, "illustrations")
export const NEXUS_DIR = join(ENTITIES_DIR, "nexus")
export const TAXONOMY_DIR = join(ENTITIES_DIR, "taxonomies")
export const ML_DIR = join(ENTITIES_DIR, "machine-learning")
export const BASH_DIR = join(ENTITIES_DIR, "bash")
export const RUBY_DIR = join(ENTITIES_DIR, "ruby")
export const MAXIMS_DIR = join(ENTITIES_DIR, "maxims")
export const PRECEPTS_DIR = join(ENTITIES_DIR, "precepts")
export const MANIFESTS_DIR = join(ENTITIES_DIR, "manifests")
export const SPECIFICATIONS_DIR = join(ENTITIES_DIR, "specifications")
export const MCP_DB_PATH = join(PATLIB_ROOT, ".opencode", "mcp-search.db")
export const MCP_SCHEMA_PATH = join(PATLIB_ROOT, ".opencode", "_schemas", "mcp.sql")
export const LLM_SPEC_SCHEMA_PATH = join(PATLIB_ROOT, ".opencode", "_schemas", "llm-spec.sql")
export const SESSIONS_DB_PATH = join(PATLIB_ROOT, ".opencode", "sessions.db")
export const SEPARATOR = "-".repeat(60)
