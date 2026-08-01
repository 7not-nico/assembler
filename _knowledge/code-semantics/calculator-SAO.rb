# Calculator — subject → action → object, categorically
#
#   In the category of Float:
#     subject  : initial object (the accumulator)
#     action   : morphism Float × Float → Float
#     object   : parameter that partially applies the morphism
#
#   Composition chain:
#     subject ──action₁(object₁)──→ subject₁ ──action₂(object₂)──→ result
#
# Usage:
#   ruby calculator-SAO.rb "2 + 3"
#   ruby calculator-SAO.rb "2 + 3 * 4"
#   ruby calculator-SAO.rb (interactive REPL)

OPS = {
  "+" => ->(x, y) { x + y },
  "-" => ->(x, y) { x - y },
  "*" => ->(x, y) { x * y },
  "/" => ->(x, y) { x / y },
  "**" => ->(x, y) { x**y }
}.freeze

NUM  = /\d+(?:\.\d+)?/
ACT  = /\*\*|[+\-*\/]/
SKIP = /\s+/

SCAN = Regexp.new("(#{NUM})|(#{ACT})|(#{SKIP})")


def scan(str)
  tokens = []
  str.scan(SCAN) { |n, a, _| tokens << [:NUM, n.to_f] if n; tokens << [:ACT, a] if a }
  tokens
end


def evaluate(expr)
  toks = scan(expr)
  raise "empty expression" if toks.empty?

  subject = toks[0]
  raise "expected number" unless subject[0] == :NUM
  subject = subject[1]

  objects = toks.select { |t| t[0] == :NUM }.map { |t| t[1] }
  arrows  = toks.select { |t| t[0] == :ACT }.map { |t| t[1] }

  raise "mismatched morphisms" unless objects.length == arrows.length + 1

  arrows.each_with_index.reduce(subject) do |subj, (arrow, i)|
    obj = objects[i + 1]
    fn = OPS[arrow] or raise "unbound morphism: #{arrow}"
    raise ZeroDivisionError if arrow == "/" && obj == 0.0
    fn.call(subj, obj).to_f
  end
end


def strip_zero(val)
  val.to_s.sub(/\.0$/, "")
end


def repl
  puts "  SAO calculator — subject → action → object"
  puts "  morphisms: +  -  *  /  **"

  loop do
    print "  > "
    line = $stdin.gets or break
    line = line.strip
    next if line.empty?
    break if %w[exit quit q].include?(line)

    puts "  = #{strip_zero(evaluate(line))}" rescue puts "  ✗ #{$!.message}"
  end
end


if __FILE__ == $PROGRAM_NAME
  ARGV.empty? ? repl : (puts strip_zero(evaluate(ARGV.join(" "))))
end
