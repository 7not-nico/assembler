# verify: core-proc.md + func-lambda.md + func-closure.md + func-composition.md + func-curry.md + anonymous-params.md + to-proc.md
require_relative "_helper"

# --- proc.md: creation ---
p1 = Proc.new { |x| x**2 }
assert(p1.call(3), 9, "Proc.new call")
p2 = proc { |x| x**2 }
assert(p2.call(3), 9, "proc call")
p3 = lambda { |x| x**2 }
assert(p3.call(3), 9, "lambda call")
p4 = ->(x) { x**2 }
assert(p4.call(3), 9, "stabby lambda call")
assert(p4[3], 9, "[] shorthand")
assert(p4.(3), 9, ".() shorthand")

# --- proc.md: arity ---
assert(proc {}.arity, 0, "arity 0")
assert(proc { |a| }.arity, 1, "arity 1")
assert(proc { |a, b| }.arity, 2, "arity 2")
assert(proc { |*a| }.arity, -1, "arity -1 splat")
assert(proc { |a, *b| }.arity, -2, "arity -2 partial splat")

# --- lambda.md: lambda vs non-lambda ---
# strict arity
l = lambda { |a, b| [a, b] }
assert(l.call(1, 2), [1, 2], "lambda: correct args")
assert_raises(ArgumentError, "lambda: too many args") { l.call(1, 2, 3) }
assert_raises(ArgumentError, "lambda: too few args") { l.call(1) }

p = proc { |a, b| [a, b] }
assert(p.call(1, 2), [1, 2], "proc: correct args")
assert(p.call(1, 2, 3), [1, 2], "proc: extra discarded")
assert(p.call(1), [1, nil], "proc: missing = nil")
assert(p.call([1, 2]), [1, 2], "proc: array deconstructed")

# lambda? predicate
assert(->{}.lambda?, true, "-> lambda? true")
assert(proc {}.lambda?, false, "proc lambda? false")
assert(Proc.new {}.lambda?, false, "Proc.new lambda? false")

# return semantics
def test_return
  -> { return 3 }.call
  proc { return 4 }.call
  5
end
assert(test_return, 4, "proc return exits method")

# --- closure.md: closures ---
def gen_times(factor)
  proc { |n| n * factor }
end
t3 = gen_times(3)
t5 = gen_times(5)
assert(t3.call(12), 36, "closure: factor=3")
assert(t5.call(12), 60, "closure: factor=5")

x = 10
snap = -> { x }
x = 20
assert(snap.call, 20, "closure captures variable, not value")

# --- composition.md: >> / << ---
f = proc { |x| x * x }
g = proc { |x| x + x }
assert((f >> g).call(2), 8, "f >> g: f then g")
assert((f << g).call(2), 16, "f << g: g then f")

# --- curry.md: currying ---
add = ->(x, y) { x + y }
add5 = add.curry[5]
assert(add5.call(10), 15, "curry: add5(10)")

b = proc { |x, y, z| (x || 0) + (y || 0) + (z || 0) }
assert(b.curry[1][2][3], 6, "curry: 3 args")
assert(b.curry[1, 2][3, 4], 6, "curry: partial batch")

divisible = ->(x, y) { y % x == 0 }.curry
assert((1..10).select(&divisible.(5)), [5, 10], "curry: filter factory")

# --- anonymous-params.md: it, _1 ---
assert([1, 2, 3].map { it**2 }, [1, 4, 9], "it param")
assert({a: 1, b: 2}.map { "#{_1}=#{_2}" }, ["a=1", "b=2"], "numbered params")
assert([10, 20].zip([30, 40]).map { _1 + _2 }, [40, 60], "_1 + _2")

# --- to-proc.md: conversion protocol ---
assert(:to_s.to_proc.call(1000), "1000", "Symbol#to_proc")
assert([1, 2, 3].map(&:to_s), ["1", "2", "3"], "&:to_s map")
assert({a: 1}.to_proc.call(:a), 1, "Hash#to_proc")

# --- parameters ---
pr = proc { |x, y=42, *other| }
assert(pr.parameters, [[:opt, :x], [:opt, :y], [:rest, :other]], "proc parameters")
lr = lambda { |x, y=42, *other| }
assert(lr.parameters, [[:req, :x], [:opt, :y], [:rest, :other]], "lambda parameters")
assert(pr.parameters(lambda: true), [[:req, :x], [:opt, :y], [:rest, :other]], "proc treated as lambda")
assert(lr.parameters(lambda: false), [[:opt, :x], [:opt, :y], [:rest, :other]], "lambda treated as non-lambda")

# --- source_location ---
loc = -> { }.source_location
assert(loc.is_a?(Array), true, "source_location is Array")
assert(loc[0].include?("test-proc.rb"), true, "source_location file")

# --- numbered params arity ---
np = proc { _1 + _2 }
assert(np.arity, 2, "numbered params proc arity")
nl = lambda { _1 + _2 }
assert(nl.arity, 2, "numbered params lambda arity")

report "ruby-proc"
