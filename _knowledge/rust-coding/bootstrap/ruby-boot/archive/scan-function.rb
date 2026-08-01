# frozen_string_literal: true
# check bare function calls using () anchor type analysis
# every name( not preceded by . or :: is a bare function call
# validate: no verbs, no gerunds, no derived noun suffixes
# ruby 3.4: it block param, endless methods

root = File.expand_path('../..', __dir__)
verb_path = File.join(__dir__, '..', 'verb.txt')
VERBS = File.readlines(verb_path).map(&:strip).reject { it.empty? || it.start_with?('#') }.freeze

BUILTS = %w[
  puts print printf sprintf p pp
  require require_relative load autoload
  include extend prepend
  raise fail throw catch
  exec system spawn fork trap
  at_exit exit abort!
  lambda proc lambda? block_given?
  define_method method_defined? respond_to?
  alias_method attr_accessor attr_reader attr_writer
  private public protected module_function
  Integer Float String Array Hash
  rand srand
  loop sleep caller caller_locations
  eval class_eval module_eval instance_eval
  binding local_variables global_variables
  open close read write gets chomp chop
  to_s to_i to_f to_a to_h to_sym
  new initialize
  Array Hash String Integer Float
  true false nil
  block_given? iterator? taint untrust trust
].freeze

def check_call_line(raw, label, lineno)
  raw.scan(/(?<![\.\w])(?<!::)([a-z_]\w*)\s*\(/).filter_map {
    fn = it[0]
    next if fn.length < 2 || BUILTS.include?(fn) || fn.match?(/er$|or$/)

    violations = []
    violations << "call '#{fn}' is an imperative verb" if VERBS.include?(fn)
    if fn.match?(/ing$/) && !fn.match?(/string|thing|king|ring/)
      violations << "call '#{fn}' ends in -ing (gerund)"
    end
    if fn.match?(/tion$|sion$|ment$|ance$|ence$|ity$|ness$/)
      violations << "call '#{fn}' uses derived noun suffix"
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
      check_call_line(raw, label, idx + 1).each { puts it }
    }
  }
end

scan_scope File.join(root, 'script', '*.rb')
scan_scope File.join(root, 'bootstrap', 'ruby-boot', '*.rb'), ' (self)'
