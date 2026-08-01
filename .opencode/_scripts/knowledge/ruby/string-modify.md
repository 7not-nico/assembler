# Ruby String Modification

These methods mutate `self`.

## Insertion

| Method | Example |
|--------|---------|
| `insert(offset, str)` | `"hello".insert(3, "xy")` → `"helxylo"` |
| `<<` / `concat` | `"hello" << " world"` → `"hello world"` |
| `append_as_bytes(str)` | appends without encoding checks |

## Deletion

| Method | Example |
|--------|---------|
| `clear` | `"hello".clear` → `""` |
| `delete(str)` | `"hello".delete("l")` → `"heo"` |
| `delete!` | bang version |
| `tr!(from, to)` | `"hello".tr!("l", "x")` → `"hexxo"` |
| `tr_s!(from, to)` | `"hello".tr_s!("l", "x")` → `"hexo"` (no dupes) |

## Replacement

| Method | Example |
|--------|---------|
| `replace(str)` | `"hello".replace("bye")` → `"bye"` |
| `reverse!` | `"hello".reverse!` → `"olleh"` |
| `succ!` / `next!` | `"a".succ!` → `"b"` |
| `setbyte(idx, val)` | byte-level mutation |
