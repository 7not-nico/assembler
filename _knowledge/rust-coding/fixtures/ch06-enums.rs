// source: https://doc.rust-lang.org/stable/book/ch06-01-defining-an-enum.html
// module: ch06 — enums, Option<T>, match, if let, catch-all
// compile: rustc 03-enums.rs && ./03-enums -> prints all values
// dead_code suppressed: some enum variants not used

#![allow(dead_code)]

// Enum variants can carry different kinds of data
// Each variant is a different shape — no common structure required
enum Shape {
    Circle(f64),                      // single unnamed value
    Rectangle { width: f64, height: f64 },  // named fields
    Triangle(f64, f64),               // multiple unnamed values
}

// C-style enum: variants are just values, no attached data
enum Direction { North, South, East, West }

fn main() {
    // Create enums with variant constructors
    let circle = Shape::Circle(5.0);
    let rectangle = Shape::Rectangle { width: 3.0, height: 4.0 };
    let triangle = Shape::Triangle(3.0, 4.0);

    // match is exhaustive — every variant must be handled
    // Passing reference to avoid ownership move
    for shape in [circle, rectangle, triangle] {
        println!("{}", describe(&shape));
    }

    // Enum with no data matched by value identity
    let dir = Direction::North;
    println!("north code = {}", bearing(&dir));

    // Option<T>: Rust's null-safe optional value
    // Some(42) — value present, None — no value
    let some = Some(42);
    let none: Option<i32> = None;
    println!("some: {}", message(&some));
    println!("none: {}", message(&none));

    // if let: match a single pattern without exhaustive match
    // Shorthand when only one variant matters
    let value = Some(99);
    if let Some(v) = value { println!("if let got: {v}"); }

    // if let with else: handles the unmatched case
    let value: Option<i32> = None;
    if let Some(v) = value {
        println!("got {v}");
    } else {
        println!("got nothing");
    }

    // match with ranges, OR patterns, and catch-all _
    // | for OR, ..= for inclusive range, _ for everything else
    let n = 7;
    let label = match n {
        1 => "one",
        2 | 3 => "two or three",
        4..=6 => "four through six",
        _ => "other",    // catch-all, must come last
    };
    println!("{n} is {label}");
}

// destructure enum variants in match arms
// radius extracted from Circle, width/height from Rectangle
fn describe(shape: &Shape) -> String {
    match shape {
        Shape::Circle(radius) => format!("circle r={radius}"),
        Shape::Rectangle { width, height } => format!("rect {width}x{height}"),
        Shape::Triangle(a, b) => format!("triangle {a}x{b}"),
    }
}

fn bearing(dir: &Direction) -> u8 {
    match dir {
        Direction::North => 0,
        Direction::South => 1,
        Direction::East  => 2,
        Direction::West  => 3,
    }
}

fn message(opt: &Option<i32>) -> String {
    match opt {
        Some(v) => format!("value = {v}"),
        None => String::from("no value"),
    }
}
