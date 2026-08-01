# verify: file-io-binary.md
require_relative "_helper"

TMP = "/tmp/knowledge-test-binary"

File.binwrite(TMP, "\xFF\xFE\x00\x01")
data = File.binread(TMP, 4)
assert(data.bytesize, 4, "binread bytesize")
assert(data.encoding, Encoding::BINARY, "binread encoding (ASCII-8BIT)")

packed = [255, 128, 64].pack("C*")
assert(packed.bytes, [255, 128, 64], "pack C*")

unpacked = "\xFF\x80\x40".unpack("C*")
assert(unpacked, [255, 128, 64], "unpack C*")

File.delete(TMP)

report "ruby-file-io-binary"
