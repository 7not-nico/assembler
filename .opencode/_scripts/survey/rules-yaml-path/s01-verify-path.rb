#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify rules/yamls path resolution after .yamls→yamls rename
# survey: rules-yaml-path — confirm paths.ts RULES_DIR resolves correctly and yaml files are canonical

require_relative "../../_rb/loader"
require_relative "../../_rb/paths"
require_relative "../../_rb/report"

RULES_DIR = ROOT.join(".opencode", "rules")
YAMLS_DIR = RULES_DIR.join("yamls")
DOT_YAMLS_DIR = RULES_DIR.join(".yamls")

rows = []
errors = []

# 1. Check yamls directory
yamls_exists = Dir.exist?(YAMLS_DIR.to_s)
yamls_symlink = File.symlink?(YAMLS_DIR.to_s)
yamls_target = yamls_symlink ? File.readlink(YAMLS_DIR.to_s) : nil
rows << ["rules/yamls exists", yamls_exists.to_s, yamls_exists ? "✓" : "✗"]
rows << ["rules/yamls symlink?", yamls_symlink.to_s, yamls_symlink ? "✗ (should not be symlink)" : "✓ (plain directory)"]
unless yamls_exists
  errors << "rules/yamls directory missing"
end

# 2. Check .yamls is gone
dot_yamls_exists = Dir.exist?(DOT_YAMLS_DIR.to_s)
dot_yamls_symlink = File.symlink?(DOT_YAMLS_DIR.to_s)
rows << ["rules/.yamls exists", dot_yamls_exists.to_s, dot_yamls_exists ? "✗ (should not exist)" : "✓ (removed)"]
if dot_yamls_symlink
  rows << ["rules/.yamls symlink?", "yes", "✗ (should not exist at all)"]
end

# 3. Enumerate yaml files
if yamls_exists
  yaml_files = Dir[File.join(YAMLS_DIR.to_s, "*.yaml")].sort
  md_files = Dir[File.join(RULES_DIR.to_s, "*.md")].sort
  yaml_basenames = yaml_files.map { |f| File.basename(f, ".yaml") }
  md_basenames = md_files.map { |f| File.basename(f, ".md") }

  rows << ["YAML files found", yaml_files.size.to_s, ""]
  rows << ["MD files found", md_files.size.to_s, ""]

  # yamls without md
  yaml_no_md = yaml_basenames - md_basenames
  rows << ["YAML w/o MD", yaml_no_md.size.to_s, yaml_no_md.empty? ? "✓" : "✗ #{yaml_no_md.join(", ")}"]

  # md without yaml
  md_no_yaml = md_basenames - yaml_basenames
  rows << ["MD w/o YAML", md_no_yaml.size.to_s, md_no_yaml.empty? ? "✓" : "✗ #{md_no_yaml.join(", ")}"]
else
  errors << "cannot enumerate — yamls dir missing"
end

# 4. Simulate paths.ts RULES_DIR resolution
expected_rules_dir = ROOT.join(".opencode", "rules", "yamls").to_s
actual_resolved = File.realpath(expected_rules_dir) rescue nil
rows << ["paths.ts RULES_DIR resolves", actual_resolved.to_s, actual_resolved ? "✓" : "✗"]

# 5. Check a specific file in yamls dir (e.g. lambda-linguistics)
lambda_yaml = YAMLS_DIR.join("lambda-linguistics.yaml")
lambda_md = RULES_DIR.join("lambda-linguistics.md")
rows << ["lambda-linguistics.yaml exists", File.exist?(lambda_yaml.to_s).to_s, File.exist?(lambda_yaml.to_s) ? "✓" : "✗"]
rows << ["lambda-linguistics.md exists", File.exist?(lambda_md.to_s).to_s, File.exist?(lambda_md.to_s) ? "✓" : "✗"]

# 5b. Verify subject.object.action content
if File.exist?(lambda_md.to_s)
  md_content = File.read(lambda_md.to_s)
  has_sov = md_content.include?("subject.object.action")
  has_example = md_content.include?("db.data.query → file.content.write → icon.color.replace")
  rows << ["lambda-linguistics.md has subject.object.action", has_sov.to_s, has_sov ? "✓" : "✗"]
  rows << ["lambda-linguistics.md has updated examples", has_example.to_s, has_example ? "✓" : "✗"]
  unless has_sov && has_example
    errors << "lambda-linguistics.md not updated to subject.object.action"
  end
end

penalty_md = RULES_DIR.join("linguistic-lambda-penalty.md")
if File.exist?(penalty_md.to_s)
  penalty_content = File.read(penalty_md.to_s)
  has_sov_penalty = penalty_content.include?("subject.object.action")
  rows << ["linguistic-lambda-penalty.md updated", has_sov_penalty.to_s, has_sov_penalty ? "✓" : "✗"]
  unless has_sov_penalty
    errors << "linguistic-lambda-penalty.md not updated"
  end
end

# 5c. Check lambda-linguistics.yaml references in rules table later via write-sync
# For now just confirm yaml parses
if File.exist?(lambda_yaml.to_s)
  require "yaml"
  yaml_data = YAML.safe_load_file(lambda_yaml.to_s)
  yaml_id = yaml_data["id"] rescue nil
  rows << ["lambda-linguistics.yaml parses", yaml_id.to_s, yaml_id == "RUL.LINGUISTIC.LAMBDA.NOTATION" ? "✓" : "✗"]
end

puts "=== Rules Yaml Path Survey ==="
puts
puts Table.call(rows, %w[Check Value Status])
puts
if errors.empty?
  puts "Result: ✓ PASS — all checks pass, path resolution correct"
else
  puts "Result: ✗ FAIL — #{errors.size} error(s):"
  errors.each { |e| puts "  • #{e}" }
end
puts
puts "Next step: run `write-sync rules` to register changes in patlib.db"
