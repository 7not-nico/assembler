#!/usr/bin/env ruby
# ring: 1 (LOCAL-READ) — verify reference entries are valid {title, url} hashes

require_relative "_rb/loader"
require_relative "_rb/paths"
require_relative "_rb/frontmatter"
require_relative "_rb/report"

violations = []

EntityTypes.each do |type|
  Dir[EntityGlob.call(type)].each do |path|
    base = File.basename(path, ".md")
    text = File.read(path)
    meta = ParseMetadata.call(text)
    next unless meta

    refs = meta[:reference]
    next if refs.nil? || (refs.respond_to?(:empty?) && refs.empty?)

    unless refs.is_a?(Array)
      violations << [base, type, "reference", "must be YAML array"]
      next
    end

    refs.each_with_index do |ref, i|
      unless ref.is_a?(Hash)
        violations << [base, type, "reference[#{i}]", "entry not a hash: #{ref.inspect}"]
        next
      end

      title = ref[:title] || ref["title"]
      url = ref[:url] || ref["url"]

      if title.nil? || title.to_s.strip.empty?
        violations << [base, type, "reference[#{i}]", "missing title"]
      end

      if url.nil? || url.to_s.strip.empty?
        violations << [base, type, "reference[#{i}]", "missing url"]
      elsif !url.to_s.match?(/\Ahttps?:\/\//)
        violations << [base, type, "reference[#{i}]", "url not HTTP(S): #{url}"]
      end
    end
  end
end

if violations.empty?
  puts "ok — #{EntityTypes.size} entity types, all references valid"
else
  puts "reference violations (#{violations.size}):"
  puts Table.call(violations, %w[ID Type Field Problem])
end
