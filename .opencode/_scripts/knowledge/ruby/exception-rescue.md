# Ruby Exception — Rescue / Handling

## Basic rescue

```ruby
begin
  risky_call
rescue
  handle_error
end
```

## Rescue specific types

```ruby
begin
  parse(json)
rescue ArgumentError => e
  puts e.message       # exception message
rescue TypeError
  puts "type error"
end
```

## Rescue multiple types

```ruby
begin
  fetch_data
rescue ArgumentError, TypeError => e
  puts "bad input: #{e}"
end
```

## Inline rescue (expression)

```ruby
value = parse(x) rescue DEFAULT   # catches StandardError
```

Avoid inline rescue for expected errors — catches everything.

## Retry

```ruby
attempts = 0
begin
  fetch_data
rescue
  attempts += 1
  retry if attempts < 3
end
```
