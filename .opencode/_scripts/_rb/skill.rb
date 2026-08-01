# exports: VALID_PROFILES, NAME_PATTERN, CheckSkillFrontmatter
# ring: 0 (PURE)

VALID_PROFILES = %w[stateless stateful-reader stateful-writer stateful-auditor hybrid].freeze
NAME_PATTERN = '^[a-z]+(-[a-z]+)+$'

CheckSkillName = ->(name, dirname) {
  violations = []
  violations << "must match #{NAME_PATTERN}" unless name.match?(Regexp.new(NAME_PATTERN))
  violations << "must match directory #{dirname}" unless name == dirname
  violations
}

CheckSkillDescription = ->(desc) {
  desc.start_with?("Use this skill when") ? [] : ["must start with 'Use this skill when'"]
}

CheckSkillProfile = ->(profile) {
  return ["required field absent"] if profile.nil? || profile.strip.empty?
  VALID_PROFILES.include?(profile) ? [] : ["must be one of #{VALID_PROFILES.join('/')}"]
}

CheckSkillTrigger = ->(data) {
  return [] unless data.key?(:trigger)
  ["trigger field removed — description IS the trigger"]
}
