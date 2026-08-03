# exports: PATLIB_ID, PrefixToType, IdToType, IdToRing, SourceToRing
# ring: 0 (PURE)

PATLIB_ID = /\A([A-Z]{2,})((?:\.[A-Z][A-Z0-9.\/-]*)+)/

PrefixToType = {
  "COG" => "cognitions", "CON" => "concepts", "DEF" => "definitions",
  "TAX" => "taxonomies", "TERM" => "terms", "IDENTITY" => "identities",
  "BIO" => "biology", "CHE" => "chemistry", "MAX" => "maxims", "ABS" => "abstractions",
  "ALG" => "algorithms", "LING" => "linguistics", "RUL" => "rules",
  "NEX" => "nexus", "PROT" => "protocols", "PAT" => "patterns",
  "ILL" => "illustrations", "REF" => "references", "PER" => "persons", "PRE" => "precepts",
  "SPEC" => "specifications",
  "INV" => "investigations", "APO" => "apologias", "MAN" => "manifests",
  "ARC" => "archives", "NOTE" => "notes"
}

IdToType = ->(id) {
  m = id.to_s.match(PATLIB_ID)
  m ? PrefixToType[m[1]] : nil
}

IdToRing = ->(id) {
  type = IdToType.call(id.to_s)
  type ? TypeToRing.call(type) : nil
}

SourceToRing = ->(source) {
  m = source.to_s.match(PATLIB_ID)
  type = m ? PrefixToType[m[1]] : nil
  type ? TypeToRing.call(type) : nil
}
