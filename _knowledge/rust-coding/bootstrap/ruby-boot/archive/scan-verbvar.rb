# frozen_string_literal: true
# check variable names using = anchor type analysis
# every name on LHS of = is a variable assignment
# validate: no verbs, no gerunds, no derived noun suffixes
# ruby 3.4: it block param, endless methods

root = File.expand_path('../..', __dir__)
verb_path = File.join(__dir__, '..', 'verb.txt')
VERBS = File.readlines(verb_path).map(&:strip).reject { it.empty? || it.start_with?('#') }.freeze

def check_var_line(raw, label, lineno)
  raw.scan(/\b([a-z_]\w*)\s*=(?!=)/).filter_map {
    var = it[0]
    next if var.length < 2
    prev = $~.pre_match[-4..-1].to_s.strip
    next if prev.match?(/\b(def|if|unless|while|until|for|case|class|module)\z/)

    violations = []
    violations << "var '#{var}' is an imperative verb" if VERBS.include?(var)
    if var.match?(/ing$/) && !var.match?(/string|thing|king|ring/)
      violations << "var '#{var}' ends in -ing (gerund)"
    end
    if var.match?(/tion$|sion$|ment$|ance$|ence$|ity$|ness$/)
      violations << "var '#{var}' uses derived noun suffix"
    end
    violations.map { "#{label}:#{lineno}: #{it}" }
  }.flatten
end

def scan_scope(glob, suffix = '')
  Dir.glob(glob).each { |path|
    label = File.basename(path, '.rb') + '.rb' + suffix
    File.readlines(path).each_with_index { |line, idx|
      raw = line.gsub(/#.*$/, '')
      next if raw.strip.empty?
      check_var_line(raw, label, idx + 1).each { puts it }
    }
  }
end

scan_scope File.join(root, 'script', '*.rb')
scan_scope File.join(root, 'bootstrap', 'ruby-boot', '*.rb'), ' (self)'
