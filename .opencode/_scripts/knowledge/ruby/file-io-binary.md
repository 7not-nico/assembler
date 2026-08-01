# Ruby File — Binary I/O (pack, unpack, binread, binwrite)

## binread / binwrite

```ruby
File.binwrite("path", "\xFF\xFE\x00\x01")
File.binread("path", 4)         # reads in binary mode (ASCII-8BIT)
```

## pack — array to binary string (encoding ASCII-8BIT)

```ruby
[255, 128, 64].pack("C*")            # "\xFF\x80\x40" — ASCII-8BIT encoding
[0xDEAD, 0xBEEF].pack("n*")          # "\xDE\xAD\xBE\xEF" — big-endian 16-bit
```

## unpack — binary string to array

```ruby
"\xFF\x80\x40".unpack("C*")     # [255, 128, 64]
"\xDE\xAD\xBE\xEF".unpack("n*") # [57005, 48879]  — 0xDEAD, 0xBEEF
```

## Common directives

| Dir | Type | Size |
|-----|------|------|
| `C` | 8-bit unsigned | 1 byte |
| `S<` | 16-bit LE unsigned | 2 bytes |
| `S>` | 16-bit BE unsigned | 2 bytes |
| `L<` | 32-bit LE unsigned | 4 bytes |
| `L>` | 32-bit BE unsigned | 4 bytes |
| `Q<` | 64-bit LE unsigned | 8 bytes |
| `Q>` | 64-bit BE unsigned | 8 bytes |
| `F` | Float (native) | 4 bytes |
| `D` | Double (native) | 8 bytes |
| `A` | ASCII string | variable |
| `Z` | null-terminated string | variable |
| `H` | hex string (high nybble first) | variable |
