#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — encyclopedic source vectors must point inward per MAX.KNOWLEDGE.CLASSIFICATION

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/patlib"
require_relative "_rb/rings"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

ENCYCLOPEDIC = EncyclopedicTypes

vs = []
EntityTypes.each do |type|
  ring_info = TypeToRing.call(type)
  next unless ring_info
  entity_ring = ring_info[:ring]

  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)
    next unless meta

    src = meta[:source]
    if src && !src.to_s.strip.empty?
      src_s = src.to_s.strip
      src_ring_info = SourceToRing.call(src_s)
      if src_ring_info
        src_ring = src_ring_info[:ring]
        src_group = src_ring_info[:group]
        if ENCYCLOPEDIC.include?(type)
          if src_group != :encyclopedic || src_ring > entity_ring
            vs << [base, type, src_s, "encyclopedic source must point inward (R#{entity_ring}←R#{src_ring})"]
          end
        end
      end
    end

    precedes = meta[:precedes]
    next if precedes.nil? || (precedes.respond_to?(:empty?) && precedes.empty?)
    pids = precedes.is_a?(Array) ? precedes.map(&:to_s) : [precedes.to_s]
    pids.each do |pid|
      pid_ring_info = IdToRing.call(pid)
      next unless pid_ring_info
      pid_ring = pid_ring_info[:ring]
      pid_group = pid_ring_info[:group]
      if ENCYCLOPEDIC.include?(type)
        if pid_group != :encyclopedic || pid_ring > entity_ring
          vs << [base, type, "precedes:#{pid}", "encyclopedic precedes must point inward (R#{entity_ring}←R#{pid_ring})"]
        end
      end
    end
  end
end

if vs.empty?
  puts "ok — encyclopedic source vectors all point inward"
else
  puts "source vector violations (#{vs.size}):"
  puts Table.call(vs, %w[ID Type Target Problem])
end
