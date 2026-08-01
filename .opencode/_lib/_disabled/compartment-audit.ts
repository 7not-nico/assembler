// exports: parseCompartmentYaml, auditCompartment, auditCompartmentText
// purity: pure
// depends-on: none

export interface CompartmentDeclaration {
  membraneType: string
  processFamily: string
  governance: string
  channels?: { target: string; protocol: string }[]
}

export interface Violation {
  field: string
  message: string
}

export interface AuditResult {
  name: string
  path: string
  present: boolean
  violations: Violation[]
}

const VALID_MEMBRANE_TYPES = ["autonomous", "shared-substrate", "infrastructure"]

export function parseCompartmentYaml(text: string): CompartmentDeclaration | null {
  const lines = text.split("\n")
  const decl: Record<string, string> = {}
  const channels: { target: string; protocol: string }[] = []
  let inChannels = false

  for (const raw of lines) {
    const line = raw.trim()
    if (line === "" || line.startsWith("#")) continue

    if (line === "cross-compartment-channels:" || line.startsWith("cross-compartment-channels:")) {
      inChannels = true
      continue
    }

    if (inChannels) {
      const chMatch = line.match(/^\s*-\s+target:\s*(.+)/)
      if (chMatch) {
        channels.push({ target: chMatch[1].trim(), protocol: "" })
        continue
      }
      const prMatch = line.match(/^\s+protocol:\s*(.+)/)
      if (prMatch && channels.length > 0) {
        channels[channels.length - 1].protocol = prMatch[1].trim()
        continue
      }
      if (line.startsWith("- ") || line.match(/^\w/)) {
        inChannels = false
      } else {
        continue
      }
    }

    const kv = line.match(/^(\w[\w-]*):\s+(.+)/)
    if (kv) {
      decl[kv[1].trim()] = kv[2].trim()
    }
  }

  const membraneType = decl["membrane-type"] || ""
  const processFamily = decl["process-family"] || ""
  const governance = decl["governance"] || ""

  if (!membraneType && !processFamily && !governance && channels.length === 0) return null

  return { membraneType, processFamily, governance, channels }
}

export function auditDeclaration(decl: CompartmentDeclaration): Violation[] {
  const violations: Violation[] = []

  if (!decl.membraneType) {
    violations.push({ field: "membrane-type", message: "Missing required field" })
  } else if (!VALID_MEMBRANE_TYPES.includes(decl.membraneType)) {
    violations.push({ field: "membrane-type", message: `Invalid value "${decl.membraneType}". Valid: ${VALID_MEMBRANE_TYPES.join(", ")}` })
  }

  if (!decl.processFamily) {
    violations.push({ field: "process-family", message: "Missing required field" })
  }

  if (!decl.governance) {
    violations.push({ field: "governance", message: "Missing required field" })
  }

  if (decl.channels && decl.channels.length > 1) {
    violations.push({ field: "cross-compartment-channels", message: `Channel count ${decl.channels.length} exceeds maximum 1 per direction` })
  }

  return violations
}

export function auditCompartmentText(text: string): Violation[] {
  const decl = parseCompartmentYaml(text)
  if (!decl) return [{ field: "(root)", message: "No compartment declaration found" }]
  return auditDeclaration(decl)
}
