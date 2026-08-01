# Ruby File

`File` extends `IO`. Most common file operations.

## Opening files

```ruby
# With block — auto-closes
File.open("path.txt", "r") { |f| f.read }

# Without block — must close manually
f = File.open("path.txt", "w")
f.write("data")
f.close
```

## Modes

| Mode | Description |
|------|-------------|
| `"r"` | Read (default) |
| `"w"` | Write (truncate) |
| `"a"` | Append |
| `"r+"` | Read + write |
| `"w+"` | Read + write (truncate) |
| `"a+"` | Read + append |
| `"b"` | Binary (append to mode, e.g. `"rb"`) |

## Official docs

<https://docs.ruby-lang.org/en/3.4/File.html>
