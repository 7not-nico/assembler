// source: https://doc.rust-lang.org/stable/book/ch11-01-writing-tests.html
// module: ch11 — #[test], assert!, assert_eq!, should_panic, ignore
// compile: rustc --test ch11-tests.rs -o /tmp/ch11-tests && /tmp/ch11-tests

// ── Code under test ──

fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn divide(a: f64, b: f64) -> Result<f64, String> {
    if b == 0.0 {
        return Err(String::from("division by zero"));
    }
    Ok(a / b)
}

struct Rectangle {
    width: f64,
    height: f64,
}

fn area(rect: &Rectangle) -> f64 {
    rect.width * rect.height
}

fn guess(value: i32) -> &'static str {
    if value < 1 {
        "too small"
    } else if value > 100 {
        "too large"
    } else {
        "within range"
    }
}

// ── Unit tests ──

#[test]
fn add_positive() {
    let result = add(2, 3);
    assert_eq!(result, 5);
}

#[test]
fn add_negative() {
    let result = add(-2, -3);
    assert_eq!(result, -5);
}

#[test]
fn divide_success() {
    let result = divide(10.0, 2.0).unwrap();
    assert_eq!(result, 5.0);
}

#[test]
fn divide_error() {
    let result = divide(1.0, 0.0);
    assert!(result.is_err());
}

#[test]
fn area_calc() {
    let rect = Rectangle { width: 3.0, height: 4.0 };
    let result = area(&rect);
    assert_eq!(result, 12.0);
}

// Custom failure message
#[test]
fn guess_low() {
    let result = guess(0);
    assert_eq!(result, "too small", "expected 'too small' for 0");
}

#[test]
fn guess_high() {
    let result = guess(200);
    assert_eq!(result, "too large");
}

#[test]
fn guess_ok() {
    let result = guess(50);
    assert_eq!(result, "within range");
}

// Test that should panic
#[test]
#[should_panic(expected = "index out of bounds")]
fn out_of_bounds() {
    let v = vec![1, 2, 3];
    let _ = v[10];  // panics at runtime
}

// Ignored test — run with -- --ignored
#[test]
#[ignore]
fn expensive_test() {
    // would be slow
    assert_eq!(1 + 1, 2);
}

// Using assert_ne
#[test]
fn not_equal() {
    let result = add(1, 1);
    assert_ne!(result, 3);
}

// Result<T, E> in tests — no panic needed
#[test]
fn returns_result() -> Result<(), String> {
    let result = divide(8.0, 2.0)?;
    assert_eq!(result, 4.0);
    Ok(())
}
