// source: https://doc.rust-lang.org/stable/book/ch10-01-syntax.html
// module: ch10 — generic functions, generic structs, monomorphization
// compile: rustc ch10-generics.rs && ./ch10-generics -> prints all values

// Generic function: finds largest element in any comparable slice
// PartialOrd trait bound required for comparison
fn largest<T: std::cmp::PartialOrd>(list: &[T]) -> &T {
    let mut largest = &list[0];
    for item in list {
        if item > largest {
            largest = item;
        }
    }
    largest
}

// Generic struct with single type parameter
struct Point<T> {
    x: T,
    y: T,
}

// Generic struct with two type parameters
struct Pair<T, U> {
    first: T,
    second: U,
}

fn main() {
    // Generic function works with any comparable type
    let numbers = vec![34, 50, 25, 100, 65];
    let result = largest(&numbers);
    println!("largest number = {result}");

    let chars = vec!['y', 'm', 'a', 'q'];
    let result = largest(&chars);
    println!("largest char = {result}");

    // Generic struct with same type T
    let integer = Point { x: 5, y: 10 };
    let float = Point { x: 1.0, y: 4.0 };
    println!("Point<int>: ({}, {})", integer.x, integer.y);
    println!("Point<float>: ({}, {})", float.x, float.y);

    // Generic struct with two different types
    let mixed = Pair { first: 42, second: 3.14 };
    println!("Pair: ({}, {})", mixed.first, mixed.second);

    // Enum generics — Option and Result are generic
    let some: Option<i32> = Some(42);
    let none: Option<&str> = None;
    println!("some: {:?}, none: {:?}", some, none);

    // Free function on generic struct (no methods per conventions)
    let p = Point { x: 3.0, y: 4.0 };
    let dist = distance(&p);
    println!("distance from origin = {dist}");
}

// Free function operating on generic struct
// Works for any Point where T supports multiplication and sqrt
fn distance<T>(point: &Point<T>) -> f64
where
    T: std::ops::Mul<Output = T> + std::ops::Add<Output = T> + Copy + Into<f64>,
{
    let sum: f64 = point.x.into() * point.x.into() + point.y.into() * point.y.into();
    sum.sqrt()
}
