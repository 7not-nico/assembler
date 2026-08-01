# exports: ParseFrontmatter, ParseAll
# ring: 0 (PURE)
# depends-on: ./loader

NormalizeTags = ->(fm) {
  return fm unless fm
  if fm[:tags].is_a?(String)
    fm[:tags] = fm[:tags].split(",").map(&:strip)
  end
  fm[:tags] ||= []
  fm
}

SafeLoad = ->(yaml_str) {
  begin
    YAML.safe_load(yaml_str, permitted_classes: [Date], symbolize_names: true)
  rescue Psych::SyntaxError
    nil
  end
}

ParseFrontmatter = ->(text) {
  m = text.match(/\A---\s*\n(.*?)\n---\s*\n/m)
  m ? NormalizeTags.call(SafeLoad.call(m[1])) : nil
}

ParseBackmatter = ->(text) {
  m = text.match(/---\s*\n(.*?)\n---\s*\z/m)
  m ? NormalizeTags.call(SafeLoad.call(m[1])) : nil
}

ParseMetadata = ->(text) {
  ParseFrontmatter.call(text) || ParseBackmatter.call(text)
}

ParseAll = ->(texts, filenames) {
  texts.each_with_index.filter_map { |t, i|
    fm = ParseMetadata.call(t)
    fm ? { file: filenames[i], **fm } : nil
  }
}
