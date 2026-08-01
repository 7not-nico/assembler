Load `report-outcomes` skill at task completion. Skill writes conclusions to `report/conclusions/`, errors to `report/errors/`, walkthroughs to `report/walkthroughs/`.

Scope: task-level. Trigger on task completion.
Fallback: write `.opencode/reports/{timestamp}.md` manually.
