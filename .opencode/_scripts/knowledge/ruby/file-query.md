# Ruby File — Querying (exist?, file?, directory?, size, zero?, fnmatch?)

## Existence checks

```ruby
File.exist?("path")       # true/false
File.file?("path")        # true if regular file
File.directory?("path")   # true if directory
File.symlink?("path")     # true if symlink
```

## Permission checks

```ruby
File.readable?("path")    # true if readable by process
File.writable?("path")    # true if writable
File.executable?("path")  # true if executable
File.world_readable?      # mode as int or nil
File.world_writable?      # mode as int or nil
```

## Size

```ruby
File.size("path")          # bytes
File.zero?("path")         # true if empty
File.empty?("path")        # true if empty or does not exist
```

## Timestamps

```ruby
File.mtime("path")         # last modified Time
File.atime("path")         # last access Time
File.ctime("path")         # change time (not creation)
```

## Glob matching

```ruby
File.fnmatch?("*.rb", "test.rb")    # true
File.fnmatch?("foo/**", "foo/bar/baz")  # true — recursive
File.fnmatch?("a?c", "abc")         # true — single char wildcard
```
