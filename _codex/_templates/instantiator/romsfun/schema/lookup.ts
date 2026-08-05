// lookup.ts — the TS citation bridge for shell_values (seed.sql)
// purity: pure (reads the seed once at load, exports typed constants)
// The constants' home is instantiator/romsfun/schema/seed.sql. This module
// parses its INSERT rows and exports each as a typed SCHEMA_* constant —
// the TS-side link in the citation chain. Fail loudly: a missing key throws,
// never falls back. MCP query libs import this instead of shelling to bash.
import { readFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const SEED = join(HERE, "seed.sql");

// key -> value from the INSERT OR IGNORE rows: ('KEY', 'value', 'desc')
function loadSeed(): Map<string, string> {
  const map = new Map<string, string>();
  const sql = readFileSync(SEED, "utf8");
  for (const line of sql.split("\n")) {
    const m = /^\s*\('([A-Z0-9_]+)', '((?:[^'\\]|\\.)*)',/.exec(line);
    if (m) map.set(m[1], m[2]);
  }
  return map;
}

const seed = loadSeed();

export function schemaValue(key: string): string {
  const v = seed.get(key);
  if (v === undefined) throw new Error(`schema miss: ${key} not in ${SEED}`);
  return v;
}

// ── typed exports (the values the MCP layer cites) ──

export const SCHEMA_MCP_TIMEOUT = Number(schemaValue("MCP_TIMEOUT"));
export const SCHEMA_MCP_MAX_BUFFER = Number(schemaValue("MCP_MAX_BUFFER"));
