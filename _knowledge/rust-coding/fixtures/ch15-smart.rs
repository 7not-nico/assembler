// source: https://doc.rust-lang.org/stable/book/ch15-01-box.html
// module: ch15 — Box<T>, Deref, Drop, Rc<T>, RefCell<T>, Rc<RefCell<T>>
// compile: rustc --test ch15-smart.rs -o /tmp/ch15-smart && /tmp/ch15-smart

use std::rc::Rc;
use std::cell::RefCell;

// ── Custom smart pointer implementing Deref and Drop ──
struct CustomBox<T>(T);

impl<T> CustomBox<T> {
    fn new(value: T) -> CustomBox<T> {
        CustomBox(value)
    }
}

impl<T> std::ops::Deref for CustomBox<T> {
    type Target = T;
    fn deref(&self) -> &T {
        &self.0
    }
}

impl<T> Drop for CustomBox<T> {
    fn drop(&mut self) {
        // drop called automatically at scope exit
    }
}

// ── Cons list using Box (recursive type needs Box) ──
#[derive(Debug)]
enum List {
    Cons(i32, Box<List>),
    Nil,
}

fn main() {
    // ── Box ──
    let b = Box::new(5);
    println!("box: {}", *b);  // dereference

    // Recursive type with Box
    let list = List::Cons(1, Box::new(List::Cons(2, Box::new(List::Nil))));
    println!("list: {list:?}");

    // ── Deref ──
    let custom = CustomBox::new(42);
    println!("custom: {}", *custom);  // deref via Deref trait

    // Deref coercion: &CustomBox<i32> -> &i32 in function call
    fn show(x: &i32) { println!("deref coerced: {x}"); }
    show(&custom);

    // ── Drop ──
    {
        let holder = CustomBox::new("will be dropped");
        println!("about to drop");
    }  // drop() called here automatically
    println!("dropped");

    // ── Rc (reference counted) ──
    let a = Rc::new(String::from("shared"));
    println!("count after a: {}", Rc::strong_count(&a));

    let b = Rc::clone(&a);  // increments count
    println!("count after b: {}", Rc::strong_count(&a));

    {
        let c = Rc::clone(&a);
        println!("count after c: {}", Rc::strong_count(&a));
    }  // c dropped, count decreases

    println!("count after c drops: {}", Rc::strong_count(&a));
    println!("b: {b}");

    // ── RefCell (interior mutability) ──
    let value = RefCell::new(5);

    // borrow_mut for mutation through immutable reference
    *value.borrow_mut() = 10;
    println!("refcell: {}", value.borrow());  // borrow returns Ref<T>

    // ── Rc<RefCell<T>> — shared mutable data ──
    let shared = Rc::new(RefCell::new(42));

    let alice = Rc::clone(&shared);
    let bob = Rc::clone(&shared);

    // Mutate through any reference
    *alice.borrow_mut() = 99;
    println!("shared: {}", shared.borrow());  // all see the change
}

// ── Tests ──

#[cfg(test)]
mod unit {
    use super::*;

    #[test]
    fn box_works() {
        let b = Box::new(5);
        assert_eq!(*b, 5);
    }

    #[test]
    fn custom_deref() {
        let c = CustomBox::new(10);
        assert_eq!(*c, 10);
    }

    #[test]
    fn rc_count() {
        let a = Rc::new(1);
        let b = Rc::clone(&a);
        let c = Rc::clone(&a);
        assert_eq!(Rc::strong_count(&a), 3);
        drop(b);
        drop(c);
        assert_eq!(Rc::strong_count(&a), 1);
    }

    #[test]
    fn refcell_mutate() {
        let cell = RefCell::new(0);
        *cell.borrow_mut() = 5;
        assert_eq!(*cell.borrow(), 5);
    }

    #[test]
    fn rc_refcell() {
        let data = Rc::new(RefCell::new(10));
        let alias = Rc::clone(&data);
        *alias.borrow_mut() = 20;
        assert_eq!(*data.borrow(), 20);
    }
}
