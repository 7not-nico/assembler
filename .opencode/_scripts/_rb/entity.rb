# exports: LoadAllEntities, LoadEntities
# ring: 0 (PURE)

LoadAllEntities = -> {
  files = EntityTypes.flat_map { |t|
    Dir[EntityGlob.call(t)].map { |p| { type: t, path: Pathname.new(p), name: File.basename(p, ".md") } }
  }
  texts = files.map { |f| f[:path].read }
  entries = ParseAll.call(texts, files.map { |f| f[:name] })
  entries.each { |e| e[:type] = files.find { |f| f[:name] == e[:file] }[:type] }
  entries
}

LoadEntities = ->(type) {
  files = Dir[EntityGlob.call(type)].map { |p| { type: type, path: Pathname.new(p), name: File.basename(p, ".md") } }
  texts = files.map { |f| f[:path].read }
  entries = ParseAll.call(texts, files.map { |f| f[:name] })
  entries.each { |e| e[:type] = type }
  entries
}
