# Surveys

**Route** — create surveys under `.opencode/_shell/survey/`: check for overlap, scaffold `sNN-` scripts, separate pure from IO, write structured reports.

**Target** — load `survey-scripts` before survey work.

**Notes**

- Self-audit first — check existing surveys for overlap; extend before creating new.
- Name the survey `{qualifier}-{subject}/` — qualifier names the analysis mode.
- Keep 1-4 scripts per directory — one concern per script.
- Separate pure lambdas from IO — define pure functions first, run main logic after.
- Keep surveys read-only — output to stdout; route reports to `report/` manually or via pipe.
