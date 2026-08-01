# Ruby File — Reading

## Read entire file

```ruby
File.read("path")              # whole file as String
File.read("path", 100)         # first 100 bytes
File.binread("path")           # binary mode (ASCII-8BIT)
```

## Read by lines

```ruby
File.readlines("path")         # Array of lines
File.foreach("path") { |line| puts line }  # streaming, no array
```

## Read with open

```ruby
File.open("path") do |f|
  f.gets                        # next line (including "\n")
  f.readline                    # next line, raises EOFError
  f.each_line { |l| l }         # iterate lines
  f.read(1024)                  # read N bytes
  f.read                        # read rest
  f.eof?                        # true if at end
end
```

## ARGF — treat script args as file list

```ruby
# ruby script.rb a.txt b.txt
ARGF.each_line { |l| puts l }   # reads from all arg files
ARGF.read                       # entire concatenated input
```

## Stdin / Stdout / Stderr

```ruby
STDIN.gets           # read line from stdin
STDOUT.puts "hello"  # write to stdout
STDERR.puts "error"  # write to stderr
$stdin               # current stdin (may be reassigned)
```
