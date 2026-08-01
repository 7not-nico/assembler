# Entity schema

- `reference` — singular form, avoids SQLite reserved word
- Tags — comma-separated without spaces in patterns/terms (`convention,data-flow`); inline array `[tag1, tag2]` in rules, skills, commands
- Commands: `{verb}-{domain}.md`, YAML registry at `commands/yamls/`. Query via `read-selection --type commands`.
