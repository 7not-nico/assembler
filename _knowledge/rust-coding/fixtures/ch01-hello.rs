// source: https://doc.rust-lang.org/stable/book/ch01-02-hello-world.html
// module: ch01 — toolchain, hello world, rustc, println!
// compile: rustc 01-hello.rs && ./01-hello -> "Hello, world!"

fn main() {
    // println! is a macro (note the !), not a function
    println!("Hello, world!");

    // {} acts as placeholder for each argument
    println!("Hello, {} and {}!", "Alice", "Bob");

    // Rust 1.58+ allows inline variable in format string
    let name = "Rust";
    println!("Hello, {name}!");

    // Indexed placeholders reuse same argument
    println!("{0} comes before {1}, and {0} again", "a", "b");
}
