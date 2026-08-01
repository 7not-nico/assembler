#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify precedes targets exist and don't cycle

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"
require_relative "_rb/patlib"

ALL_IDS = {}
EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    ALL_IDS[base] = type
  end
end

violations = []
EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)
    next unless meta

    precedes = meta[:precedes]
    next if precedes.nil? || (precedes.respond_to?(:empty?) && precedes.empty?)

    ids = precedes.is_a?(Array) ? precedes.map(&:to_s) : [precedes.to_s]
    ids.each do |pid|
      unless ALL_IDS.key?(pid)
        violations << [base, type, pid, "precedes target not found"]
      end
    end
  end
end

cycles = []
seen = Set.new
ALL_IDS.each_key do |start_id|
  next if seen.include?(start_id)
  visited = []
  current = start_id
  loop do
    break unless current
    break unless ALL_IDS.key?(current)
    if visited.include?(current)
      idx = visited.index(current)
      cycle = visited[idx..] + [current]
      cycles << cycle.join(" → ")
      break
    end
    seen.add(current)
    visited << current
    path = Dir[EntityGlob.call(ALL_IDS[current])].find { |p| File.basename(p, ".md") == current }
    break unless path
    meta = ParseMetadata.call(File.read(path))
    break unless meta
    pids = meta[:precedes]
    break if pids.nil? || (pids.respond_to?(:empty?) && pids.empty?)
    current = pids.is_a?(Array) ? pids.first.to_s : pids.to_s
  end
end

if violations.empty? && cycles.empty?
  puts "ok — #{ALL_IDS.size} entities, all precedes targets valid, 0 cycles"
else
  unless violations.empty?
    puts "precedes target violations (#{violations.size}):"
    puts Table.call(violations, %w[ID Type Target Problem])
    puts
  end
  unless cycles.empty?
    puts "precedes cycles (#{cycles.size}):"
    cycles.each { |c| puts "  #{c}" }
  end
end
