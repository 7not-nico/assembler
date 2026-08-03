# exports: RingGroups, TypeToRing, GroupRings, AllRings, AxiomaticTypes, EncyclopedicTypes, CompositionTypes, ArchitectonicTypes, ChronicleTypes
# ring: 0 (PURE)
# depends-on: ./loader

RingGroups = {
  axiomatic: {
    0 => { types: %w[maxims precepts specifications], name: "Maxim, Precept, Specification" },
    1 => { types: %w[identities], name: "Identity" },
    2 => { types: %w[abstractions algorithms linguistics], name: "Abstraction, Algorithm, Linguistic" }
  },
  encyclopedic: {
    0 => { types: %w[etymologies], name: "Etymology" },
    1 => { types: %w[cognitions], name: "Cognition" },
    2 => { types: %w[concepts definitions taxonomies], name: "Concept, Definition, Taxonomy" },
    3 => { types: %w[terms biology chemistry], name: "Term, Biology, Chemical" }
  },
  composition: {
    0 => { types: %w[protocols], name: "Protocol" },
    1 => { types: %w[patterns], name: "Pattern" },
    2 => { types: %w[nexus], name: "Nexus" },
    3 => { types: %w[illustrations references], name: "Illustration, Reference" }
  },
  architectonic: {
    0 => { types: %w[rules], name: "Rule" },
    1 => { types: %w[commands skills], name: "Command, Skill" },
    2 => { types: %w[tools], name: "Tool" }
  },
  chronicle: {
    0 => { types: %w[persons], name: "Person" },
    1 => { types: %w[investigations apologias manifests], name: "Investigation, Apologia, Manifest" },
    2 => { types: %w[archives notes], name: "Archive, Note" }
  }
}

TypeToRing = ->(type) {
  RingGroups.each do |group_name, rings|
    rings.each do |ring_num, info|
      return { group: group_name, ring: ring_num, name: info[:name] } if info[:types].include?(type)
    end
  end
  nil
}

GroupRings = ->(group) { RingGroups[group] || {} }

AllRings = -> {
  RingGroups.flat_map { |g, rings| rings.map { |r, info| { group: g, ring: r, **info } } }
}

AxiomaticTypes = RingGroups[:axiomatic].values.flat_map { |v| v[:types] }
EncyclopedicTypes = RingGroups[:encyclopedic].values.flat_map { |v| v[:types] }
CompositionTypes = RingGroups[:composition].values.flat_map { |v| v[:types] }
ArchitectonicTypes = RingGroups[:architectonic].values.flat_map { |v| v[:types] }
ChronicleTypes = RingGroups[:chronicle].values.flat_map { |v| v[:types] }

AllRingsFlat = AllRings.call
AllRingTypes = AxiomaticTypes + EncyclopedicTypes + CompositionTypes + ArchitectonicTypes + ChronicleTypes
