# frozen_string_literal: true
# check Ruby reserved keyword collisions
# ruby 3.4: it block param, endless methods

root = File.expand_path('../..', __dir__)
reserve = File.join(__dir__, 'reserve.txt')
KWS = File.readlines(reserve).map(&:strip).reject { it.empty? || it.start_with?('#') }.freeze

def check_var_kw_line(raw, label, lineno)
  raw.scan(/\b([a-z_]\w*)\s*=(?!=)/).filter_map {
    var = it[0]
    "#{label}:#{lineno}: var '#{var}' is a reserved keyword" if var.length >= 2 && KWS.include?(var)
  }
end

def check_method_kw_line(raw, label, lineno)
  raw.scan(/\bdef\s+(?:self\.)?(\w+)/).filter_map {
    "#{label}:#{lineno}: method '#{it[0]}' is a reserved keyword" if KWS.include?(it[0])
  }
end

def check_param_kw_line(raw, label, lineno)
  raw.gsub(%r{/[^/]*/}, '').scan(/\|(\w+)\|/).filter_map {
    "#{label}:#{lineno}: block param '#{it[0]}' is a reserved keyword" if KWS.include?(it[0])
  }
end

def scan_scope(glob, suffix = '')
  Dir.glob(glob).each { |path|
    label = File.basename(path, '.rb') + '.rb' + suffix
    File.readlines(path).each_with_index { |line, idx|
      raw = line.gsub(/#.*$/, '').gsub(%r{/[^/]*/}, '')
      next if raw.strip.empty?
      lineno = idx + 1
      (check_var_kw_line(raw, label, lineno) +
       check_method_kw_line(raw, label, lineno) +
       check_param_kw_line(raw, label, lineno)).each { puts it }
    }
  }
end

scan_scope File.join(root, 'script', '*.rb')
scan_scope File.join(root, 'bootstrap', 'ruby-boot', '*.rb'), ' (self)'
