#!/usr/bin/env ruby
# Test all Go calculator variants using random operands.
# Each positive test generates random values, computes expected in Ruby,
# feeds to Go binary, and compares output numerically.
#
# Usage: ruby script/test_calc.rb          (3 iterations per variant)
#        ITER=10 ruby script/test_calc.rb  (10 iterations)
#        VERBOSE=1 ruby script/test_calc.rb (show passes)

# ── Helpers ──────────────────────────────────────────────

def rand_op
  %w[+ - * /].sample
end

def rand_val(max = 50)
  rand(1..max)
end

def apply(op, a, b)
  case op
  when "+"  then a.to_f + b.to_f
  when "-"  then a.to_f - b.to_f
  when "*"  then a.to_f * b.to_f
  when "/"  then a.to_f / b.to_f
  when "**" then a.to_f ** b.to_f
  end
end

def strip(val)
  s = val.to_s
  s.end_with?(".0") ? s[0..-3] : s
end

def run(variant, input)
  `echo "#{input}" | go run . #{variant} 2>&1`
end

def run_cli(variant, expr)
  `go run . #{variant} '#{expr}' 2>&1`.strip
end

# Extract LAST numeric value from Go output.
def extract_value(out)
  m = out.scan(/=\s*([\d.eE+\-]+)/)
  m.empty? ? nil : m.last[0]
end

# Compare float64 values with tolerance.
def match_float(got_str, expected)
  return false unless got_str
  got = got_str.to_f
  exp = expected.to_f
  diff = (got - exp).abs
  max_val = [got.abs, exp.abs].max
  if max_val > 1
    diff / max_val < 0.01
  else
    diff < 0.5
  end
end

# ── Generators per variant ───────────────────────────────
# Positional variants prompt in statement-structure order:
#   soa: subject → object → action
#   sao: subject → action → object
#   aos: action → object → subject
#   aso: action → subject → object
#   osa: object → subject → action
#   oas: object → action → subject

def gen_soa_triple
  a = rand_val; b = rand_val(20); op = rand_op
  expected = apply(op, a, b)
  input = "#{a}\n#{b}\n#{op}\nq\n"
  [input, expected, "#{strip(a)} #{op} #{strip(b)} = #{strip(expected)}"]
end

def gen_soa_chain
  a = rand_val; b = rand_val(10); c = rand_val(5)
  op1 = rand_op; op2 = rand_op
  while op1 == "/" || op2 == "/"; op1 = rand_op; op2 = rand_op end
  mid = apply(op1, a, b)
  expected = apply(op2, mid, c)
  # chain: subject→object→action for first cycle, then again
  input = "#{a}\n#{b}\n#{op1}\n#{mid}\n#{c}\n#{op2}\nq\n"
  [input, expected, "(#{strip(a)} #{op1} #{strip(b)}) #{op2} #{strip(c)} = #{strip(expected)}"]
end

def gen_sao_expr
  a = rand_val; b = rand_val(20); op = rand_op
  expected = apply(op, a, b)
  input = "#{a}\n#{op}\n#{b}\nq\n"
  [input, expected, "#{a} #{op} #{b} = #{strip(expected)}"]
end

def gen_aos_triple
  a = rand_val; b = rand_val(20); op = rand_op
  # aos prompts: action → object → subject
  # input: op, object(a), subject(b) → result = subject op object = b op a
  expected = apply(op, b, a)
  input = "#{op}\n#{a}\n#{b}\nq\n"
  [input, expected, "#{op} #{a} #{b} = #{strip(expected)}"]
end

def gen_aso_triple
  a = rand_val; b = rand_val(20); op = rand_op
  expected = apply(op, a, b)
  input = "#{op}\n#{a}\n#{b}\nq\n"
  [input, expected, "#{op} #{a} #{b} = #{strip(expected)}"]
end

def gen_osa_triple
  a = rand_val; b = rand_val; op = rand_op
  expected = apply(op, b, a)
  input = "#{a}\n#{b}\n#{op}\nq\n"
  [input, expected, "#{a} #{b} #{op} = #{strip(expected)}"]
end

def gen_oas_triple
  a = rand_val; b = rand_val; op = rand_op
  expected = apply(op, b, a)
  input = "#{a}\n#{op}\n#{b}\nq\n"
  [input, expected, "#{a} #{op} #{b} = #{strip(expected)}"]
end

def gen_method_test
  a = rand_val; b = rand_val(20)
  verb_map = {"add" => "+", "subtract" => "-", "multiply" => "*"}
  verb = verb_map.keys.sample
  expected = apply(verb_map[verb], a, b)
  input = "#{a}\n#{verb}\n#{b}\nq\n"
  [input, expected, "#{a}.#{verb}(#{b}) = #{strip(expected)}"]
end

def gen_imperative_test
  a = rand_val; b = rand_val(20); op = rand_op
  expected = apply(op, a, b)
  input = "#{a}\n#{op}\n#{b}\nq\n"
  [input, expected, "#{a} #{op} #{b} = #{strip(expected)}"]
end

def gen_stk_test
  a = rand_val(20); b = rand_val(10); op = rand_op
  expected = apply(op, a, b)
  input = "#{a} #{b} #{op} .\nq\n"
  [input, expected, "#{a} #{b} #{op} = #{strip(expected)}"]
end

def gen_chn_test
  a = rand_val; b = rand_val(20)
  expected = a.to_f + b.to_f
  input = "+ #{a}\n+ #{b}\n=\nq\n"
  [input, expected, "#{a} + #{b} = #{strip(expected)}"]
end

def gen_ifc_test
  a = rand_val; b = rand_val(20); op = rand_op
  expected = apply(op, a, b)
  input = "#{a}\n#{op}\n#{b}\n=\nq\n"
  [input, expected, "#{a} #{op} #{b} = #{strip(expected)}"]
end

def gen_evl_test
  a = rand_val(20); b = rand_val(10)
  op = rand_op
  # EVL: thunk build then force.
  # "lit a" then "<op> b" then "force"
  # result = a op b
  expected = apply(op, a, b)
  input = "lit #{a}\n#{op} #{b}\nforce\nq\n"
  [input, expected, "evl: #{a} #{op} #{b} = #{strip(expected)}"]
end

def gen_dfr_test
  a = rand_val(20); b = rand_val(10); op = rand_op
  # DFR defers ops in entry order, LIFO unwind on blank line.
  # Steps: [{op, a}, {op, b}]
  # LIFO: step 1 runs first: acc = 0 op b
  #       step 0 runs second: acc = (0 op b) op a
  # Result: (0 op b) op a
  first = apply(op, 0, b)
  expected = apply(op, first, a)
  input = "#{op} #{a}\n#{op} #{b}\n\nq\n"
  [input, expected, "dfr: #{a} #{op} #{b} (LIFO) = #{strip(expected)}"]
end

def gen_map_test
  a = rand_val(20); b = rand_val(10); op = rand_op
  # MAP: subject=0, actions=[op], objects padded/trimmed to match
  # Input: "val1,val2 op" → objects=[val1,val2], actions=[op]
  # Truncated to min(len,1): objects=[val1], action=[op]
  # Result: 0 op val1
  expected = apply(op, 0, a)
  input = "#{a} #{op}\nq\n"
  [input, expected, "map: 0 #{op} #{a} = #{strip(expected)}"]
end

# ── Static tests (error paths, special cases) ───────────

ERROR_TESTS = {
  soa: [
    { input: "10\n0\n/\nq\n", expect: "division by zero", name: "10 / 0 error" },
    { input: "q\n", expect: "subject?", name: "immediate q exits" },
  ],
  sao: [
    { input: "10\n/\n0\nq\n", expect: "division by zero", name: "10 / 0 error" },
  ],
  method: [
    { input: "10\ndivide\n0\nq\n", expect: "division by zero", name: "10.divide(0) error" },
  ],
  imperative: [
    { input: "10\n/\n0\nq\n", expect: "division by zero", name: "10 / 0 error" },
  ],
  stk: [
    { input: "5 0 / .\nq\n", expect: "division by zero", name: "5 0 / error" },
  ],
  chn: [
    { input: "+ 5\n/ 0\n=\nq\n", expect: "5", name: "error leaves acc unchanged" },
  ],
  ifc: [
    { input: "10\n/\n0\n=\nq\n", expect: "division by zero", name: "10 / 0 error" },
  ],
  dfr: [
    { input: "/ 0\n\nq\n", expect: "division by zero", name: "dfr / 0 error" },
  ],
  map: [],
  evl: [
    { input: "lit 5\nforce\nq\n", expect: "5", name: "lit 5 = 5" },
    { input: "lit 5\n+ 3\nforce\nq\n", expect: "8", name: "thunk: 5+3 = 8" },
    { input: "lit 10\n/ 0\nforce\nq\n", expect: "division by zero", name: "thunk: 10/0 error" },
  ],
  aos: [], aso: [], osa: [], oas: [],
}

STATIC_TESTS = {
  map: [
    { input: "1,2,3 + * /\nq\n", expect: "0.6666666666666666", name: "((0+1)*2)/3 = 0.666..." },
  ],
}

# ── Test runner ──────────────────────────────────────────

failures = []
seed = Time.now.to_i
srand(seed)
iterations = ENV["ITER"]&.to_i || 3

VARIANTS = %i[soa sao aos aso osa oas method imperative stk chn ifc dfr map evl]

puts "Go Calculator — randomized test suite"
puts "(seed: #{seed}, ITER=#{iterations}, #{VARIANTS.size} variants)\n\n"

VARIANTS.each do |variant|
  err_count = ERROR_TESTS[variant]&.size || 0
  static_count = STATIC_TESTS[variant]&.size || 0
  random_tests = 0
  passed = 0

  iterations.times do |i|
    random_tests += 1

    case variant
    when :soa
      input, expected, name = i.even? ? gen_soa_triple : gen_soa_chain
      out = run(variant, input)
      got = extract_value(out)
    when :sao
      input, expected, name = gen_sao_expr
      out = run(variant, input)
      got = extract_value(out)
    when :aos
      input, expected, name = gen_aos_triple
      out = run(variant, input)
      got = extract_value(out)
    when :aso
      input, expected, name = gen_aso_triple
      out = run(variant, input)
      got = extract_value(out)
    when :osa
      input, expected, name = gen_osa_triple
      out = run(variant, input)
      got = extract_value(out)
    when :oas
      input, expected, name = gen_oas_triple
      out = run(variant, input)
      got = extract_value(out)
    when :method
      input, expected, name = gen_method_test
      out = run(variant, input)
      got = extract_value(out)
    when :imperative
      input, expected, name = gen_imperative_test
      out = run(variant, input)
      got = extract_value(out)
    when :stk
      input, expected, name = gen_stk_test
      out = run(variant, input)
      got = extract_value(out)
    when :chn
      input, expected, name = gen_chn_test
      out = run(variant, input)
      got = extract_value(out)
    when :ifc
      input, expected, name = gen_ifc_test
      out = run(variant, input)
      got = extract_value(out)
    when :dfr
      input, expected, name = gen_dfr_test
      out = run(variant, input)
      got = extract_value(out)
    when :map
      input, expected, name = gen_map_test
      out = run(variant, input)
      got = extract_value(out)
    when :evl
      input, expected, name = gen_evl_test
      out = run(variant, input)
      got = extract_value(out)
    end

    if got && match_float(got, expected)
      passed += 1
      puts "  PASS #{variant} #{name}" if ENV["VERBOSE"]
    else
      puts "  FAIL #{variant} #{name}"
      puts "    expected: #{expected} (#{expected.class})"
      puts "    got: #{got.inspect}  raw: #{out.inspect}"
      failures << "#{variant}: #{name}"
    end
  end

  # ── Error tests ──
  (ERROR_TESTS[variant] || []).each do |t|
    out = run(variant, t[:input])
    if out.include?(t[:expect])
      passed += 1
      puts "  PASS #{variant} #{t[:name]}" if ENV["VERBOSE"]
    else
      puts "  FAIL #{variant} #{t[:name]}"
      puts "    expect text: #{t[:expect].inspect}"
      puts "    got: #{out.inspect}"
      failures << "#{variant}: #{t[:name]}"
    end
  end

  # ── Static tests ──
  (STATIC_TESTS[variant] || []).each do |t|
    out = run(variant, t[:input])
    got = extract_value(out)
    if got && t[:expect] == got
      passed += 1
      puts "  PASS #{variant} #{t[:name]}" if ENV["VERBOSE"]
    else
      puts "  FAIL #{variant} #{t[:name]}"
      puts "    expect: #{t[:expect]}"
      puts "    got: #{got.inspect}"
      failures << "#{variant}: #{t[:name]}"
    end
  end

  total = random_tests + err_count + static_count
  puts "  #{variant}: #{passed}/#{total} pass"
end

puts
if failures.empty?
  puts "ALL VARIANTS PASS  (seed: #{seed}, ITER=#{iterations})"
  exit 0
else
  puts "FAILURES (#{failures.size}):"
  failures.each { |f| puts "  #{f}" }
  puts "(seed: #{seed}, ITER=#{iterations})"
  exit 1
end
