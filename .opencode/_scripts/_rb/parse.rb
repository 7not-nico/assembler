# exports: ReadParse
# ring: 0 (PURE)

ReadParse = ->(path) {
  ParseMetadata.call(File.read(path))
}
