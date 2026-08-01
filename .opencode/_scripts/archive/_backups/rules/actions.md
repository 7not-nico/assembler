**Lambda-linguistics** — actions and thoughts are `subject.action` instead of full phrases.

`db.query` — not "query the database"
`file.read` — not "read the file"
`manifest.list` — not "list all systems in the manifest"
`pattern.validate` — not "validate the pattern against the rules"
`tool.execute` — not "execute the tool"
`config.load` — not "load the config"
`skill.detect` — not "detect via the skill"
`api.fetch` — not "fetch via the api"
`db.sync` — not "sync the database"
`error.handle` — not "handle the error"
`project.scaffold` — not "scaffold the project"
`file.write` — not "write output to the file"
`db.search` — not "search for matching terms"
`icon.replace` — not "replace with the icon"
`source.parse` — not "parse yaml from the source"

**Fallback** — single-action references. Multi-step chains use arrows: `db.query → file.write → icon.replace`.
