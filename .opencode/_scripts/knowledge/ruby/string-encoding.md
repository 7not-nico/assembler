# Ruby String Encoding

Every string has an encoding. Ruby transparently handles multi-byte encodings (UTF-8, UTF-16, etc.).

## Querying

```ruby
"hello".encoding          # #<Encoding:UTF-8>
"hello".valid_encoding?   # true
"hello".ascii_only?       # true
```

## Changing

| Method | Effect |
|--------|--------|
| `encode!("UTF-8")` | transcodes content to new encoding |
| `force_encoding("BINARY")` | changes encoding tag without touching bytes |
| `scrub!("?")` | replaces invalid bytes with given char |
| `unicode_normalize!` | NFC/NFD/NFKC/NFKD normalization |

## Encoding-aware methods

`length` returns characters (not bytes). `bytesize` returns bytes. Slicing by index is character-based for multi-byte encodings.

```ruby
"こんにちは".length     # 5
"こんにちは".bytesize   # 15
"こんにちは"[2]         # "に"
```
