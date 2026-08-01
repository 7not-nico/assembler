# verify: core-exception.md + raise + rescue + ensure + methods + types
require_relative "_helper"

# --- exception-raise.md ---
assert_raises(RuntimeError, "raise string") { raise "msg" }
# --- exception-rescue.md ---
result = nil
begin
  raise ArgumentError, "bad"
rescue ArgumentError => ex
  result = ex.message
end
assert(result, "bad", "rescue specific type")

result = nil
begin
  raise "err"
rescue ArgumentError, TypeError => ex
  result = "wrong"
rescue RuntimeError => ex
  result = "caught"
end
assert(result, "caught", "rescue multiple types")

# Inline rescue
inline = (Integer("abc") rescue "fallback")
assert(inline, "fallback", "inline rescue")

# --- exception-ensure.md ---
ran_ensure = false
begin
  raise "err"
rescue RuntimeError
  # handled
ensure
  ran_ensure = true
end
assert(ran_ensure, true, "ensure runs")

ran_else = false
begin
  "ok"
rescue RuntimeError
  # not reached
else
  ran_else = true
end
assert(ran_else, true, "else runs on no error")

# --- exception-methods.md ---
e2 = RuntimeError.new("test msg")
assert(e2.message, "test msg", "message")
assert(e2.to_s, "test msg", "to_s")
assert(e2.inspect, "#<RuntimeError: test msg>", "inspect")

# backtrace
begin
  raise "backtrace test"
rescue => bt_e
  assert(bt_e.backtrace.is_a?(Array), true, "backtrace is Array")
  assert(bt_e.backtrace.first.include?("test-exception.rb"), true, "backtrace includes file")
end

# cause chaining
inner_msg = nil
begin
  begin
    raise "inner"
  rescue => inner
    raise RuntimeError, "outer", cause: inner
  end
rescue => outer
  inner_msg = outer.cause.message
end
assert(inner_msg, "inner", "cause chain")

# --- exception-types.md ---
assert(RuntimeError.new("x") == RuntimeError.new("x"), true, "== same type+msg")
assert(RuntimeError.new("x") == RuntimeError.new("y"), false, "== different msg")

report "ruby-exception"
