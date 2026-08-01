// source: https://doc.rust-lang.org/stable/book/ch04-01-what-is-ownership.html
// module: ch04 — move, clone, copy, function ownership, tuple return
// compile: rustc 02-ownership.rs && ./02-ownership -> prints all values

fn main() {
    // Move: assignment transfers ownership, s1 invalidated
    let s1 = String::from("hello");
    let s2 = s1;
    // println!("{s1}");  // compile: value borrowed after move
    println!("s2 = {s2}");

    // Clone: explicit deep copy, both remain valid
    let s3 = String::from("world");
    let s4 = s3.clone();
    println!("s3 = {s3}, s4 = {s4}");

    // Copy: types implementing Copy trait are trivially copied
    // i32 is Copy — x stays valid after assignment to y
    let x = 5;
    let y = x;
    println!("x = {x}, y = {y}");

    // Scope determines lifetime: inner String dropped at }
    {
        let inner = String::from("temporary");
        println!("inner = {inner}");
    }
    // println!("{inner}");  // compile: not found in scope

    // Passing to function moves ownership (unless Copy)
    let s5 = String::from("hello");
    taker(s5);
    // println!("{s5}");  // compile: value borrowed after move

    // i32 is Copy, so n stays valid after function call
    let n = 42;
    echo(n);
    println!("n still valid: {n}");

    // Function returns ownership back
    let s6 = gift();
    println!("s6 = {s6}");

    // s7 moved into function, ownership returned as s8
    let s7 = String::from("loop");
    let s8 = relay(s7);
    println!("s8 = {s8}");

    // Tuple returns both String and computed value
    // Avoids losing ownership by bundling with return
    let s9 = String::from("length");
    let (s10, len) = length(s9);
    println!("'{s10}' length = {len}");
}

fn taker(value: String) { println!("took: {value}"); }
// value dropped here — drop called, memory freed

fn echo(value: i32) { println!("copied: {value}"); }
// value is Copy, nothing special at scope end

fn gift() -> String { let result = String::from("yours"); result }
// result ownership moves to caller, not dropped here

fn relay(value: String) -> String { value }
// value ownership moves to caller

fn length(value: String) -> (String, usize) {
    let len = value.len();
    (value, len)
}
