## TODO-complete-hook-scope-audit

Final verification pass after all TODO items resolved.

### Checklist

- [ ] `PROT.PLUGIN.VALIDATION` — expanded hook matrix, three-tier model
- [ ] `PROT.PLUGIN.DIRECTION` — disambiguated "file-change hooks"
- [ ] `PROT.PLUGIN.CANDIDATE` — criterion-3 exception rewritten
- [ ] `PROT.TOOL.HOOKS` — `file.edited` added with scope note
- [ ] `NEX.TOOL.LAYER.CHOICE` — three-tier event matrix replaces "only layer"
- [ ] `ILL.TOOL.LAYER.CHOICE.DECIDE` — Scenario C qualified / new scenario added
- [ ] `auto-sync.ts` — `tool.execute.after` handler added
- [ ] `ILL.PLUGIN.CANDIDATE.SCORING` — updated for auto-sync fix
- [ ] `PROT.SCHEMA.FORMAT` — scope caveat added
- [ ] `REF.SCHEMA.PLUGIN.BOILERPLATE` — scope caveat added
- [ ] `ILL.SCHEMA.PLUGIN.BOILERPLATE` — scope caveat added
- [ ] `REF.SCHEMA.SEED.MUTATION` — enforcement line updated
- [ ] `PAT.LIB.CONTRACT.ENFORCEMENT` — coverage gap documented
- [ ] `TERM.OPENCODE.PLUGIN` — hooks list added
- [ ] `TERM.FS.WATCH` — promoted from backup to active

### Verification commands

```
# Validate all entity files
read-validate

# Check sync completes
write-sync all

# Confirm terms visible
read-selection --type terms --query "fs.watch"
read-selection --type terms --query "file.edited"
```

### Priority

high — verification pass ensures no entity was missed
