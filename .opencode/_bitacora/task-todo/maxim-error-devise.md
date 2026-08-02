# Maxim Entity Ontology — Error Devise

## Group by MAX.ENTITY.ONTOLOGY

- [ ] map each observed error to its MAX.* category
- [ ] classify by ontology tier (entity, pattern, tool, code, sync)
- [ ] identify which maxims the error violates

## Error instances from vector-tooling-retrospective

- [ ] cross-tool import → violates `REF.LIB.DIRECTORY.LAYER`, `PROT.TOOL.COMPOSITE`
- [ ] shebang CLI format → violates audit-tool rule 2, rule 8
- [ ] MCP disabled config + present dir → violates clean-disable principle
- [ ] dead libs after consumers disabled → violates `MAX.DRY` (dead code)

## Devise

- [ ] what.pattern emerges across ontology tiers
- [ ] which.maxim would prevent the class
- [ ] propose new maxim or rule if gap found
