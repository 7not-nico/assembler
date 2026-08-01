// exports: findSubprojects, readCompartmentYaml, readAgentsMd
// purity: io
// depends-on: fs, path, yaml (via bun)

import { readFileSync, existsSync, readdirSync, statSync } from "fs"
import { join } from "path"

export interface SubprojectInfo {
  path: string
  name: string
}

export function findSubprojects(rootPath: string): SubprojectInfo[] {
  const results: SubprojectInfo[] = []
  const seen = new Set<string>()

  function scan(dir: string) {
    if (!existsSync(dir)) return
    const entries = readdirSync(dir)
    for (const entry of entries) {
      const fullPath = join(dir, entry)
      if (!statSync(fullPath).isDirectory()) continue
      const agentsPath = join(fullPath, "AGENTS.md")
      if (existsSync(agentsPath)) {
        if (!seen.has(fullPath)) {
          seen.add(fullPath)
          results.push({ path: fullPath, name: entry })
        }
      }
    }
  }

  scan(rootPath)

  const subdirs = ["one-timers", "study-sessions", "code-dives", "common"]
  for (const sub of subdirs) {
    scan(join(rootPath, sub))
  }

  return results.sort((a, b) => a.name.localeCompare(b.name))
}

export function readCompartmentYaml(projectPath: string): string | null {
  const yamlPath = join(projectPath, ".opencode", "compartment.yaml")
  if (!existsSync(yamlPath)) return null
  return readFileSync(yamlPath, "utf-8")
}

export function readAgentsMd(projectPath: string): string | null {
  const agentsPath = join(projectPath, "AGENTS.md")
  if (!existsSync(agentsPath)) return null
  return readFileSync(agentsPath, "utf-8")
}
