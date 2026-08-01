#!/usr/bin/env ruby
# ring: 1 (DB-READ) — skill structural audit per PROT.SKILL.IDENTITY

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/violation"
require_relative "_rb/bench"
require_relative "_rb/skill"

start = Time.now
violations = []

Dir[SkillGlob.call].sort.each do |path|
  dirname = File.basename(File.dirname(path))
  text = File.read(path)
  data = ParseFrontmatter.call(text)

  unless data
    violations << [dirname, "skill", "metadata", "-", "no frontmatter found"]
    next
  end

  name = (data[:name] || "").to_s
  desc = (data[:description] || "").to_s
  profile = (data[:state_profile] || data[:'state-profile'] || "").to_s

  CheckSkillName.call(name, dirname).each { |msg|
    violations << [name, "skill", "name", name.inspect, msg]
  }

  CheckSkillDescription.call(desc).each { |msg|
    violations << [name, "skill", "description", desc[0..50].inspect, msg]
  }

  CheckSkillProfile.call(profile).each { |msg|
    violations << [name, "skill", "state-profile", profile.empty? ? "missing" : profile.inspect, msg]
  }

  CheckSkillTrigger.call(data).each { |msg|
    violations << [name, "skill", "trigger", data[:trigger].inspect, msg]
  }
end

total = Dir[SkillGlob.call].size
puts ReportViolations.call(violations, "#{total} skills", "audit")
$stderr.puts "  [#{FormatDuration.call(Time.now - start)}] skill audit"
exit violations.empty? ? 0 : 1
