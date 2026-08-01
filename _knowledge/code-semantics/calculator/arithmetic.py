"""Arithmetic — subject → object → action programming convention.

Every operation follows the same three-step cycle:
  subject   = the current value (accumulator)
  object    = the operand (what the action applies to)
  action    = the transformation (verb: add, subtract, multiply, divide, power)

The action produces a new subject. The cycle repeats.

Usage:
  uv run arithmetic.py 5 add 3
  uv run arithmetic.py 2 add 3 multiply 4
  uv run arithmetic.py (interactive)
"""

from __future__ import annotations

import sys
import operator
import re
from typing import NoReturn, Optional

ACTIONS: dict[str, object] = {
    "add":      operator.add,
    "subtract": operator.sub,
    "multiply": operator.mul,
    "divide":   operator.truediv,
    "power":    operator.pow,
}

SCAN = re.compile(
    r"(?P<NUM>\d+(\.\d+)?)"
    r"|(?P<VERB>add|subtract|multiply|divide|power)"
    r"|(?P<SKIP>\s+)"
)

Token = tuple[str, str]


def scan(source: str) -> list[Token]:
    result: list[Token] = []
    for m in SCAN.finditer(source):
        if m.lastgroup == "SKIP":
            continue
        result.append((m.lastgroup, m.group()))
    return result


def act(verb: str, subject: float, object: float) -> float:
    """subject → action → object → new subject."""
    fn = ACTIONS[verb]
    if fn is operator.truediv and object == 0.0:
        raise ZeroDivisionError("division by zero")
    return float(fn(subject, object))


def evaluate(source: str) -> float:
    """Cycle: subject → object → action → subject → object → action → ..."""
    toks = scan(source)
    if not toks:
        raise ValueError("empty expression")

    if toks[0][0] != "NUM":
        raise ValueError(f"expected number, got {toks[0][1]}")

    subject = float(toks[0][1])
    cursor = 1

    while cursor < len(toks):
        if cursor + 2 > len(toks):
            raise ValueError(f"incomplete expression at token {cursor}")

        if toks[cursor][0] != "VERB":
            raise ValueError(f"expected action, got {toks[cursor][1]}")
        verb = toks[cursor][1]
        cursor += 1

        if toks[cursor][0] != "NUM":
            raise ValueError(f"expected number, got {toks[cursor][1]}")
        object = float(toks[cursor][1])
        cursor += 1

        subject = act(verb, subject, object)

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

    print("  arithmetic — subject → object → action convention")
    print("  format:  subject action object  action object  ...")
    print("  example:  5 add 3  multiply 4")
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

    line = " ".join(args)
    try:
        val = evaluate(line)
        print(show(val))
    except (ValueError, ZeroDivisionError, KeyError) as err:
        print(f"error: {err}")
        sys.exit(1)


if __name__ == "__main__":
    main()
