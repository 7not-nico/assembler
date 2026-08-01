#!/usr/bin/env bun
// @toolclass SGNL
// Compose multiple snippets into a single audio file (concatenation).
// Each snippet already has 50ms fades and normalized loudness.
// Output uses crossfade between clips for seamless transitions.

import { existsSync, mkdirSync } from "fs"
import { join } from "path"
import { OPENCODE_DIR } from "../lib/paths"
import { findWav } from "../lib/find-wav"
import { initDB } from "../lib/db"

function usage() {
  console.error("usage: compose-voices [options] <snippet-id> <snippet-id> ...")
  console.error()
  console.error("  -o, --output <file>  Output WAV path (default: ./composed.wav)")
  console.error("      --play           Play after composing")
  console.error("  -l, --list           List all snippet IDs")
  console.error()
  console.error("examples:")
  console.error("  compose-voices watters-what-the-heck-quote watters-oopsie-daisy")
  console.error("  compose-voices --play cox-remain-total-disaster cox-brexit-sexier-word")
  process.exit(1)
}

function main() {
  const args = process.argv.slice(2)
  if (args.length === 0) usage()

  let outputPath = join(process.cwd(), "composed.wav")
  let doPlay = false
  const ids: string[] = []

  for (let i = 0; i < args.length; i++) {
    if ((args[i] === "-o" || args[i] === "--output") && i + 1 < args.length) {
      outputPath = join(process.cwd(), args[++i])
    } else if (args[i] === "--play") {
      doPlay = true
    } else if (args[i] === "-l" || args[i] === "--list") {
      const db = initDB()
      const rows = db.query("SELECT id, subject, duration_sec FROM snippets ORDER BY subject, id").all() as any[]
      console.log(`\n${rows.length} snippets in DB:\n`)
      let last = ""
      for (const r of rows) {
        const subj = r.subject ?? "?"
        if (subj !== last) { console.log(`\n[${subj}]`); last = subj }
        console.log(`  ${r.id}  ${r.duration_sec ?? "?"}s`)
      }
      console.log()
      db.close()
      return
    } else if (args[i] === "--help" || args[i] === "-h") {
      usage()
    } else {
      ids.push(args[i])
    }
  }

  if (ids.length === 0) {
    console.error("no snippet IDs provided")
    usage()
  }

  const wavs: string[] = []
  for (const id of ids) {
    const wav = findWav(id)
    if (!wav) {
      console.error(`not found: ${id}.wav`)
      process.exit(1)
    }
    wavs.push(wav)
  }

  if (wavs.length === 1) {
    Bun.spawnSync(["cp", wavs[0], outputPath])
  } else {
    const soxArgs = ["sox"]
    for (const w of wavs) soxArgs.push(w)
    soxArgs.push(outputPath)
    soxArgs.push("--combine", "concatenate")
    soxArgs.push("--guard")
    const proc = Bun.spawnSync(soxArgs)
    if (proc.exitCode !== 0) {
      console.error("sox error:", proc.stderr.toString())
      process.exit(1)
    }
  }

  const dur = wavs.length
  console.error(`composed: ${wavs.length} snippets → ${outputPath}`)

  if (doPlay) {
    Bun.spawnSync(["sox", outputPath, "-d"], { stdio: ["inherit", "inherit", "inherit"] })
  }
}

main()
