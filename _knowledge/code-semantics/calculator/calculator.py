"""Calculator — infix arithmetic, subject → object → action convention.

The code follows the programming convention:
  subject → object → action → subject

Every operation in the evaluate loop reads as:
  1. subject  — the current accumulator
  2. object   — the next operand from the token stream
  3. action   — the operator applied to subject and object
  result becomes the new subject

Usage:
  uv run calculator.py "2 + 3"
  uv run calculator.py "2 + 3 * 4"
  uv run calculator.py (interactive REPL)
"""

from __future__ import annotations

import sys
import operator
import re
from typing import NoReturn

# action table — maps operator symbol to function
OP: dict[str, object] = {
    "+":  operator.add,
    "-":  operator.sub,
    "*":  operator.mul,
    "/":  operator.truediv,
    "**": operator.pow,
}

PATTERNS: list[tuple[str, str]] = [
    ("NUM", r"\d+(\.\d+)?"),
    ("OP",  r"\*\*|[+\-*/]"),
    ("SKIP", r"\s+"),
]

SCANNER = re.compile("|".join(f"(?P<{t}>{p})" for t, p in PATTERNS))

Token = tuple[str, str]


def scan(source: str) -> list[Token]:
    result: list[Token] = []
    for m in SCANNER.finditer(source):
        if m.lastgroup == "SKIP":
            continue
        result.append((m.lastgroup, m.group()))
    return result


def evaluate(source: str) -> float:
    """subject → object → action → subject  cycle."""
    toks = scan(source)
    if not toks:
        raise ValueError("empty expression")

    cursor = 0

    # ── subject: first number as accumulator ───────────────
    if toks[cursor][0] != "NUM":
        raise ValueError(f"expected number, got {toks[cursor][1]}")
    subject = float(toks[cursor][1])
    cursor += 1

    # ── cycle: object → action → subject ──────────────────
    while cursor < len(toks):
        # ── object: operator symbol + number ───────────────
        if toks[cursor][0] != "OP":
            raise ValueError(f"expected operator, got {toks[cursor][1]}")
        op_sym = toks[cursor][1]
        cursor += 1

        if cursor >= len(toks) or toks[cursor][0] != "NUM":
            raise ValueError(f"expected number after operator")
        object_val = float(toks[cursor][1])
        cursor += 1

        # ── action: apply operator to subject and object ──
        fn = OP.get(op_sym)
        if fn is None:
            raise ValueError(f"unknown operator: {op_sym}")

        if fn is operator.truediv and object_val == 0.0:
            raise ZeroDivisionError("division by zero")

        # ── subject: result becomes new accumulator ────────
        subject = float(fn(subject, object_val))

    return subject


def show(val: float) -> str:
    s = f"{val}"
    return s[:-2] if s.endswith(".0") else s


def repl() -> NoReturn:
    import atexit
    entries: list[str] = []
    def cleanup() -> None:
        if entries:
            print()
    atexit.register(cleanup)

    print("  calculator — subject → object → action convention")
    print("  operators: +  -  *  /  **")
    print("  example:  2 + 3 * 4")
    print("  exit / Ctrl-D to quit\n")

    while True:
        try:
            line = input("  > ").strip()
        except EOFError:
            print()
            sys.exit(0)
        if not line:
            continue
        if line in ("exit", "quit", "q"):
            break
        entries.append(line)
        try:
            val = evaluate(line)
            print(f"  = {show(val)}")
        except (ValueError, ZeroDivisionError, KeyError) as err:
            print(f"  ✗ {err}")
    sys.exit(0)


def main() -> None:
    args = sys.argv[1:]
    if not args:
        repl()
    line = " ".join(args)
    try:
        val = evaluate(line)
        print(show(val))
    except (ValueError, ZeroDivisionError, KeyError) as err:
        print(f"error: {err}")
        sys.exit(1)


if __name__ == "__main__":
    main()
