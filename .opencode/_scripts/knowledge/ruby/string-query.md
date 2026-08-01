# Ruby String Querying

## Counts

| Method | Returns |
|--------|---------|
| `length` / `size` | character count (not bytes) |
| `bytesize` | byte count |
| `empty?` | true if zero length |
| `count` | count of substring matches |

## Substring checks

| Method | Returns |
|--------|---------|
| `include?("sub")` | true/false |
| `start_with?("pre")` | true/false |
| `end_with?("suf")` | true/false |
| `index("sub")` | first index or nil |
| `rindex("sub")` | last index or nil |
| `=~ /regex/` | first match index or nil |
| `match?(/regex/)` | true/false (no MatchData allocated) |
| `match(/regex/)` | MatchData or nil |

## Encoding

| Method | Returns |
|--------|---------|
| `encoding` | Encoding object |
| `valid_encoding?` | true/false |
| `ascii_only?` | true/false |
| `unicode_normalized?` | true/false |

## Comparison

| Method | Returns |
|--------|---------|
| `==` / `===` | true if same content |
| `eql?` | true if same content + type |
| `<=>` | -1, 0, 1 (spaceship) |
| `casecmp` | -1, 0, 1 ignoring case |
| `casecmp?` | true/false ignoring case |
