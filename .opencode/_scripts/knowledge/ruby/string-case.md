# Ruby String Casing

All methods have bang (`!`) versions that mutate `self`.

```ruby
"hello".upcase       # "HELLO"
"HELLO".downcase     # "hello"
"hello".capitalize   # "Hello"
"Hello".swapcase     # "hELLO"
```

## Options

```ruby
"STRASSE".downcase                       # "strasse"
"STRASSE".downcase(:german)              # "straße"
"hello".upcase(:ascii)                   # ASCII only
"hello".capitalize(:turkic)              # Turkic-aware
```
