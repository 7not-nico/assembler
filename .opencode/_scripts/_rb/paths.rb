# exports: ROOT, ENTITIES, RULES, COMMANDS, SKILLS, EntityGlob, EntityTypes, ExternalTypes
# ring: 0 (PURE)
# depends-on: ./loader

# Walk upward from this file until an ancestor contains .opencode/entities.
# Handles both layouts: assembler/_scripts/_rb and assembler/.opencode/_scripts/_rb.
ROOT = begin
  dir = Pathname.new(__dir__)
  found = nil
  loop do
    if dir.join(".opencode", "entities").directory?
      found = dir
      break
    end
    if dir.root?
      break
    end
    dir = dir.parent
  end
  raise "assembler root not found — no .opencode/entities ancestor of #{__dir__}" unless found
  found
end
ENTITIES = ROOT.join(".opencode", "entities")
RULES = ROOT.join(".opencode", "rules")
COMMANDS = ROOT.join(".opencode", "commands")
SKILLS = ROOT.join(".opencode", "skills")

EntityGlob = ->(type) { ENTITIES.join(type, "**", "*.md").to_s }
ExternalGlob = ->(type) {
  case type
  when "rules" then RULES.join("*.md").to_s
  when "commands" then COMMANDS.join("*.md").to_s
  else ENTITIES.join(type, "*.md").to_s
  end
}

EntityTypes = Dir.children(ENTITIES.to_s)
  .select { |d|
    p = ENTITIES.join(d).to_s
    File.directory?(p) && !Dir.glob(File.join(p, "**", "*.md")).empty?
  }
  .sort
  .map(&:to_s)

SkillGlob = -> { File.join(SKILLS.to_s, "*", "SKILL.md") }

ExternalTypes = -> {
  types = []
  types << "rules" if Dir.exist?(RULES.to_s) && !Dir.empty?(RULES.to_s)
  types << "commands" if Dir.exist?(COMMANDS.to_s) && !Dir.empty?(COMMANDS.to_s)
  types
}
