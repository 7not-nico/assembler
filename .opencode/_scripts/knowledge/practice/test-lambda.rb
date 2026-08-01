# verify: lambda-stabby.md
require_relative "_helper"

# --- definition ---
double = ->(x) { x * 2 }
assert(double.call(3), 6, "lambda.call")
assert(double[3], 6, "lambda.[]")
assert(double === 3, 6, "lambda.===")
assert(double.(3), 6, "lambda.()")

# --- arity ---
no_args = -> { 42 }
assert(no_args.call, 42, "no-arg lambda")

two_args = ->(a, b) { a + b }
assert(two_args.call(3, 4), 7, "two-arg lambda")
assert_raises(ArgumentError, "two-arg lambda wrong count") { two_args.call(3) }

optional = ->(a, b = 1) { a + b }
assert(optional.call(5), 6, "optional arg default")
assert(optional.call(5, 2), 7, "optional arg override")

# --- composition >> ---
add_one = ->(x) { x + 1 }
composed = double >> add_one
assert(composed.call(5), 11, ">> double then add_one (5*2+1)")
composed_rev = double << add_one
assert(composed_rev.call(5), 12, "<< add_one then double (5+1)*2")

# --- reduce pipeline ---
steps = [->(x) { x * 2 }, ->(x) { x + 3 }, ->(x) { x.to_s }]
pipeline = steps.reduce(->(x) { x }, &:>>)
assert(pipeline.call(5), "13", "reduce pipeline (5*2+3).to_s")

# --- guard clause pattern ---
guard = ->(x) {
  return nil unless x
  x * 2
}
assert(guard.call(nil), nil, "guard nil")
assert(guard.call(5), 10, "guard non-nil")

report "ruby-lambda"
