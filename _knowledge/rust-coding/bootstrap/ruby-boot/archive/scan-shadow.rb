# frozen_string_literal: true
# check shadowing using .anchor + =anchor
# ruby 3.4: it block param, endless methods

root = File.expand_path('../..', __dir__)

KWS = %w[if unless while until for each map select reject inject reduce
         puts print require include load raise fail throw catch new].freeze

def scanner(lines, label)
  funcs = {}
  calls = {}
  vars  = {}
  issues = []

  lines.each_with_index { |line, idx|
    raw = line.gsub(/#.*$/, '')
    next if raw.strip.empty?
    lineno = idx + 1

    raw.scan(/(?<![\.\w])(?<!::)([a-z_]\w*)\s*\(/) { calls[it[0]] = lineno unless KWS.include?(it[0]) }

    raw.scan(/\b([a-z_]\w*)\s*=(?!=)/) {
      prev = $~.pre_match[-4..-1].to_s.strip
      vars[it[0]] = lineno unless prev.match?(/\b(def|if|unless|while|until|for|case|class|module)\z/)
    }

    raw.scan(/\bdef\s+(?:self\.)?(\w+)/) { funcs[it[0]] = lineno }
  }

  vars.each { |vname, vline|
    issues << "#{vline}: var '#{vname}' shadows method '#{vname}' (decl #{funcs[vname]})" if funcs[vname]
    issues << "#{vline}: var '#{vname}' shadows method call '#{vname}' (call #{calls[vname]})" if calls[vname] && calls[vname] != vline
  }

  issues.sort_by { |v| v.to_i }.each { |i| puts "#{label}:#{i}" }
end

Dir.glob(File.join(root, 'script', '*.rb')).each { |path|
  scanner File.readlines(path), File.basename(path, '.rb') + '.rb'
}

Dir.glob(File.join(root, 'bootstrap', 'ruby-boot', '*.rb')).each { |path|
  scanner File.readlines(path), File.basename(path, '.rb') + '.rb (self)'
}
