## TODO-pat-lib-contract-enforcement

Update `PAT.LIB.CONTRACT.ENFORCEMENT` to cover the pre-save enforcement gap for manual editor saves.

### Finding

The pattern uses `tool.execute.before` to catch violations at write time (agent writes). But for manual editor saves, `tool.execute.before` doesn't fire — only `file.edited` fires (after save). This means manual saves have no pre-write enforcement. The pattern describes itself as covering "all write paths" but only covers agent-triggered writes.

### Changes

- Add a section: "Manual editor saves have no pre-write enforcement. `file.edited` fires after save — violations are detected post-facto. For pre-save enforcement on manual edits, no hook is available. Consider registering `tool.execute.before` for agent writes + `file.edited` for post-save auditing on manual edits."

- Update the applicability table to show coverage gaps rather than claiming universal coverage.

### Priority

medium — pattern is accurate for agent writes but overstates its scope; doesn't cause bugs but misleads architectural decisions

### Verification

Pattern explicitly states which edit paths have pre-save coverage and which have only post-save auditing.
