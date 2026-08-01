// @toolclass RECG
// exports: default
// purity: io
// depends-on: paths, parse, fs, path
import { tool } from "@opencode-ai/plugin"
import { readdirSync, existsSync, lstatSync, readlinkSync, realpathSync, rmSync, symlinkSync } from "fs"
import { join, relative, dirname } from "path"
import { PATLIB_ROOT, SEPARATOR } from "../_lib/paths"
import { pluralize } from "../_lib/parse"

const ROOT_NM = join(PATLIB_ROOT, ".opencode", "node_modules")
const EXPECTED_PACKAGES = ["@opencode-ai/plugin", "js-yaml"]
const MAX_SCAN_DEPTH = 6
const SKIP_DIRS = new Set([".git", ".backups", "_backups", "backups", "node_modules"])

function findNodeModulesDirs(root: string): string[] {
  const results: string[] = []
  function walk(dir: string, depth: number) {
    if (depth > MAX_SCAN_DEPTH) return
    try {
      const entries = readdirSync(dir)
      if (entries.includes("node_modules")) {
        const nmPath = join(dir, "node_modules")
        const s = lstatSync(nmPath)
        if (s.isDirectory() || s.isSymbolicLink()) results.push(nmPath)
      }
      for (const entry of entries) {
        if (SKIP_DIRS.has(entry)) continue
        const fullPath = join(dir, entry)
        if (lstatSync(fullPath).isDirectory()) walk(fullPath, depth + 1)
      }
    } catch { /* skip */ }
  }
  walk(root, 0)
  return results
}

function computeTarget(nmPath: string): string {
  const parent = dirname(nmPath)
  const depth = relative(PATLIB_ROOT, parent).split("/").length
  const ups = Array(depth).fill("..").join("/")
  return `${ups}/.opencode/node_modules`
}

export default tool({
  description: "Verify all .opencode/node_modules symlinks resolve to root canonical store",
  args: {
    repair: tool.schema.boolean().optional().default(false).describe("Fix broken symlinks automatically"),
  },
  async execute(args: { repair?: boolean }) {
    if (!existsSync(ROOT_NM)) {
      return `FATAL: Root node_modules not found at ${ROOT_NM}`
    }

    const rootTarget = realpathSync(ROOT_NM)
    const allNM = findNodeModulesDirs(PATLIB_ROOT)
    const lines: string[] = []

    lines.push(`Shared Dependency Plane Verification`)
    lines.push(`Root: ${PATLIB_ROOT}`)
    lines.push(`Canonical: ${ROOT_NM}`)
    lines.push(`Projects scanned: ${allNM.length}`)

    if (args.repair) lines.push(`Mode: repair`)
    lines.push("")

    if (args.repair) {
      let repaired = 0
      for (const nmPath of allNM) {
        const rel = relative(PATLIB_ROOT, nmPath)
        if (rel === ".opencode/node_modules") continue

        let needsRepair = false
        try {
          const s = lstatSync(nmPath)
          if (!s.isSymbolicLink()) needsRepair = true
          else if (realpathSync(nmPath) !== rootTarget) needsRepair = true
        } catch { needsRepair = true }

        if (needsRepair) {
          const target = computeTarget(nmPath)
          rmSync(nmPath, { recursive: true, force: true })
          symlinkSync(target, nmPath)
          lines.push(`REPAIRED  ${rel} → ${target}`)
          repaired++
        }
      }

      if (repaired === 0) {
        lines.push(`No repairs needed — all symlinks correct.`)
      } else {
        lines.push(`${pluralize(repaired, "symlink")} repaired.`)
      }
      lines.push("")
      lines.push(SEPARATOR)
      lines.push("")
    }

    let pass = 0
    let fail = 0

    for (const nmPath of allNM) {
      const rel = relative(PATLIB_ROOT, nmPath)
      const isRoot = rel === ".opencode/node_modules"
      const s = lstatSync(nmPath)

      if (isRoot) {
        if (s.isSymbolicLink()) {
          lines.push(`FAIL  ${rel}`)
          lines.push(`      Root node_modules is a symlink; expected real directory`)
          lines.push(`      target: ${readlinkSync(nmPath)}`)
          fail++
        } else {
          lines.push(`PASS  ${rel}`)
          lines.push(`      Real directory (not symlink)`)
          for (const pkg of EXPECTED_PACKAGES) {
            lines.push(`      Package ${pkg}: ${existsSync(join(nmPath, pkg)) ? "ok" : "MISSING"}`)
          }
          pass++
        }
      } else if (!s.isSymbolicLink()) {
        lines.push(`FAIL  ${rel}`)
        lines.push(`      Real directory; expected symlink to ${relative(PATLIB_ROOT, ROOT_NM)}`)
        lines.push(`      suggested: ${computeTarget(nmPath)}`)
        fail++
      } else {
        const linkText = readlinkSync(nmPath)
        let resolved: string
        try {
          resolved = realpathSync(nmPath)
        } catch {
          lines.push(`FAIL  ${rel}`)
          lines.push(`      Broken symlink: ${linkText}`)
          lines.push(`      suggested: ${computeTarget(nmPath)}`)
          fail++
          continue
        }
        if (resolved === rootTarget) {
          lines.push(`PASS  ${rel}`)
          lines.push(`      symlink → ${linkText}`)
          pass++
        } else {
          lines.push(`FAIL  ${rel}`)
          lines.push(`      symlink → ${linkText}`)
          lines.push(`      resolves → ${resolved}`)
          lines.push(`      expected → ${rootTarget}`)
          lines.push(`      suggested: ${computeTarget(nmPath)}`)
          fail++
        }
      }
      lines.push("")
    }

    lines.push(SEPARATOR)
    lines.push(`Total: ${allNM.length} | PASS: ${pass} | FAIL: ${fail}`)

    return lines.join("\n")
  },
})
