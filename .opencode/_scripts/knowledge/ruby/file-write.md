# Ruby File — Writing

## Write entire file

```ruby
File.write("path", "content")               # overwrite
File.write("path", "content", mode: "a")    # append
File.binwrite("path", binary_data)          # binary mode
```

## Write with open

```ruby
File.open("path", "w") do |f|
  f.write("line1\n")
  f.puts "line2"                 # adds newline
  f.print "no newline"
  f << "another"                 # shovel operator
end
```

## Tempfile

```ruby
require "tempfile"
Tempfile.create do |f|
  f.puts "temporary data"
  f.path  # "/tmp/...random..."
end  # auto-unlinks
```
