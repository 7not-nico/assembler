// source: https://doc.rust-lang.org/stable/book/ch03-03-how-functions-work.html
//         https://doc.rust-lang.org/stable/book/ch03-05-control-flow.html
// module: ch03 — functions, if, loop, while, for, expressions
// compile: rustc 01-control.rs && ./01-control -> prints results

fn main() {
    // Function call with two arguments, result bound to name
    let result = sum(3, 5);
    println!("3 + 5 = {result}");

    // if is an expression — returns a value, can be assigned
    // All branches must be same type
    let condition = true;
    let number = if condition { 5 } else { 6 };
    println!("number = {number}");

    // loop runs until break, can return a value after break
    let mut count = 0;
    let value = loop {
        count += 1;
        if count == 3 {
            break count * 10;  // break expression provides loop value
        }
    };
    println!("loop value = {value}");

    // while loop with condition, decrementing
    let mut n = 3;
    while n > 0 {
        println!("{n}");
        n -= 1;
    }

    // for over range: 0..4 is exclusive (0,1,2,3)
    for i in 0..4 {
        print!("{i} ");
    }
    println!();

    // .rev() reverses the range (3,2,1)
    for i in (1..4).rev() {
        print!("{i} ");
    }
    println!();

    // for iterates over array elements directly
    let arr = [10, 20, 30];
    for element in arr {
        print!("{element} ");
    }
    println!();

    // Block expressions evaluate to last expression
    // Statement ends with ; and produces no value
    // Expression omits ; and produces a value
    let _ = { let a = 1; a + 2 };
}

// Function with two parameters, implicit return (no semicolon)
// Last expression is the return value
fn sum(x: i32, y: i32) -> i32 {
    x + y
}
