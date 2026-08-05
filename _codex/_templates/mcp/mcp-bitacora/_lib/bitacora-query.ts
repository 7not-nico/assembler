// exports: ENABLER_PATH, runEnabler
// purity: io
// The MCP bitacora server resolves _codex from its own location
// (mcp/mcp-bitacora → _templates → _codex), then execs the shared enabler
// under wrapper/enabler/bitacora.sh — the alias-citing shim over the
// _shared/bin/bitacora Go binary. Keyed result lines pass through.
import { execFileSync } from "node:child_process"
import { dirname, join } from "node:path"
import { fileURLToPath } from "node:url"

const HERE = dirname(fileURLToPath(import.meta.url))

// _codex/_templates/wrapper/enabler/bitacora.sh (three levels up)
export const ENABLER_PATH = join(HERE, "..", "..", "..", "wrapper", "enabler", "bitacora.sh")

export interface EnablerOutcome {
  ok: boolean
  exit: number
  stdout: string
  stderr: string
}

export function runEnabler(args: string[], timeoutSec = 180): EnablerOutcome {
  try {
    const stdout = execFileSync("bash", [ENABLER_PATH, ...args], {
      encoding: "utf8",
      timeout: timeoutSec * 1000,
      maxBuffer: 32 * 1024 * 1024,
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
