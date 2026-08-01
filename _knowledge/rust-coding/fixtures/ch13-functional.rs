// source: https://doc.rust-lang.org/stable/book/ch13-01-closures.html
// module: ch13 — closures, iterators, map, filter, collect, Fn/FnMut/FnOnce
// compile: rustc --test ch13-functional.rs -o /tmp/ch13-functional && /tmp/ch13-functional

#![allow(dead_code)]

// ── Closures ──

fn main() {
    // Basic closure syntax
    let sum = |a, b| a + b;
    println!("closure add: {}", sum(3, 5));

    // Closure with block body
    let multiply = |a, b| {
        let result = a * b;
        result
    };
    println!("closure multiply: {}", multiply(4, 5));

    // Capturing environment by reference (Fn)
    let x = 10;
    let printer = || println!("x = {x}");
    printer();
    printer();  // Fn — can be called multiple times

    // Capturing by mutable reference (FnMut)
    let mut count = 0;
    let mut increment = || {
        count += 1;
        count
    };
    println!("count: {}", increment());
    println!("count: {}", increment());

    // Capturing by ownership (FnOnce)
    let text = String::from("hello");
    let consume = || {
        println!("{text}");
        drop(text);
    };
    consume();
    // consume();  // compile: FnOnce, can only be called once

    // move keyword — forces ownership into closure
    let data = vec![1, 2, 3];
    let moved = move || println!("data: {data:?}");
    moved();
    // println!("{data:?}");  // compile: data moved into closure

    // ── Iterators ──
    let numbers = vec![1, 2, 3, 4, 5];

    // iter() — immutable references
    for n in numbers.iter() {
        print!("{n} ");
    }
    println!();

    // into_iter() — owned values (consumes vector)
    let total: i32 = numbers.iter().sum();
    println!("sum: {total}");

    // Iterator adaptors (lazy)
    let squares: Vec<i32> = numbers.iter().map(|x| x * x).collect();
    println!("squares: {squares:?}");

    // Filter and collect
    let evens: Vec<&i32> = numbers.iter().filter(|x| *x % 2 == 0).collect();
    println!("evens: {evens:?}");

    // Chaining adaptors
    let result: Vec<i32> = numbers
        .iter()
        .map(|x| x * 2)
        .filter(|x| *x > 5)
        .collect();
    println!("chained: {result:?}");

    // enumerate
    for (i, val) in numbers.iter().enumerate() {
        print!("({i}:{val}) ");
    }
    println!();

    // zip
    let a = vec![1, 2, 3];
    let b = vec!["a", "b", "c"];
    let zipped: Vec<_> = a.iter().zip(b.iter()).collect();
    println!("zipped: {zipped:?}");

    // Closures with iterator adaptors
    let threshold = 3;
    let filtered: Vec<&i32> = numbers.iter().filter(|x| **x > threshold).collect();
    println!("filtered > {threshold}: {filtered:?}");
}

// ── Tests ──

#[cfg(test)]
mod unit {
    #[test]
    fn closure_add() {
        let add = |a, b| a + b;
        assert_eq!(add(2, 3), 5);
    }

    #[test]
    fn iterator_map() {
        let v = vec![1, 2, 3];
        let result: Vec<i32> = v.iter().map(|x| x * 10).collect();
        assert_eq!(result, vec![10, 20, 30]);
    }

    #[test]
    fn iterator_filter() {
        let v = vec![1, 2, 3, 4, 5];
        let evens: Vec<&i32> = v.iter().filter(|x| *x % 2 == 0).collect();
        assert_eq!(evens, vec![&2, &4]);
    }

    #[test]
    fn iterator_collect_string() {
        let v = vec!["a", "b", "c"];
        let upper: Vec<String> = v.iter().map(|s| s.to_uppercase()).collect();
        assert_eq!(upper, vec!["A", "B", "C"]);
    }

    #[test]
    fn sum_iterator() {
        let v = vec![1, 2, 3];
        let total: i32 = v.iter().sum();
        assert_eq!(total, 6);
    }
}
