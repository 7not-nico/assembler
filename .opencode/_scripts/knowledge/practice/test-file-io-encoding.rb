# verify: file-io-encoding.md
require_relative "_helper"

TMP = "/tmp/knowledge-test-encoding"
File.write(TMP, "hello", encoding: "UTF-8")
content = File.read(TMP, encoding: "UTF-8")
assert(content, "hello", "read with encoding")
assert(content.encoding, Encoding::UTF_8, "encoding is UTF-8")

File.open(TMP, "r:ASCII") do |f|
  assert(f.read.encoding, Encoding::ASCII, "open with encoding arg")
end

File.delete(TMP)

report "ruby-file-io-encoding"
