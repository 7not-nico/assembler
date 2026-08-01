# File — Block-Based Open (Auto-Close)

## Pattern

```ruby
File.open(path, mode) { |f| f.read }
```

The block receives the file; the file is closed when the block exits — even if an exception is raised.

## Examples

```ruby
File.open('data.txt', 'r') { |f| f.read }
# => full file content, file closed

File.open('data.txt') { |f| f.each_line.first(3) }
# => first 3 lines, file closed
```

## Return value

`File.open` with a block returns the block's value, not the File object:

```ruby
result = File.open('data.txt') { |f| f.readlines.size }
# result => number of lines, file already closed
```

## Without block

Without block, returns the File object — caller must close:

```ruby
f = File.open('data.txt')
content = f.read
f.close
```

Prefer the block form in functional code — resource lifecycle is scoped to the block.

## Common patterns

```ruby
# Read all lines as array
File.open('data.txt') { |f| f.readlines.map(&:strip) }

# Process line by line (never loads whole file)
File.open('data.txt') { |f| f.each_line.select { |l| l.include?('ERROR') }.first(10) }

# Read as raw bytes
File.open('data.bin', 'rb') { |f| f.read }
```

## Modes

2nd argument is a mode string. Common:

| Mode | Meaning |
|------|---------|
| `'r'` | Read-only (default) |
| `'w'` | Write-only, truncate |
| `'a'` | Append |
| `'r+'` | Read-write |
| `'w+'` | Read-write, truncate |
| `'rb'` | Read binary |
| `'wb'` | Write binary |

Default is `'r'`.
