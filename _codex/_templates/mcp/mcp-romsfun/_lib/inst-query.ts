// exports: WRAPPERS_DIR, SCHEMA_MCP_TIMEOUT, runScript
// purity: io
// The MCP wrapper resolves _codex from its own location (mcp/mcp-romsfun
// → _templates → _codex), then execs the shared wrapper scripts under
// _templates/wrapper/. Each wrapper resolves _codex itself and delegates to
// the canonical instantiator implementation; keyed result lines pass through.
// Constants come from the schema (instantiator/romsfun/schema/seed.sql) via
// lookup.sh — never hardcoded here.
import { execFileSync } from "node:child_process"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

const HERE = dirname(fileURLToPath(import.meta.url))

// _codex/_templates/wrapper (three levels up from mcp/mcp-romsfun/)
export const WRAPPERS_DIR = join(HERE, "..", "..", "..", "wrapper")

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

export const SCHEMA_MCP_TIMEOUT = Number(schemaValue("SCHEMA_MCP_TIMEOUT")) || 180

export interface ScriptOutcome {
  ok: boolean
  exit: number
  stdout: string
  stderr: string
}

export function runScript(script: string, args: string[], timeoutSec = SCHEMA_MCP_TIMEOUT): ScriptOutcome {
  const scriptPath = join(WRAPPERS_DIR, script)
  try {
    const stdout = execFileSync("bash", [scriptPath, ...args], {
      encoding: "utf8",
      timeout: timeoutSec * 1000,
      maxBuffer: 32 * 1024 * 1024,
      stdio: ["ignore", "pipe", "pipe"],
    })
    return { ok: true, exit: 0, stdout: stdout.trim(), stderr: "" }
  } catch (err: any) {
    const e = err as { status?: number; stdout?: string; stderr?: string; message?: string }
    return {
      ok: false,
      exit: e.status ?? 1,
      stdout: (e.stdout ?? "").toString().trim(),
      stderr: (e.stderr ?? e.message ?? "script failed").toString().trim(),
    }
  }
}
