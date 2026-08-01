# Ruby Regexp — Character Classes

## Predefined classes

| Class | Meaning | Negation |
|-------|---------|----------|
| `\d` | digit `[0-9]` | `\D` — non-digit |
| `\w` | word char `[a-zA-Z0-9_]` | `\W` — non-word |
| `\s` | whitespace `[ \t\r\n\f]` | `\S` — non-whitespace |
| `\h` | hex digit `[0-9a-fA-F]` | `\H` — non-hex |

```ruby
/^\d+$/.match("123")                 # #<MatchData "123">
/^\s+/.match("  hello")              # leading whitespace
```

## Dot `.` — any char except newline

With `/m` flag, dot matches newline too.

## Custom classes `[...]`

```ruby
/[aeiou]/.match("hello")             # "e"
/[a-z]/.match("hello")               # "h"
/[aeiou\-]/                          # vowel or literal hyphen
/[^aeiou]/                           # negated — non-vowel
/[a-z&&[^aeiou]]/                    # intersection — consonants only
```

## POSIX classes (inside `[[:...:]]`)

| Class | Meaning |
|-------|---------|
| `[[:alnum:]]` | alpha + digit |
| `[[:alpha:]]` | letter |
| `[[:blank:]]` | space/tab |
| `[[:cntrl:]]` | control chars |
| `[[:digit:]]` | digit |
| `[[:graph:]]` | visible chars |
| `[[:lower:]]` | lowercase |
| `[[:print:]]` | visible + space |
| `[[:punct:]]` | punctuation |
| `[[:space:]]` | any whitespace |
| `[[:upper:]]` | uppercase |
| `[[:xdigit:]]` | hex digit |

```ruby
/[[:alpha:]]+/.match("hello123")     # "hello"
```

## Unicode properties (Ruby 2.0+)

```ruby
/\p{L}/                              # any letter
/\p{Lu}/                             # uppercase letter
/\p{Nd}/                             # decimal digit
/\P{L}/                              # non-letter
```

Available categories: `L` (letter), `N` (number), `P` (punct), `S` (symbol), `Z` (separator), `C` (other)
