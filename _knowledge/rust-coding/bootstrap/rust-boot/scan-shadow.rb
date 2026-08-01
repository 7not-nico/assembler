#!/usr/bin/env ruby
# check shadowing — Rust only
# uses .anchor + =anchor type analysis:
#   .name  → method call (exempt)
#   name = → variable assignment (tracked)
#   name(  → bare fn call (tracked)
#   fn name → fn declaration (tracked)

root = File.dirname(__dir__)

def scan(lines, name)
  funcs = {}
  calls = {}
  vars  = {}

  lines.each_with_index do |line, idx|
    lineno = idx + 1
    raw = line.dup
    raw = raw.gsub(%r{//.*$}, '')
    next if raw.strip.empty? || raw.strip.start_with?('#!', '#[')

    # skip trait impl blocks
    in_trait = raw.match?(/\bimpl\s+\w+\s+for\s+\w+/)
    next if in_trait || raw.strip == '}'

    # .name( — method call, exempt
    raw.scan(/(?<=\.)([a-z_]\w*)\s*\(/) do end

    # name = — variable assignment (let, let mut, reassign)
    raw.scan(/\b([a-z_]\w*)\s*=(?!=)/) do |match|
      vname = match[0]
      prev = $`[-4..-1].to_s.strip
      next if prev.match?(/\b(fn|struct|enum|mod|type|if|while|for|match)\z/)
      vars[vname] = lineno unless vname.empty?
    end

    # name( — bare fn call
    raw.scan(/(?<![\.\w])(?<!::)([a-z_]\w*)\s*\(/) do |match|
      fn = match[0]
      kws = %w[if for while match return assert unreachable panic println eprint dbg vec Box Rc Arc Some None Ok Err]
      next if kws.include?(fn)
      calls[fn] = lineno unless fn.empty?
    end

    # fn name — fn declaration
    raw.scan(/\bfn\s+(\w+)/) do |match|
      fn = match[0]
      next if fn == 'main'
      funcs[fn] = lineno unless fn.empty?
    end
  end

  # check
  vars.each do |vname, vline|
    if funcs[vname]
      puts "#{name}:#{vline} — var '#{vname}' shadows fn '#{vname}' (decl #{funcs[vname]})"
    end
    if calls[vname]
      next if calls[vname] == vline
      puts "#{name}:#{vline} — var '#{vname}' shadows fn call '#{vname}' (call #{calls[vname]})"
    end
  end
end

Dir.glob(File.join(root, 'fixtures', '*.rs')).each do |path|
  name = File.basename(path, '.rs')
  scan(File.readlines(path), name)
end