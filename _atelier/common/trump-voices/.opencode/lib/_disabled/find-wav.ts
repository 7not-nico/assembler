// exports: findWav, SEARCH_DIRS
// purity: PURE
// depends-on: fs, path, ./paths

import { existsSync, readdirSync } from "fs"
import { join } from "path"
import { PROJECT_DIR } from "./paths"

const SEARCH_DIRS = ["objects-revised", "objects-crude"]

export function findWav(id: string): string | null {
  for (const dir of SEARCH_DIRS) {
    const base = join(PROJECT_DIR, dir)
    if (!existsSync(base)) continue
    const videos = readdirSync(base).filter(d =>
      existsSync(join(base, d)) && !d.startsWith(".")
    ).sort()
    for (const video of videos) {
      const wav = join(base, video, `${id}.wav`)
      if (existsSync(wav)) return wav
    }
  }
  return null
}
