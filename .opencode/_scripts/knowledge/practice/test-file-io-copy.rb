# verify: file-io-copy.md
require_relative "_helper"

TMP_SRC = "/tmp/knowledge-test-copy-src"
TMP_DST = "/tmp/knowledge-test-copy-dst"
File.write(TMP_SRC, "0123456789")

IO.copy_stream(TMP_SRC, TMP_DST)
assert(File.read(TMP_DST), "0123456789", "IO.copy_stream full")

IO.copy_stream(TMP_SRC, TMP_DST, 4)
assert(File.read(TMP_DST).length, 4, "IO.copy_stream length-limited")

IO.copy_stream(TMP_SRC, TMP_DST, nil, 3)
assert(File.read(TMP_DST), "3456789", "IO.copy_stream with offset")

File.delete(TMP_SRC)
File.delete(TMP_DST)

report "ruby-file-io-copy"
