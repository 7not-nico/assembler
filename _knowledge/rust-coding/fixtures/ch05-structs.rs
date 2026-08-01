// source: https://doc.rust-lang.org/stable/book/ch05-01-defining-structs.html
// module: ch05 — structs, field shorthand, update syntax, tuple struct, free functions
// compile: rustc 03-structs.rs && ./03-structs -> prints all values
// dead_code suppressed: struct fields not all used in demo

#![allow(dead_code)]

// Struct defines a named collection of typed fields
// Fields accessed with dot notation: user.name
struct User { name: String, email: String, active: bool }

// Tuple struct: named tuple with unnamed fields accessed by index
struct Point(i32, i32, i32);

fn main() {
    // Instantiate struct with named field syntax
    let user = User {
        name: String::from("alice"),
        email: String::from("alice@example.com"),
        active: true,
    };
    println!("name: {}, email: {}", user.name, user.email);

    // Mutable struct allows field mutation
    let mut user2 = User {
        name: String::from("bob"),
        email: String::from("bob@example.com"),
        active: false,
    };
    user2.email = String::from("bob@new.org");
    println!("new email: {}", user2.email);

    // Field shorthand: when variable name matches field name
    // Can omit the field: value pair, just use name
    let name = String::from("carol");
    let email = String::from("carol@example.com");
    let user3 = User { name, email, active: true };
    println!("{} at {}", user3.name, user3.email);

    // Struct update syntax: .. spreads remaining fields
    // Moves heap fields from user3 (name, email) — user3 partially invalidated
    // Copy fields (bool active) remain valid in user3
    let user4 = User {
        email: String::from("dave@example.com"),
        ..user3
    };
    println!("{} at {}", user4.name, user4.email);

    // Tuple struct: access fields by index like tuples
    let origin = Point(0, 0, 0);
    println!("point: {} {} {}", origin.0, origin.1, origin.2);

    // Free function receives &Rectangle, no method call
    let rect = Rectangle { width: 30.0, height: 50.0 };
    let a = area(&rect);
    println!("area = {a}");

    // Another free function, different computation on same struct
    // No impl block — behavior separated from data per conventions
    let dist = distance(&rect);
    println!("diagonal = {dist}");
}

struct Rectangle { width: f32, height: f32 }

// Free function: takes reference to struct
// No &self — called as area(&rect) not rect.area()
fn area(rect: &Rectangle) -> f32 { rect.width * rect.height }

fn distance(rect: &Rectangle) -> f32 {
    (rect.width * rect.width + rect.height * rect.height).sqrt()
}
