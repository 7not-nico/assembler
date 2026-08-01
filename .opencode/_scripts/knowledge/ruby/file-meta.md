# Ruby File — Permissions & Metadata

## chmod / chown

```ruby
File.chmod(0o644, "path")      # set permissions (octal)
File.chown(uid, gid, "path")   # change owner/group (-1 = skip)
```

## File::Stat

```ruby
stat = File.stat("path")
stat.mode      # permission bits (int)
stat.uid       # owner uid
stat.gid       # group gid
stat.size      # bytes
stat.mtime     # modification time
stat.atime     # access time
stat.ctime     # change time
stat.world_readable?  # true if world-readable
stat.world_writable?  # true if world-writable
stat.setuid?   # true if setuid bit
stat.symlink?  # true if symlink (use File.lstat for symlink itself)
```

## File.umask

```ruby
File.umask(0o022)              # set umask for new files
File.umask                     # current umask (without changing)
```

## Rename / delete / link

```ruby
File.rename("old", "new")      # rename (moves across filesystems)
File.delete("path")            # delete file
File.unlink("path")            # same as delete
File.link("target", "link")    # hard link
File.symlink("target", "link") # symbolic link
File.realpath("link")          # resolve symlink to real path
```
