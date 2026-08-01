# File — Functional IO Patterns

## Read-write-read pipeline

```ruby
content = File.read('data.txt')
                .upcase
                .gsub(/old/, 'new')
File.write('data.txt', content)
```

## Read → transform → write in one step

```ruby
File.write('out.txt', File.readlines('in.txt').map(&:strip).reject(&:empty?).join("\n"))
```

## copy_stream

Efficient streaming copy between IO objects (uses OS-level buffering):

```ruby
IO.copy_stream('src.bin', 'dst.bin')
# => bytes copied

# With offset and length
IO.copy_stream('src.bin', 'dst.bin', 1024, 512)
# copy 1024 bytes starting at offset 512
```

## Tempfile for intermediate results

```ruby
require 'tempfile'

Tempfile.create('filter') do |f|
  f.write(File.read('input.txt').gsub(/bad/, 'good'))
  f.rewind
  File.write('output.txt', f.read)
end
# Tempfile deleted after block
```

## Probe with File.size before read

```ruby
File.write('out.txt', File.size('in.txt') > 0 ? File.read('in.txt').upcase : '')
```

## Unix filter pattern (pipeline)

```ruby
content = IO.popen('grep ERROR server.log', 'r') { |io| io.read }
```

Or read from a pipe using `foreach`:

```ruby
IO.popen('sort data.txt') { |io| io.each_line { |line| puts line } }
```

## Tips

| Pattern | When to use |
|---------|-------------|
| `File.read` + chain | Small files, full transform |
| `File.foreach` + lazy | Large files, early exit |
| `File.open` block | Need custom mode/binary |
| `IO.copy_stream` | Binary copy, no transform |
| `IO.popen` | Shell pipeline |
