#!/usr/bin/env bun
// exports: (none — CLI entrypoint)
// purity: io
// depends-on: @modelcontextprotocol/sdk, zod, fs, path, _lib/burst-detect

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js"
import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js"
import { z } from "zod"
import { watch, existsSync, readFileSync, writeFileSync } from "fs"
import { join } from "path"
import {
  checkBurst, BurstState, defaultState,
  SLIDING_WINDOW_MS, BURST_THRESHOLD, COOLDOWN_MS,
} from "../../_lib/burst-detect"

const ROOT = join(import.meta.dir, "..", "..", "..")
const AUDIO = join(ROOT, "objects", "medabots-opening.mp3")
const STATE_PATH = join(ROOT, ".opencode", ".burst-state.json")
const CONFIG_PATH = join(ROOT, ".opencode", "burst-config.json")
const SKIP_DIRS = new Set([".git", "node_modules", ".backups", "backups", "_backups"])

function readDuration(): number {
  try {
    if (existsSync(CONFIG_PATH)) {
      const cfg = JSON.parse(readFileSync(CONFIG_PATH, "utf-8"))
      if (typeof cfg.durationSeconds === "number" && cfg.durationSeconds > 0) return cfg.durationSeconds
    }
  } catch {}
  return 5
}

let state: BurstState = defaultState()

function persist(s: BurstState) {
  try { writeFileSync(STATE_PATH, JSON.stringify(s)) } catch {}
}

function load(): BurstState {
  try {
    if (existsSync(STATE_PATH)) return JSON.parse(readFileSync(STATE_PATH, "utf-8"))
  } catch {}
  return defaultState()
}

function playAudio() {
  if (!existsSync(AUDIO)) return
  Bun.spawn(["timeout", String(readDuration()), "paplay", AUDIO], { stderr: "ignore", stdout: "ignore" })
}

function onFileChange(filename: string) {
  const parts = filename.split("/")
  if (parts.some(p => SKIP_DIRS.has(p))) return
  const next = checkBurst(state, filename)
  if (next.alertCount > state.alertCount) playAudio()
  state = next
  persist(state)
}

function startWatcher() {
  state = load()
  try {
    const w = watch(ROOT, { recursive: true })
    w.on("change", (_event, filename) => {
      if (filename && typeof filename === "string") onFileChange(filename)
    })
  } catch {
    for (const dir of [".opencode", "objects", "src", "stud"]) {
      const full = join(ROOT, dir)
      if (!existsSync(full)) continue
      try {
        const w = watch(full, { recursive: true })
        w.on("change", (_event, filename) => {
          if (filename && typeof filename === "string") onFileChange(join(dir, filename))
        })
      } catch {}
    }
  }
}

const server = new McpServer({ name: "burst-alert", version: "1.0.0" })

server.tool(
  "burst_alert_status",
  "Show burst alert status — alert count, cooldown, recent events",
  {},
  async () => {
    const now = Date.now()
    const cooldown = Math.max(0, COOLDOWN_MS - (now - state.lastAlertTime))
    const cutoff = now - SLIDING_WINDOW_MS
    const recent = state.fileEvents.filter(e => e.time >= cutoff)
    const unique = new Set(recent.map(e => e.file))
    return {
      content: [{
        type: "text" as const,
        text: [
          `Alerts fired: ${state.alertCount}`,
          `Recent unique files: ${unique.size}`,
          `Cooldown: ${cooldown > 0 ? `${cooldown}ms` : "ready"}`,
          `Audio: ${existsSync(AUDIO) ? AUDIO : "NOT FOUND"}`,
          `Duration: ${readDuration()}s`,
          `Threshold: ${BURST_THRESHOLD} files in ${SLIDING_WINDOW_MS}ms`,
        ].join("\n"),
      }],
    }
  },
)

server.tool(
  "burst_alert_test",
  "Play the alert audio immediately (configurable duration)",
  {},
  async () => {
    if (!existsSync(AUDIO)) {
      return { content: [{ type: "text" as const, text: "Audio file not found" }] }
    }
    const sec = readDuration()
    Bun.spawn(["timeout", String(sec), "paplay", AUDIO], { stderr: "ignore", stdout: "ignore" })
    return { content: [{ type: "text" as const, text: `Audio playback triggered (${sec}s)` }] }
  },
)

server.tool(
  "burst_alert_reset",
  "Reset burst state — clear event log and alert count",
  {},
  async () => {
    state = defaultState()
    persist(state)
    return { content: [{ type: "text" as const, text: "State reset" }] }
  },
)

startWatcher()

async function main() {
  const transport = new StdioServerTransport()
  await server.connect(transport)
}

main()
