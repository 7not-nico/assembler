"""Calculator — subject.action(object) syntax.

Every expression is a chain of method-style calls:
  subject.action(object)

Examples:
  5.add(3)              →  8
  10.subtract(4)         →  6
  3.multiply(4)          →  12
  20.divide(5)           →  4
  2.power(3)             →  8
  5.add(3).multiply(4)   →  32

Usage:
  uv run subject_action.py 5.add(3)
  uv run subject_action.py 5.add(3).multiply(4)
  uv run subject_action.py (interactive REPL)
"""

from __future__ import annotations

import sys
import operator
import re
from typing import NoReturn

ACTIONS: dict[str, object] = {
    "add":      operator.add,
    "subtract": operator.sub,
    "multiply": operator.mul,
    "divide":   operator.truediv,
    "power":    operator.pow,
}

PATTERNS: list[tuple[str, str]] = [
    ("NUM",    r"\d+(\.\d+)?"),
    ("ACTION", r"add|subtract|multiply|divide|power"),
    ("DOT",    r"\."),
    ("LPAR",   r"\("),
    ("RPAR",   r"\)"),
    ("SKIP",   r"\s+"),
]

SCANNER = re.compile("|".join(f"(?P<{t}>{p})" for t, p in PATTERNS))

Token = tuple[str, str]


def scan(source: str) -> list[Token]:
    result: list[Token] = []
    for m in SCANNER.finditer(source):
        typ = m.lastgroup
        val = m.group()
        if typ == "SKIP":
            continue
        result.append((typ, val))
    return result


def evaluate(source: str) -> float:
    toks = scan(source)
    if not toks:
        raise ValueError("empty expression")

    cursor = 0

    # subject: first number
    if toks[cursor][0] != "NUM":
        raise ValueError(f"expected number, got {toks[cursor][1]}")
    subject = float(toks[cursor][1])
    cursor += 1

    # cycle: .action(object) → new subject
    while cursor < len(toks):
        # .
        if cursor >= len(toks) or toks[cursor][0] != "DOT":
            raise ValueError(f"expected '.', got {toks[cursor][1] if cursor < len(toks) else 'end'}")
        cursor += 1

        # action
        if cursor >= len(toks) or toks[cursor][0] != "ACTION":
            raise ValueError(
                f"expected action verb, got "
                f"{toks[cursor][1] if cursor < len(toks) else 'end'}"
            )
        verb = toks[cursor][1]
        cursor += 1

        # (
        if cursor >= len(toks) or toks[cursor][0] != "LPAR":
            raise ValueError(
                f"expected '(', got "
                f"{toks[cursor][1] if cursor < len(toks) else 'end'}"
            )
        cursor += 1

        # object: number inside parens
        if cursor >= len(toks) or toks[cursor][0] != "NUM":
            raise ValueError(
                f"expected number, got "
                f"{toks[cursor][1] if cursor < len(toks) else 'end'}"
            )
        object = float(toks[cursor][1])
        cursor += 1

        # )
        if cursor >= len(toks) or toks[cursor][0] != "RPAR":
            raise ValueError(
                f"expected ')', got "
                f"{toks[cursor][1] if cursor < len(toks) else 'end'}"
            )
        cursor += 1

        # action: verb(subject, object) → new subject
        fn = ACTIONS.get(verb)
        if fn is None:
            raise ValueError(f"unknown action: {verb}")
        if fn is operator.truediv and object == 0.0:
            raise ZeroDivisionError("division by zero")
        subject = float(fn(subject, object))

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

    print("  subject.action(object)  calculator")
    print("  syntax:  subject.action(object)")
    print("  example:  5.add(3)")
    print("  chain:   5.add(3).multiply(4)")
    print("  actions: add | subtract | multiply | divide | power")
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
    line = "".join(args)
    try:
        val = evaluate(line)
        print(show(val))
    except (ValueError, ZeroDivisionError, KeyError) as err:
        print(f"error: {err}")
        sys.exit(1)


if __name__ == "__main__":
    main()
