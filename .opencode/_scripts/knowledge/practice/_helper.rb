# helper: assertion utility for practice scripts
$pass = 0
$fail = 0

def assert(actual, expected, label)
  if actual == expected
    $pass += 1
    puts "  PASS: #{label}"
  else
    $fail += 1
    puts "  FAIL: #{label} — expected #{expected.inspect}, got #{actual.inspect}"
  end
end

def assert_raises(ex_class, label)
  yield
  $fail += 1
  puts "  FAIL: #{label} — expected #{ex_class} but no exception raised"
rescue ex_class
  $pass += 1
  puts "  PASS: #{label}"
rescue => e
  $fail += 1
  puts "  FAIL: #{label} — expected #{ex_class}, got #{e.class}: #{e.message}"
end

def report(file)
  puts
  puts "=== #{file}: #{$pass} passed, #{$fail} failed ==="
  exit 1 if $fail > 0
end
