// @pluginclass TRNS
import { initDB } from "../_lib/db"
import { syncAll } from "../_lib/sync"

const debounceTimers = new Map<string, ReturnType<typeof setTimeout>>()
const DEBOUNCE_MS = 2000

const PATH_TO_TYPE: Record<string, string> = {
  ".opencode/terms/": "terms",
  ".opencode/protocols/": "protocols",
}

function triggerSync(type: string, client: any) {
  if (debounceTimers.has(type)) clearTimeout(debounceTimers.get(type))
  debounceTimers.set(
    type,
    setTimeout(() => {
      debounceTimers.delete(type)
      try {
        const db = initDB()
        const result = syncAll(db, type)
        db.close()
        client.app.log({
          body: {
            level: "info",
            service: "auto-sync",
            message: `synced ${type}: ${result}`,
          },
        })
      } catch (err) {
        client.app.log({
          body: {
            level: "error",
            service: "auto-sync",
            message: String(err),
          },
        })
      }
    }, DEBOUNCE_MS),
  )
}

export const AutoSync = async ({ client }: { client: any }) => {
  return {
    "file.edited": async ({ event }: { event: { filePath: string } }) => {
      const filePath = event.filePath
      const match = Object.entries(PATH_TO_TYPE).find(([prefix]) =>
        filePath.includes(prefix)
      )
      if (!match) return
      triggerSync(match[1], client)
    },
    "tool.execute.after": async (input: { tool: string; args: any }) => {
      const filePath = input.args?.filePath
      if (!filePath || typeof filePath !== "string") return
      const match = Object.entries(PATH_TO_TYPE).find(([prefix]) =>
        filePath.includes(prefix)
      )
      if (!match) return
      triggerSync(match[1], client)
    },
  }
}
