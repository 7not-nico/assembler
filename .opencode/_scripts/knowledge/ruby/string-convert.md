# Ruby String Conversion

## To other types

```ruby
"42".to_i          # 42
"3.14".to_f        # 3.14
"hello".to_sym     # :hello
"FF".hex           # 255
"77".oct           # 63
"1010".to_i(2)     # 10 (binary)
"hello".to_c       # (0+0i) — complex
"1+2i".to_c        # (1+2i)
"1/2".to_r         # (1/2) — rational
```

## Formatting

```ruby
42.to_s            # "42"
42.to_s(:binary)   # "101010"
42.to_s(:hex)      # "2a"
42.to_s(:octal)    # "52"
42.to_s(:human)    # "42.0"

# sprintf / format
format("%.2f", 3.14159)   # "3.14"
"%.2f" % 3.14159          # "3.14"
```

## Array/string

```ruby
"a b c".split           # ["a", "b", "c"]
"a,b,c".split(",")      # ["a", "b", "c"]
"hello".chars           # ["h", "e", "l", "l", "o"]
"hello".bytes           # [104, 101, 108, 108, 111]
"hello".codepoints      # [104, 101, 108, 108, 111]
"hello".lines           # ["hello"]
"hello".each_char { |c| puts c }  # iterator
```
