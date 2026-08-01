// source: https://doc.rust-lang.org/stable/book/ch04-03-slices.html
// module: ch04 — string slices &str, array slices, prefix, head
// compile: rustc 02-slices.rs && ./02-slices -> prints all values

fn main() {
    // Slice: reference to contiguous segment of data
    // Range syntax [start..end] — start inclusive, end exclusive
    let s = String::from("hello world");
    let hello = &s[0..5];
    let world = &s[6..11];
    println!("{hello} {world}");

    // Shorthand: omit start (0) or end (len) or both
    let hello = &s[..5];     // from byte 0
    let world = &s[6..];     // to last byte
    let whole = &s[..];      // entire string
    println!("{hello} {world} {whole}");

    // Function returning &str borrows from the String
    // No ownership transfer — caller retains String
    let word = prefix(&s);
    println!("first word = {word}");

    // String literal type is &str — already a slice
    // More flexible: takes &str instead of &String
    let literal: &str = "hello world";
    let word = head(literal);
    println!("first word = {word}");

    // Array slices work same way: &[T] type
    let arr = [1, 2, 3, 4, 5];
    let slice = &arr[1..3];
    println!("array slice: {slice:?}");  // :? for debug formatting
}

fn prefix(value: &String) -> &str {
    // Convert string to bytes for character-by-character check
    let byte = value.as_bytes();
    // enumerate yields (index, &item) tuples
    for (i, &item) in byte.iter().enumerate() {
        if item == b' ' {            // b' ' is byte literal for space
            return &value[0..i];     // return slice up to space
        }
    }
    &value[..]  // no space found, return entire string
}

// Better: accept &str instead of &String
// Accepts both &String (auto-coerced) and &str directly
fn head(value: &str) -> &str {
    let byte = value.as_bytes();
    for (i, &item) in byte.iter().enumerate() {
        if item == b' ' { return &value[0..i]; }
    }
    &value[..]
}
