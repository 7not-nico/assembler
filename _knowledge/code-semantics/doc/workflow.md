# Workflow

'report-outcomes': write conclusions to report/conclusions/, errors to report/errors/, walkthroughs to report/walkthroughs/
'scaffold-tools': generate toolchains for DB projects — creates lib, tools, and AGENTS.md from manifests and schema
'bootstrap-db': bootstrap new DB workflow project — generates structure, defines entities, creates schemas, scaffolds tools
'prune-stale': remove stale DB entries that no longer have corresponding source files after renames or deletions
'stage-create': create multiple related entities one at a time, auditing each step before proceeding
'survey-scripts': create surveys under .opencode/_scripts/survey/ following the survey workflow template
'format-command': format .opencode/commands/ files as structured steps with no fluff or voice guidelines
'refactor-skill': refactor .opencode/skills/ files to follow agentskills.io best practices
'detect-project': detect when a workflow or domain is complex enough to warrant a new project folder with its own database
'classify-tool': classify any .opencode/tools/ file by automata I/O model via decision tree
