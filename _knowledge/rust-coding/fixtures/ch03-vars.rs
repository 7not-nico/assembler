// source: https://doc.rust-lang.org/stable/book/ch03-01-variables-and-mutability.html
// module: ch03 — variables, mutability, types, shadowing, constants
// compile: rustc 01-vars.rs && ./01-vars -> prints all values

fn main() {
    // Variables immutable by default — cannot reassign
    let x = 5;
    println!("x = {x}");

    // mut keyword makes variable mutable
    let mut y = 10;
    println!("y = {y}");
    y = 20;
    println!("y = {y}");

    // const: always immutable, type required, PascalCase per conventions
    // Rust lint expects SCREAMING_SNAKE_CASE, suppressed with allow
    #[allow(non_upper_case_globals)]
    const MaxPoints: u32 = 100_000;
    println!("max = {MaxPoints}");

    // Shadowing — new let declares new variable, old one hidden
    // Different type permitted (string -> usize)
    let z = "hello";
    let z = z.len();
    println!("z = {z}");

    // Scalar types: integers have signed/unsigned variants
    let signed: i8 = -128;    // i8 ranges -128 to 127
    let unsigned: u8 = 255;   // u8 ranges 0 to 255
    let float: f64 = 3.14159; // f64 double precision
    let yes: bool = true;     // bool with true/false
    let crab: char = '🦀';     // char is 4 bytes, Unicode scalar value
    println!("{signed} {unsigned} {float} {yes} {crab}");

    // Tuple: fixed-size collection of mixed types
    // Destructure with let () or access with .index
    let tup: (i32, f64, u8) = (500, 6.4, 1);
    let (a, b, c) = tup;          // destructuring
    println!("tuple: {a} {b} {c}  index 0: {}", tup.0);

    // Array: fixed-length, stack-allocated, same type
    // Index with [n], bounds checked at runtime
    let arr: [i32; 5] = [1, 2, 3, 4, 5];
    println!("first = {}, len = {}", arr[0], arr.len());

    // Numeric literals with prefixes
    let _ = 0b1010;     // binary
    let _ = 0xFF;       // hex
    let byte = b'A';    // byte literal (u8), value 65
    let _ = 3.14_f32;   // type suffix for float
    println!("byte A = {byte}");

    // _ binds and immediately drops — suppresses unused warning
    // No _name prefix allowed per conventions
}
