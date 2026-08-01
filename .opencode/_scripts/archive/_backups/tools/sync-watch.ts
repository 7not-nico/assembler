#!/usr/bin/env bun
import { watch } from "fs"
import { join } from "path"
import { initDB, PATTERNS_DIR, TERMS_DIR } from "../_lib/db"
import { syncAll } from "../_lib/sync"

const NO_WATCH = process.env.NO_WATCH === "1"
const dirs = [PATTERNS_DIR, TERMS_DIR]
let timer: Timer | null = null

console.log(`Watching ${dirs.join(", ")} for .md changes...`)
console.log("Press Ctrl-C to stop.")

if (!NO_WATCH) {
  for (const dir of dirs) {
    watch(dir, (event, filename) => {
      if (!filename || !filename.endsWith(".md")) return
      if (timer) clearTimeout(timer)
      timer = setTimeout(() => {
        console.log(`Change detected: ${join(dir, filename)}`)
        try {
          const db = initDB()
          const result = syncAll(db)
          db.close()
          console.log(result)
        } catch (e) {
          console.error("Sync error:", e)
        }
      }, 300)
    })
  }

  process.on("SIGINT", () => {
    console.log("\nStopping watcher.")
    process.exit(0)
  })
}
