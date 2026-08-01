# Ruby Pathname — Scripts Patterns

## Root resolution

```ruby
ROOT = Pathname.new(__dir__).join("..", "..").realpath
```

`realpath` resolves symlinks. Used once at module load.

## Entity glob

```ruby
EntityGlob = ->(type) { ENTITIES.join(type, "**", "*.md").to_s }
```

Returns a glob string for Dir. `**` for recursive match.

## File basename without extension

```ruby
File.basename(path, ".md")   # "TERM.FOO" from "/path/TERM.FOO.md"
```

Used for ID extraction — ID == filename minus `.md`.

## Dir pattern

```ruby
Dir[EntityGlob.call(type)]                # list all entity files
Dir.children(ENTITIES.to_s)               # list entity type directories
Dir.glob(File.join(SQL_DIR, "*.sql"))     # sorted SQL files
Dir.exist?(path)                           # directory existence
Dir.empty?(path)                           # empty directory check
```

## File reading

```ruby
text = File.read(path)                     # full file as string
```

All files read as UTF-8 strings (Ruby default).
