#!/usr/bin/env ruby
# ring: 0 (PURE) — runs r* scripts in parallel per MAX.STALL.ENGINE
# depends-on: _rb/bench

require_relative "_rb/bench"

ROOT = __dir__
EXCLUDE = %w[r1-run-parallel.rb]

SCRIPTS = Dir.glob(File.join(ROOT, "r*.rb")).map { |p| File.basename(p) }
  .reject { |s| EXCLUDE.include?(s) }
  .sort

BATCH = (ENV["BATCH"] || 4).to_i

total_start = Time.now
results = []

SCRIPTS.each_slice(BATCH) do |batch|
  pids = {}
  batch.each do |script|
    pid = Process.fork do
      Dir.chdir(ROOT)
      $stdout.reopen(File::NULL)
      exec("ruby", script)
    end
    pids[pid] = script
  end

  while pids.any?
    pid = Process.wait(-1)
    script = pids.delete(pid)
    results << [script, $?.exitstatus]
  end
end

total_elapsed = Time.now - total_start

puts "=" * 50
puts "Parallel run (#{SCRIPTS.size} scripts, batch=#{BATCH})"
puts "Total: #{FormatDuration.call(total_elapsed)}"
puts "-" * 50
failed = results.select { |_, s| s != 0 }
if failed.any?
  puts "Failed (#{failed.size}):"
  failed.each { |s, c| puts "  #{s}: exit #{c}" }
  exit 1
else
  puts "All #{results.size} passed"
end
