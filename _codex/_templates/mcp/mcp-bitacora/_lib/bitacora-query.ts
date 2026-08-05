// exports: ENABLER_PATH, SCHEMA_MCP_TIMEOUT, runEnabler
// purity: io
// The MCP bitacora server resolves _codex from its own location
// (mcp/mcp-bitacora → _templates → _codex), then execs the shared enabler
// under wrapper/enabler/bitacora.sh — the alias-citing shim over the
// _shared/bin/bitacora Go binary. Keyed result lines pass through.
// Constants come from the schema (instantiator/romsfun/schema/seed.sql) via
// lookup.sh — never hardcoded here.
import { execFileSync } from "node:child_process"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

const HERE = dirname(fileURLToPath(import.meta.url))

// _codex/_templates/wrapper/enabler/bitacora.sh (three levels up)
export const ENABLER_PATH = join(HERE, "..", "..", "..", "wrapper", "enabler", "bitacora.sh")

// _codex/_templates/instantiator/romsfun/schema/lookup.sh (five levels up)
const SCHEMA_LOOKUP = join(HERE, "..", "..", "..", "instantiator", "romsfun", "schema", "lookup.sh")

// cite the schema once at load: source lookup.sh, read the SCHEMA_* var
function schemaValue(key: string): string {
  const out = execFileSync("bash", ["-c", `. "${SCHEMA_LOOKUP}"; printf '%s' "\$${key}"`], {
    encoding: "utf8",
    stdio: ["ignore", "pipe", "pipe"],
  })
  return out.trim()
}

// constants come from the schema only — a missing schema fails loudly, no fallback
export const SCHEMA_MCP_TIMEOUT = Number(schemaValue("SCHEMA_MCP_TIMEOUT"))
export const SCHEMA_MCP_MAX_BUFFER = Number(schemaValue("SCHEMA_MCP_MAX_BUFFER"))

export interface EnablerOutcome {
  ok: boolean
  exit: number
  stdout: string
  stderr: string
}

export function runEnabler(args: string[], timeoutSec = SCHEMA_MCP_TIMEOUT): EnablerOutcome {
  try {
    const stdout = execFileSync("bash", [ENABLER_PATH, ...args], {
      encoding: "utf8",
      timeout: timeoutSec * 1000,
      maxBuffer: SCHEMA_MCP_MAX_BUFFER,
      stdio: ["ignore", "pipe", "pipe"],
    })
    return { ok: true, exit: 0, stdout: stdout.trim(), stderr: "" }
  } catch (err: unknown) {
    const e = err as { status?: number; stdout?: Buffer; stderr?: Buffer; message?: string }
    return {
      ok: false,
      exit: e.status ?? 1,
      stdout: (e.stdout?.toString() ?? "").trim(),
      stderr: (e.stderr?.toString() ?? e.message ?? "").trim(),
    }
  }
}
