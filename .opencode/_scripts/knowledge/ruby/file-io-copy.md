# Ruby File — IO.copy_stream

## IO.copy_stream

Efficient streaming copy between I/O objects or file paths:

```ruby
IO.copy_stream("src.txt", "dst.txt")            # copy entire file
IO.copy_stream("src.txt", "dst.txt", 1024)      # limit to N bytes
IO.copy_stream("src.txt", "dst.txt", nil, 100)  # skip first 100 bytes
```

## With any I/O objects

```ruby
File.open("src") do |src|
  File.open("dst", "w") do |dst|
    IO.copy_stream(src, dst)
  end
end
```

Returns bytes copied. Uses OS-level sendfile/copy range when possible.
