source: https://doc.rust-lang.org/stable/reference/keywords.html

Rust keywords three categories:
strict keywords (all editions), reserved keywords (future use), weak keywords (context-dependent).

## strict keywords

`_` wildcard pattern. binds and immediately drops value. not a variable, no name created.

`as` type cast and import rename. `expr as Type`. `use Item as Alias`.

`async` async function declaration. `async fn name() -> T`. needs executor.

`await` async suspension point. `future.await`. only in async context.

`break` loop exit. `break`. `break value` returns from loop expression.

`const` compile-time constant. `const NAME: Type = value`. type annotation required.

`continue` skip to next loop iteration.

`crate` crate root reference. `crate::module::Item`.

`dyn` dynamic dispatch trait object. `dyn Trait`. vtable at runtime.

`else` conditional alternative. `if {} else {}`.

`enum` enum type. `enum Name { V1, V2 }`.

`extern` external linkage. `extern "C"` for FFI.

`false` boolean literal false.

`fn` function and function pointer. `fn name(p: Type) -> R`. `fn(T) -> R`.

`for` loop and impl. `for x in iter`. `impl Trait for Type`.

`if` conditional expression. returns value from branches.

`impl` implementation block. `impl Type`. `impl Trait for Type`.

`in` iteration grammar. part of `for x in iter`.

`let` variable binding. `let`. `let mut`. `let name: Type`.

`loop` infinite loop. `loop { break value }`.

`match` pattern matching. exhaustive, returns value.

`mod` module declaration. `mod name;` or `mod name { }`.

`move` closure ownership. `move || { }`. forces capture by value.

`mut` mutability marker. `let mut x`. `&mut T`.

`pub` visibility. `pub fn`. `pub(crate)`. private by default.

`ref` binding by reference in patterns. `let ref x = value`.

`return` early function exit. `return value`. last expression preferred.

`self` method receiver and module path. `fn method(&self)`. `self::item`.

`Self` impl type alias. `fn new() -> Self`.

`static` static variable. `static NAME: Type = value`. fixed address, `'static` lifetime.

`struct` struct type. `struct Name { f: Type }`. tuple and unit variants.

`super` parent module. `super::fn_name`.

`trait` shared behavior interface. `trait Name { fn method(&self); }`.

`true` boolean literal true.

`type` type alias. `type Name = ExistingType`. not a new type.

`unsafe` unsafe operations. `unsafe fn`. `unsafe { }`. raw pointers, FFI.

`use` import path. `use crate::mod::Item`. `use Item as Alias`.

`where` trait bounds after signature. `fn name<T>(t: T) where T: Trait`.

`while` conditional loop. `while condition { }`.

## reserved keywords (future use)

`abstract` `become` `box` `do` `final` `gen` `macro`

`override` `priv` `try` `typeof` `unsized` `virtual` `yield`

## weak keywords (context-dependent)

`'static` static lifetime. lives for entire program duration. string literals are `'static`.

`macro_rules` declarative macro definition. `macro_rules! name { pattern => expansion }`.

`raw` raw borrow operator. `&raw const expr`. `&raw mut expr`.

`safe` safe functions in external blocks. marks FFI functions as safe to call.

`union` C-compatible union. `union Name { field: Type }`. keyword only in union declaration context.
