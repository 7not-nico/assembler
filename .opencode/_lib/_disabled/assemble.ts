// exports: parseFrontmatter, parseBackmatter, parseMetadata, idToType, typeToRing, rrf, entityTypes, validateFrontmatter
// purity: io (spawns Rust binary)
// depends-on: (none — calls assemble binary via Bun.spawnSync)
//
// Thin wrapper around the Rust `assemble` binary.
// Each function pipes data to the binary and returns parsed JSON.
// The binary lives at `_rustlib/target/release/assemble` relative to PATLIB_ROOT.

import { join } from "path"
import { PATLIB_ROOT } from "./paths"

const ASSEMBLE_BIN = join(PATLIB_ROOT, ".opencode", "_rustlib", "target", "release", "assemble")

function run(args: string[], input?: string): string {
  const result = Bun.spawnSync([ASSEMBLE_BIN, ...args], {
    input: input ?? undefined,
    env: { ...process.env },
  })
  if (result.exitCode !== 0) {
    throw new Error(`assemble failed (exit ${result.exitCode}): ${result.stderr.toString().trim()}`)
  }
  return result.stdout.toString().trim()
}

/** Parse YAML frontmatter from entity file text */
export function parseFrontmatter(text: string): Record<string, unknown> | null {
  try {
    return JSON.parse(run(["parse", "--text", text]))
  } catch { return null }
}

/** Parse YAML backmatter from entity file text */
export function parseBackmatter(text: string): Record<string, unknown> | null {
  try {
    const result = run(["parse", "--text", text])
    return JSON.parse(result)
  } catch { return null }
}

/** Try frontmatter first, fall back to backmatter */
export function parseMetadata(text: string): Record<string, unknown> | null {
  return parseFrontmatter(text) ?? parseBackmatter(text)
}

/** Look up entity type from a patlib ID */
export function idToType(id: string): { id: string; type: string } {
  return JSON.parse(run(["id-to-type", id]))
}

/** Look up ring info from entity type name */
export function typeToRing(typeName: string): { type: string; group: string; ring: number } {
  return JSON.parse(run(["type-to-ring", typeName]))
}

/** Merge ranked hits using Reciprocal Rank Fusion */
export function rrf(
  vectorHits: Array<{ entity_type: string; entity_id: string; rank: number }>,
  keywordHits: Array<{ entity_type: string; entity_id: string; rank: number }>,
  limit: number = 10,
): Array<{ entity_type: string; entity_id: string; score: number }> {
  return JSON.parse(run([
    "rrf",
    "--vector", JSON.stringify(vectorHits),
    "--keyword", JSON.stringify(keywordHits),
    "--limit", String(limit),
  ]))
}

/** List all recognized entity type names */
export function entityTypes(): string[] {
  return JSON.parse(run(["types"])).types
}

/** Validate frontmatter fields — returns violations array */
export function validateFrontmatter(text: string): { valid: boolean; violations: Array<{ field: string; error: string }> } {
  try {
    return JSON.parse(run(["validate", "--text", text]))
  } catch {
    return { valid: false, violations: [{ field: "parse", error: "no frontmatter found" }] }
  }
}
