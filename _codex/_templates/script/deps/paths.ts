// deps/paths.ts — script dependency: resolve _templates paths
// Pure module: exports resolved paths only, no I/O, no side effects.
// All script-ring tools import these instead of recomputing ROOT/DB paths.
// Root: _templates/ — the deps module lives at script/deps/, two levels down.
import * as path from "node:path"

const DEPS_DIR = import.meta.dir

/** _templates/ root — parent of script/ */
export const ROOT = path.resolve(DEPS_DIR, "../..")

/** registry DB (moved to script/schema/) */
export const REG_PATH = path.join(ROOT, "script", "schema", "templates.db")

/** vector store DB (moved to script/schema/) */
export const DB_PATH = path.join(ROOT, "script", "schema", "templates-vector.db")

/** Rust ANN worker binary */
export const BIN = path.join(ROOT, "_rustlib", "target", "release", "tpl-ann")
