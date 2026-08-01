# Ruby File — Encoding

## Open with encoding

```ruby
File.open("path", "r:UTF-8")              # read as UTF-8
File.open("path", "r:Shift_JIS:UTF-8")    # transcode Shift_JIS to UTF-8 on read
File.open("path", "w:UTF-8")              # write as UTF-8
```

## set_encoding

```ruby
File.open("path") do |f|
  f.set_encoding(Encoding::UTF_8)
end
```

## Read/write with encoding

```ruby
File.read("path", encoding: "UTF-8")
File.write("path", data, encoding: "UTF-8")
```

## Encoding names

```ruby
Encoding::UTF_8       # UTF-8
Encoding::ASCII       # US-ASCII (7-bit)
Encoding::SHIFT_JIS   # Shift_JIS
Encoding::EUC_JP      # EUC-JP
Encoding::BINARY      # ASCII-8BIT (binary)
```

## Encoding checks

```ruby
str.encoding                    # Encoding::UTF_8
str.valid_encoding?             # true — no invalid byte sequences
str.force_encoding("BINARY")    # re-tag bytes without conversion
str.encode("UTF-8", "Shift_JIS") # transcode
```
