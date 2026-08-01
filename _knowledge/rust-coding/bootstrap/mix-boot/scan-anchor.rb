# frozen_string_literal: true
# anchor type analysis — line by line scan
# ruby 3.4: it block param, endless methods
# usage: ruby scan-anchor.rb [filepath]

root = File.expand_path('../..', __dir__)
verb_path = File.join(__dir__, '..', 'verb.txt')
VERBS = File.readlines(verb_path).map(&:strip).reject { it.empty? || it.start_with?('#') }.freeze

KWS = %w[if unless while until for each map select reject inject reduce
         puts print require include load raise fail throw catch new
         BEGIN END alias and begin break case class def defined? do
         else elsif end ensure false for if in module
         next nil not or redo rescue retry return self
         super then true undef unless until when while yield].freeze

def anchor_eq(raw) = raw.scan(/\b([a-z_]\w*)\s*=(?!=)/).filter_map {
  next if it[0] == '_'
  prev = $~.pre_match[-4..-1].to_s.strip
  next if prev.match?(/\b(def|if|unless|while|until|for|case|class|module)\z/)
  right = $~.post_match.to_s.split(',').first.to_s.strip.split('#').first.to_s.strip
  tagged = VERBS.include?(it[0]) ? " VERB" : ""
  "  = '#{it[0]}' <- #{right[0..40]} #{tagged}"
}

def anchor_call(raw) = raw.scan(/(?<![\.\w])(?<!::)([a-z_]\w*(?:[?!])?)\s*\(/).filter_map {
  next if it[0].length < 2 || KWS.include?(it[0])
  right = $~.post_match.to_s.split(')').first.to_s.strip
  tagged = VERBS.include?(it[0]) ? " VERB" : ""
  "  () '#{it[0]}' -> (#{right[0..40]})#{tagged}"
}

def anchor_dot(raw) = raw.scan(/(?<=\.)([a-z_]\w*(?:[?!])?)\s*\(/).map {
  right = $~.post_match.to_s.split(')').first.to_s.strip
  "  . '#{it[0]}' -> (#{right[0..40]})"
}

def anchor_mod(raw) = raw.scan(/(?<=::)([A-Z]\w*)\s*\(/).map {
  right = $~.post_match.to_s.split(')').first.to_s.strip
  "  :: '#{it[0]}' -> (#{right[0..40]})"
}

def anchor_pipe(raw) = raw.gsub(%r{/[^/]*/}, '').scan(/\|(\w+)\|/).map {
  tagged = VERBS.include?(it[0]) ? " VERB" : ""
  "  | '#{it[0]}'#{tagged}"
}

def anchor_discard(raw)
  m = raw.match(/\b_\s*=(?!=)/)
  return [] unless m
  right = m.post_match.to_s.split(',').first.to_s.strip.split('#').first.to_s.strip
  ["  _ <- #{right[0..40]}"]
end

def scan_line(line) = anchor_eq(line) + anchor_call(line) + anchor_dot(line) + anchor_mod(line) + anchor_discard(line) + anchor_pipe(line)

targets = ARGV[0] ? [ARGV[0]] : Dir.glob(File.join(root, 'script', '*.rb')) + Dir.glob(File.join(root, 'bootstrap', 'mix-boot', '*.rb'))

targets.each do |path|
  label = File.basename(path) + (ARGV[0] ? ' (arg)' : '')
  File.readlines(path).each_with_index { |line, idx|
    next if line.strip.empty? || line.strip.start_with?('#')
    lineno = idx + 1
    tags = scan_line(line)
    puts "#{label}:#{lineno}: #{line.chomp}"
    tags.each { puts it }
  }
end