// source: https://doc.rust-lang.org/stable/book/ch04-02-references-and-borrowing.html
// module: ch04 — & and &mut references, borrowing rules
// compile: rustc 02-references.rs && ./02-references -> prints all values

fn main() {
    // Reference: borrows value without taking ownership
    // &s1 creates a reference — s1 stays valid after function
    let s1 = String::from("hello");
    let len = length(&s1);
    println!("'{s1}' length = {len}");

    // Mutable reference: exclusive write access
    // Must explicitly declare s2 as mut, then pass &mut
    let mut s2 = String::from("hello");
    suffix(&mut s2);
    println!("s2 = {s2}");

    // Multiple immutable references allowed simultaneously
    // All readers, no writers — safe for shared access
    let s3 = String::from("data");
    let r1 = &s3;
    let r2 = &s3;
    println!("{r1}, {r2}");

    // Mutable reference has exclusive access
    // Cannot have other references (mutable or immutable) active
    let mut s4 = String::from("hello");
    let r3 = &mut s4;
    r3.push_str(" world");
    println!("{r3}");
    // let r4 = &s4;  // compile: cannot borrow as immutable
    // Mutable ref r3 still in scope — no other ref allowed

    // Dangling reference prevented at compile time
    // Function would return ref to local variable that dropped
    let reference = source();
    println!("valid string = {reference}");
}

fn length(value: &String) -> usize { value.len() }
// Borrowed value not dropped when reference goes out of scope

fn suffix(value: &mut String) { value.push_str(" world"); }

// fn dangle() -> &String {
//     let value = String::from("hello");
//     &value  // compile: missing lifetime specifier
// }  // value dropped here, reference would be dangling

fn source() -> String {
    let value = String::from("hello");
    value  // ownership moves out — no dangling
}
