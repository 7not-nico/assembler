#!/usr/bin/env ruby
# frozen_string_literal: true

# fixture-ruby-test.rb — functional Ruby fixture testing the _scripts toolchain
# Style: stdlib-only, pure functions, atomic units (MAX.ATOMIC.CONCERN)
# Emits KEY=value contract lines; last line carries RESULT=pass|fail:count

require "open3"
require "json"

ROOT = File.expand_path("..", __dir__)
CLI = File.join(ROOT, "_golib/bin/assembler-cli")

# --- pure functions ---

def cli_available?(cli)
  File.executable?(cli)
end

def run_cli(cli, *args)
  out, err, status = Open3.capture3(cli, *args)
  { out: out, err: err, status: status.exitstatus }
end

def count_entities(result)
  # count verb emits "Entity Type      | Count" table; sum the numeric column
  result[:out]
    .lines
    .drop(2)                      # header + separator
    .filter_map { |l| l.split("|")[1]&.strip }
    .sum { |c| c.to_i }
end

def audit_faults(result)
  # audit verb emits "faults" counts; extract final total
  m = result[:out].match(/audit ok — \d+ entities of type '\w+', (\d+) faults/)
  m ? m[1].to_i : nil
end

def summarize(run)
  { cli: run[:cli], count: run[:count], faults: run[:faults], exit: run[:exit] }.compact
end

# --- composition (side-effect boundary) ---

results = []
if cli_available?(CLI)
  count  = run_cli(CLI, "count")
  audit  = run_cli(CLI, "audit", "patterns")
  results << { cli: "count", count: count_entities(count), exit: count[:status] }
  results << { cli: "audit-patterns", faults: audit_faults(audit), exit: audit[:status] }
end

CLI_PRESENT = cli_available?(CLI)
RUNS = results

# --- report ---

puts "CLI=#{CLI}"
puts "CLI_PRESENT=#{CLI_PRESENT ? 'yes' : 'no'}"
RUNS.each { |r| puts "RUN_#{r[:cli].upcase.gsub('-', '_')}=#{r.to_json}" }

ok = CLI_PRESENT && RUNS.length == 2 && RUNS.all? { |r| r[:exit] == 0 }
puts "RESULT=#{ok ? 'pass' : 'fail'}:#{RUNS.length}"
exit(ok ? 0 : 1)
