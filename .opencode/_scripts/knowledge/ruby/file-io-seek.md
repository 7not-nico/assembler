# Ruby File — I/O Seek (seek, tell, pos, rewind)

## seek

Move read/write position:

```ruby
File.open("path", "r") do |f|
  f.seek(100)                  # seek to byte 100 from start (IO::SEEK_SET)
  f.seek(10, IO::SEEK_CUR)     # seek 10 bytes forward from current
  f.seek(-5, IO::SEEK_END)     # seek 5 bytes before end
end
```

## tell / pos

```ruby
File.open("path", "r") do |f|
  f.tell                       # 0
  f.seek(42)
  f.pos                        # 42 — alias for tell
end
```

## rewind

```ruby
File.open("path", "r") do |f|
  f.seek(100)
  f.rewind                     # back to position 0
  f.pos                        # 0
end
```

## Constants

```ruby
IO::SEEK_SET   # 0  — seek from start (default)
IO::SEEK_CUR   # 1  — seek from current
IO::SEEK_END   # 2  — seek from end
```
