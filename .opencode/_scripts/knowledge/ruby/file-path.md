# Ruby File — Path & Directories

## Pathname

```ruby
require "pathname"

pn = Pathname.new("/foo/bar/baz.txt")
pn.basename      # "baz.txt"
pn.basename(".txt")  # "baz"
pn.dirname       # "/foo/bar"
pn.extname       # ".txt"
pn.expand_path   # "/foo/bar/baz.txt" (absolute)
pn.join("sub")   # "/foo/bar/baz.txt/sub" — use on dir
pn.cleanpath     # resolves "." and ".."
```

## Directory operations

```ruby
Dir.glob("*.rb")               # ["file.rb", ...] — glob pattern
Dir["*.rb"]                    # same — bracket syntax
Dir.glob("**/*.rb")            # recursive
Dir.exist?("dir")              # true/false
Dir.mkdir("newdir")            # create dir
Dir.mkdir("a/b/c")             # Errno::ENOENT — parent must exist
Dir.mkdir("a/b/c") rescue nil # need FileUtils.mkdir_p
Dir.delete("dir")              # remove (must be empty)

require "fileutils"
FileUtils.mkdir_p("a/b/c")     # recursive mkdir
FileUtils.rm_rf("dir")         # remove recursively (like rm -rf)
FileUtils.cp("src", "dst")     # copy file
FileUtils.mv("src", "dst")     # move/rename
```

## Current directory

```ruby
Dir.pwd       # current working directory (String)
Dir.chdir("/path")  # change — use with block for scoped
Dir.chdir("/path") { Dir.glob("*") }  # scoped, reverts after
```

## File.join

```ruby
File.join("dir", "sub", "file.txt")  # "dir/sub/file.txt"
# cross-platform — uses File::SEPARATOR
```
