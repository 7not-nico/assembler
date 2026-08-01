# ch8 — Common Collections

Source: https://doc.rust-lang.org/stable/book/ch08-00-common-collections.html

## Vec\<T\>

Growable array. Stores elements of same type on heap.

```
let mut v: Vec<i32> = Vec::new();
v.push(1);
let v = vec![1, 2, 3];           // macro
let x = &v[0];                    // index — panics on out of bounds
let x = v.get(0);                 // get — returns Option<&T>
```

Iterating: `for i in &v` (immutable), `for i in &mut v` (mutable).

Using enum to store multiple types: `Vec<SpreadsheetCell>`.

## String

`String` is a wrapper over `Vec<u8>`. UTF-8 encoded.

Creating: `String::from("hello")`, `"hello".to_string()`, `format!("{}-{}", a, b)`.

Appending: `push_str(&str)`, `push(char)`.

Concatenation: `let s = s1 + &s2;` (s1 moved). `format!()` for multiple strings.

Indexing: Rust strings do NOT support index access (UTF-8 variable width).
Slicing: `&s[0..4]` — panics if not on char boundary.
Iterating: `for c in s.chars()` (characters), `for b in s.bytes()` (bytes).

## HashMap\<K, V\>

Key-value store. `use std::collections::HashMap`.

```
let mut map = HashMap::new();
map.insert(String::from("key"), 42);
let v = map.get(&key);            // returns Option<&V>
for (key, value) in &map { }
```

Entry API: `map.entry(key).or_insert(value)`.

Ownership: Inserting owned values moves them into the HashMap.
