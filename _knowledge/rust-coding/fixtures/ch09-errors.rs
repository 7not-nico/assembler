// source: https://doc.rust-lang.org/stable/book/ch09-02-recoverable-errors-with-result.html
// module: ch09 — Result<T,E>, ? operator, unwrap, expect, panic!, chaining
// compile: rustc ch09-errors.rs && ./ch09-errors -> prints all values

#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeRoot,
}

fn main() {
    // ── Result with match ──
    let result = divide(10.0, 2.0);
    match result {
        Ok(value) => println!("division = {value}"),
        Err(e) => println!("error: {e:?}"),
    }

    let result = divide(10.0, 0.0);
    match result {
        Ok(value) => println!("division = {value}"),
        Err(e) => println!("error: {e:?}"),
    }

    // ── unwrap — panics on Err ──
    // let val = divide(1.0, 0.0).unwrap();  // panics

    // ── expect — custom panic message ──
    let val = divide(8.0, 4.0).expect("math failed");
    println!("expect result = {val}");

    // ── ? operator — propagates error to caller ──
    // Only works in functions that return Result or Option
    match sqrt(9.0) {
        Ok(v) => println!("sqrt(9) = {v}"),
        Err(e) => println!("sqrt error: {e:?}"),
    }

    match sqrt(-4.0) {
        Ok(v) => println!("sqrt(-4) = {v}"),
        Err(e) => println!("sqrt error: {e:?}"),
    }

    // ── Chaining with ? ──
    match calculator(16.0, 4.0) {
        Ok(v) => println!("compute = {v}"),
        Err(e) => println!("compute error: {e:?}"),
    }

    match calculator(1.0, 0.0) {
        Ok(v) => println!("compute = {v}"),
        Err(e) => println!("compute error: {e:?}"),
    }

    // ── panic! example ──
    // panic!("this is unrecoverable");  // uncomment to see panic

    // ── Option with ? ──
    let a = Some(10);
    let b = None;
    println!("double some = {:?}", double(a));
    println!("double none = {:?}", double(b));
}

fn divide(numerator: f64, denominator: f64) -> Result<f64, MathError> {
    if denominator == 0.0 {
        return Err(MathError::DivisionByZero);
    }
    Ok(numerator / denominator)
}

fn sqrt(value: f64) -> Result<f64, MathError> {
    if value < 0.0 {
        return Err(MathError::NegativeRoot);
    }
    Ok(value.sqrt())
}

fn calculator(value: f64, denominator: f64) -> Result<f64, MathError> {
    // ? propagates error immediately if Err
    let quotient = divide(value, denominator)?;
    let root = sqrt(quotient)?;
    Ok(root)
}

fn double(value: Option<i32>) -> Option<i32> {
    // ? on Option returns None immediately if None
    let v = value?;
    Some(v * 2)
}
