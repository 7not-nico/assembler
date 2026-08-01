# RUBY.SQLITE3.IMPORT — import role file YAML frontmatter into semantics.db via Ruby + SQLite3

Semantic role files in `semantic/` are registered into a SQLite database for querying and cross-referencing. Two Ruby scripts handle registration: `schema/push.rb` upserts role metadata; `schema/url.rb` seeds the URL reference table.

## Schema

`schema/schema.sql` defines three tables:

`roles` — one row per role file. Primary key is `id` in `LANGUAGE.ROLE` format (dot separator, uppercase). Columns: id, language, role, title, definition, canonical, tags, status, file_path, created_at, updated_at.

`sources` — one row per source URL per role. Linked to `roles(id)` via `role_id`. Columns: section (spec reference), url.

`precedes` — one row per precedence edge. Linked to `roles(id)` via `role_id` and `precedes_id`. Encodes which roles conceptually precede others.

`reference_urls` — deduplicated URL registry (seeded by url.rb). Columns: id, language, section, url, roles. The `roles` column lists comma-separated role IDs using that URL.

## Script: push.rb

`schema/push.rb` — upserts role YAML frontmatter into roles/sources/precedes tables.

Procedure:
1. Glob `semantic/*-{subject,object,action}.md` — matches all role files
2. Extract YAML frontmatter between `---` delimiters
3. Parse with `YAML.safe_load` — skip file silently if frontmatter missing
4. Upsert `roles` row via `INSERT ... ON CONFLICT(id) DO UPDATE`
5. Insert `sources` rows (append-only, no dedup)
6. Insert `precedes` rows via `INSERT OR IGNORE`
7. Print `OK id` or `SKIP filename: reason` per file

### YAML frontmatter constraints

Values containing special YAML syntax must be quoted:

- Colons in text: `definition: "text with :: colons"` — unquoted colons parse as mapping
- Curly braces in code: `canonical: "my_method { |x| x }"` — unquoted braces parse as flow mapping
- Commas or hash symbols in unquoted strings may also trigger parse errors

Quote `definition` and `canonical` fields when they contain any of `: { } [ ] , #`. Other fields rarely need quoting.

## Script: url.rb

`schema/url.rb` — reads all role files, deduplicates URLs by unique URL, writes `schema/url.sql` and seeds `reference_urls` table in semantics.db.

Procedure:
1. Glob `semantic/*-{subject,object,action}.md`
2. Extract YAML frontmatter, collect all `sources` entries
3. Deduplicate by URL → group roles per URL
4. Write `schema/url.sql` — single multi-row `INSERT OR IGNORE` in 02-events.sql seed format
5. Create `reference_urls` table if absent in semantics.db
6. Insert all rows via `INSERT OR IGNORE`
7. Print row counts for both outputs

## CLI: query.rb

`schema/query.rb` — data-driven CLI for browsing semantics.db. Dispatch table of command definitions, no branch logic.

Six commands:

```
ruby schema/query.rb roles                # list all 9 role files with status
ruby schema/query.rb lang <name>          # roles for one language (default Ruby)
ruby schema/query.rb sources [role]       # sources for a role, or all if omitted
ruby schema/query.rb precedes [role]      # precedence chain, or all if omitted
ruby schema/query.rb urls [language]      # reference URLs, filter by language
ruby schema/query.rb sql <statement>      # run arbitrary SQL
```

## Workflow

After writing or editing any role file, run both scripts in order:

```bash
# 1. Upsert role metadata into roles/sources/precedes tables
ruby schema/push.rb

# 2. Regenerate url.sql + seed reference_urls table
ruby schema/url.rb
```

Browse results:

```bash
ruby schema/query.rb roles
ruby schema/query.rb lang C
ruby schema/query.rb sources RUBY.SUBJECT
```

Requires the `sqlite3` gem. Re-create the database with:

```bash
rm -f schema/semantics.db
ruby -e "require 'sqlite3'; db = SQLite3::Database.new('schema/semantics.db'); File.read('schema/schema.sql').split(';').each { |s| db.execute(s.strip) rescue nil }"
ruby schema/push.rb
ruby schema/url.rb
```

Composes with: METADATA.FIELDS.ENUMERATE, DRAFT.ONE.ROLE.AT.TIME
