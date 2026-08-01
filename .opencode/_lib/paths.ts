// exports: Root, Database, Store, Bin
// purity: io
// depends-on: fs, path

import { existsSync } from "fs"
import { join, dirname } from "path"

function root(marker: string): string {
  let dir = import.meta.dir
  while (dir !== '/') {
    if (existsSync(join(dir, marker))) return dir
    dir = dirname(dir)
  }
  return join(import.meta.dir, '..')
}

export const Root = root('.opencode')
export const Database = join(Root, ".opencode", "patlib.db")
export const Store = join(Root, ".opencode", "patlib-vector.db")
export const Bin = join(Root, ".opencode", "_rustlib", "target", "release", "assemble")
