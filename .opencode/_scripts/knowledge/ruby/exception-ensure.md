# Ruby Exception — Ensure / Else

## ensure — always runs

```ruby
file = File.open("path")
begin
  file.read
rescue => e
  puts "error: #{e}"
ensure
  file.close    # always runs, even on exception
end
```

## else — runs on no exception

```ruby
begin
  parse(json)
rescue ArgumentError => e
  puts "invalid"
else
  puts "parsed OK"   # only when no exception
ensure
  cleanup
end
```

## Nested begin/end

```ruby
begin
  begin
    raise "inner"
  rescue
    raise "outer"     # inner lost unless chained
  end
rescue => e
  puts e.message      # "outer"
end
```
