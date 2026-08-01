// source: https://doc.rust-lang.org/stable/book/ch08-01-vectors.html
// module: ch08 — Vec<T>, String, HashMap<K,V>, iteration, ownership
// compile: rustc ch08-collections.rs && ./ch08-collections -> prints all values
#![allow(dead_code)]

fn main() {
    // ── Vec<T>: growable array ──
    let mut v: Vec<i32> = Vec::new();
    v.push(1);
    v.push(2);
    v.push(3);

    // Index access — panics if out of bounds
    let third = &v[2];
    println!("third element = {third}");

    // Get access — returns Option, safe for bounds checking
    match v.get(10) {
        Some(value) => println!("got {value}"),
        None => println!("no element at index 10"),
    }

    // vec! macro for concise initialization
    let numbers = vec![10, 20, 30];

    // Immutable iteration over references
    for n in &numbers {
        print!("{n} ");
    }
    println!();

    // Mutable iteration — dereference to modify
    let mut squares = vec![1, 2, 3];
    for n in &mut squares {
        *n *= *n;
    }
    println!("squares: {squares:?}");

    // Enum to store multiple types in one Vec
    #[derive(Debug)]
    enum Cell {
        Int(i32),
        Text(String),
        Float(f64),
    }
    let row = vec![
        Cell::Int(42),
        Cell::Text(String::from("hello")),
        Cell::Float(3.14),
    ];
    println!("row: {row:?}");

    // ── String: UTF-8 text ──
    let mut s = String::new();
    s.push_str("hello");
    s.push(' ');
    s.push_str("world");
    println!("{s}");

    // Creating strings
    let from = String::from("from literal");
    let to = "to_string".to_string();
    let both = format!("{from} + {to}");
    println!("{both}");

    // Concatenation — moves s1
    let s1 = String::from("hello ");
    let s2 = String::from("world");
    let s3 = s1 + &s2;  // s1 moved, &s2 coerces to &str
    println!("{s3}");
    // println!("{s1}");  // compile: s1 moved

    // Character iteration
    let unicode = String::from("Привет");
    for c in unicode.chars() {
        print!("{c} ");
    }
    println!();

    // ── HashMap<K,V>: key-value store ──
    use std::collections::HashMap;

    let mut scores = HashMap::new();
    scores.insert(String::from("blue"), 10);
    scores.insert(String::from("red"), 20);

    // Get returns Option
    let team = String::from("blue");
    let score = scores.get(&team);
    match score {
        Some(v) => println!("blue score = {v}"),
        None => println!("blue not found"),
    }

    // Iteration
    for (key, value) in &scores {
        println!("{key}: {value}");
    }

    // Entry API: insert if key missing
    let mut map = HashMap::new();
    map.insert(String::from("a"), 1);

    map.entry(String::from("a")).or_insert(99);   // key exists, no change
    map.entry(String::from("b")).or_insert(42);   // key missing, inserted

    println!("entry: {map:?}");

    // Update based on old value
    let text = "hello world hello";
    let mut count = HashMap::new();
    for word in text.split_whitespace() {
        let entry = count.entry(word).or_insert(0);
        *entry += 1;
    }
    println!("word count: {count:?}");
}
