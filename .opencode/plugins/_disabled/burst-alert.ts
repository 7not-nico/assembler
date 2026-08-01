// @pluginclass TRNS
import { existsSync } from "fs"
import { join } from "path"
import { checkBurst, resetState } from "../_lib/burst-detect"

const ROOT = join(import.meta.dir, "..")
const AUDIO = join(ROOT, "objects", "medabots-opening.mp3")

const WATCHED_DIRS = new Set([".opencode", "objects", "src", "stud"])
let alertCount = 0

export const BurstAlert = async ({ client }: { client: any }) => {
  return {
    "file.edited": async ({ event }: { event: { filePath: string } }) => {
      const fp = event.filePath
      if (!WATCHED_DIRS.has(fp.split("/")[0])) return
      if (fp.includes("node_modules") || fp.includes(".git")) return
      if (!checkBurst(fp)) return
      alertCount++
      if (existsSync(AUDIO)) {
        try {
          Bun.spawn(["paplay", AUDIO], { stderr: "ignore", stdout: "ignore" })
        } catch {}
      }
      await client.app.log({
        body: {
          level: "info",
          service: "burst-alert",
          message: `burst #${alertCount} — rapid file changes detected`,
        },
      })
    },
    dispose: async () => {
      resetState()
    },
  }
}
