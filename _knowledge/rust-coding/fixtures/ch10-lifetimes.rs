// source: https://doc.rust-lang.org/stable/book/ch10-03-lifetime-syntax.html
// module: ch10 — lifetime annotations, elision, struct lifetimes, 'static
// compile: rustc ch10-lifetimes.rs && ./ch10-lifetimes -> prints all values

// Lifetime annotation: returned reference lives as long as the shorter of x and y
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}

// Struct with lifetime annotation — holds a reference
struct Excerpt<'a> {
    part: &'a str,
}

// Free function using lifetime — same convention as methods
fn prefix<'a>(text: &'a str) -> &'a str {
    // Elision rule: single input lifetime → output gets same lifetime
    match text.find(' ') {
        Some(pos) => &text[..pos],
        None => text,
    }
}

// Multiple lifetimes — 'a and 'b, return tied to 'a
fn herald<'a, 'b>(x: &'a str, y: &'b str, announcement: &str) -> &'a str
where
    'b: 'a,  // 'b outlives 'a
{
    println!("{announcement}");
    if x.len() > y.len() { x } else { y }
    // This won't compile if we tried to return y — y is 'b, not 'a
}

// Static lifetime — lives for entire program duration
fn lifetime() -> &'static str {
    let message: &'static str = "I live forever";
    message
}

fn main() {
    // ── Basic lifetime ──
    let string1 = String::from("long string");
    let result;
    {
        let string2 = String::from("xyz");
        result = longest(string1.as_str(), string2.as_str());
        println!("longest = {result}");
    }
    // result borrows from string2, which is dropped here
    // result would be invalid — but it's used inside the block, so it's fine

    // ── Struct with lifetime ──
    let text = String::from("hello world");
    let excerpt = Excerpt { part: prefix(&text) };
    println!("first word = {}", excerpt.part);

    // ── Static lifetime ──
    let forever = lifetime();
    println!("{forever}");

    // ── Lifetime in generic struct ──
    let novel = String::from("call me Ishmael. Some years ago...");
    let sentence = novel.split('.').next().expect("could not find sentence");
    let excerpt = Excerpt { part: sentence };
    println!("excerpt: {}", excerpt.part);

    // ── Elision example — no explicit lifetimes needed ──
    let word = prefix("hello world");
    println!("first_word: {word}");

    // ── Multiple lifetimes with constraint ──
    let s1 = String::from("long");
    let s2 = String::from("short");
    let announcement = String::from("comparing strings:");
    let result = herald(&s1, &s2, &announcement);
    println!("result = {result}");
}
