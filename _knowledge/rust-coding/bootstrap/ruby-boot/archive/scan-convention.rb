# frozen_string_literal: true
# check naming convention compliance
# gerund, derived noun, imperative verb, compound variable
# ruby 3.4: it block param, endless methods

root = File.expand_path('../..', __dir__)
verb_path = File.join(__dir__, '..', 'verb.txt')
VERBS = File.readlines(verb_path).map(&:strip).reject { it.empty? || it.start_with?('#') }.freeze

def check_method_line(raw, label, lineno)
  raw.scan(/\bdef\s+(?:self\.)?(\w+)/).filter_map {
    fn = it[0]
    violations = []
    violations << "method '#{fn}' ends in -ing (gerund)" if fn.match?(/ing$/) && !fn.match?(/string|thing|king|ring/)
    if fn.match?(/tion$|sion$|ment$|ance$|ence$|ity$|ness$/)
      violations << "method '#{fn}' uses derived noun suffix"
    end
    violations << "method '#{fn}' imperative verb (use agentive suffix)" if VERBS.include?(fn)
    violations.map { "#{label}:#{lineno}: #{it}" }
  }.flatten
end

def check_var_seg_line(raw, label, lineno)
  raw.scan(/\b([a-z_]\w*)\s*=(?!=)/).filter_map {
    var = it[0]
    next if var.length < 2
    segs = var.split('_')
    "#{label}:#{lineno}: var '#{var}' has #{segs.length} segments (max 2)" if segs.length >= 3
  }
end

def scan_scope(glob, suffix = '')
  Dir.glob(glob).each { |path|
    label = File.basename(path, '.rb') + '.rb' + suffix
    File.readlines(path).each_with_index { |line, idx|
      raw = line.gsub(/#.*$/, '')
      next if raw.strip.empty?
      lineno = idx + 1
      (check_method_line(raw, label, lineno) + check_var_seg_line(raw, label, lineno)).each { puts it }
    }
  }
end

scan_scope File.join(root, 'script', '*.rb')
scan_scope File.join(root, 'bootstrap', 'ruby-boot', '*.rb'), ' (self)'
