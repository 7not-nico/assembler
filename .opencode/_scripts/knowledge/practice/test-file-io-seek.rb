# verify: file-io-seek.md
require_relative "_helper"

TMP = "/tmp/knowledge-test-seek"
File.write(TMP, "0123456789")

File.open(TMP, "r") do |f|
  f.seek(3)
  assert(f.read(2), "34", "seek + read")
  assert(f.tell, 5, "tell")
  assert(f.pos, 5, "pos")
  f.rewind
  assert(f.read(1), "0", "rewind")
end

File.delete(TMP)

report "ruby-file-io-seek"
