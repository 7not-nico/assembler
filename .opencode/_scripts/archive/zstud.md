---
description: Create study-sessions/{name}/ with stud.txt — what's been done, what's left undone
subtask: true
---

Create study session for `$ARGUMENTS` at `study-sessions/$ARGUMENTS/`

1. `mkdir -p study-sessions/$ARGUMENTS/`

2. Write `study-sessions/$ARGUMENTS/stud.txt` with two sections:

   **What we've been doing** — recent work relevant to `$ARGUMENTS`:
   - New or modified patterns, terms, commands, rules, tools
   - Changelogs merged from existing `study-sessions/*/stud.txt`
   - Key decisions and outcomes

   **What's left undone** — open work in scope of `$ARGUMENTS`:
   - Unfinished items from existing `study-sessions/*/stud.txt` `[ ]` lists
   - `read-validate` failures
   - Known gaps or next steps

3. Confirm with `ls study-sessions/$ARGUMENTS/`
