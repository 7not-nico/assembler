The compiler inlines method calls. At call sites where the callee is small or the call overhead matters, the compiler replaces the call with the callee's body, so hot paths execute the callee's body directly.

Scope: compiler-level.

Composes with `RUL.CODE.PRECEPT` — one of 17 code precepts.
