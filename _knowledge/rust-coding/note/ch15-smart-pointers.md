# ch15 — Smart Pointers

Source: https://doc.rust-lang.org/stable/book/ch15-00-smart-pointers.html

## Box\<T\> (15.1)

Heap allocation. `Box::new(value)`. For recursive types (cons list), trait objects (`Box<dyn Trait>`), large data moves. Moves value to heap, pointer on stack.

## Deref trait (15.2)

`fn deref(&self) -> &T`. Enables `*` operator. Deref coercion: `&Box<T>` auto-converts to `&T` in function arguments.

## Drop trait (15.3)

`fn drop(&mut self)`. Cleanup on scope exit. Called automatically. `std::mem::drop` for early explicit drop.

## Rc\<T\> (15.4)

Reference-counted, multiple ownership. `Rc::clone()` increments count (cheap, not deep clone). Single-threaded. `Rc::strong_count()` for diagnostics.

## RefCell\<T\> (15.5)

Interior mutability. Runtime borrow checking. `borrow()` → `Ref<T>`, `borrow_mut()` → `RefMut<T>`. Panics if two mutable borrows active. Single-threaded.

**Rc\<RefCell\<T\>\>** pattern — multiple owners with mutation.

## Reference cycles (15.6)

Rc + RefCell can create cycles causing memory leaks. `Weak<T>` via `Rc::downgrade()` — non-owning reference. `upgrade()` returns `Option<Rc<T>>`.
