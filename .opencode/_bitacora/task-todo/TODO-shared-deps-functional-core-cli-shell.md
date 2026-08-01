## TODO-shared-deps-functional-core-cli-shell

Every tool is an imperative shell around a functional core (MAX.ENTITY.ONTOLOGY). Shared deps in `_lib/` as pure/IO functions. CLI tools in `tools/` parse args, call lib, print output. Each dep and tool distinct — one concern per file.

### Audit

- [ ] List every `_lib/` file and its purity class (`// purity: PURE | IO`).
- [ ] List every `tools/` file and its tool class (`// @toolclass CODE`).
- [ ] Flag lib files missing purity annotation.
- [ ] Flag lib files with mixed concerns (multiple distinct functions that should be separate files).
- [ ] Flag tools missing toolclass annotation.
- [ ] Flag tools with multiple concerns (doing more than one thing).
- [ ] Flag cross-tool imports — shared logic must route through lib, never tool-to-tool.

### Separation

- [ ] Split any lib file with multiple concerns into one file per concern.
- [ ] Extract shared logic from tools into lib modules where missing.
- [ ] Ensure import direction: tool → lib, never lib → tool, never tool → tool.

### Purity annotations

- [ ] Every lib file annotated with `// purity: PURE` (no side effects) or `// purity: IO` (database, filesystem, network).
- [ ] Inside IO files, internal function purity declared with `// depends-on:` where applicable.
- [ ] Every tool annotated with `// @toolclass RECG | TRNS | GENR | SGNL` at line 1 per PROT.TOOL.AUTOMATON.

### Architecture rules

- [ ] Distill the functional core / imperative shell pattern into a pattern or protocol if absent.
- [ ] Document: what belongs in lib vs tools, import direction, file naming, annotation requirements.

### Priority

high — foundational for tool architecture and code quality.

### Verification

- Every lib file has purity annotation.
- Every tool has toolclass annotation.
- No cross-tool imports.
- No lib file with multiple concerns.
- `bun run` on each tool succeeds without errors.
