// @pluginclass TRNS
import { appendFileSync, mkdirSync, existsSync } from "fs"
import { join } from "path"

const LOG_DIR = join(import.meta.dir, "..", "audit")
const LOG_PATH = join(LOG_DIR, "commands.log")

function ensureLogDir(): void {
  if (!existsSync(LOG_DIR)) mkdirSync(LOG_DIR, { recursive: true })
}

function formatTimestamp(): string {
  return new Date().toISOString()
}

function escapeNewlines(s: string): string {
  return s.replace(/\n/g, "\\n").replace(/\r/g, "\\r")
}

export const CmdAudit = async ({ client }: { client: any }) => {
  ensureLogDir()

  return {
    event: async ({ event }: { event: any }) => {
      if (event.type !== "command.executed") return

      const { name, arguments: cmd, sessionID } = event.properties
      if (!cmd) return

      const line = `[${formatTimestamp()}] ${sessionID} ${name}: ${escapeNewlines(cmd)}\n`

      try {
        appendFileSync(LOG_PATH, line, "utf-8")
      } catch (err) {
        await client.app.log({
          body: {
            level: "error",
            service: "cmd-audit",
            message: `write-error: ${(err as Error).message}`,
          },
        })
      }
    },
  }
}
