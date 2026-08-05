#!/usr/bin/env python3
# purity: io
# ring: 4 (LOCAL-WRITE) — writes records under _codex/_bitacora/
# depends-on: r0_record.py, stdlib (subprocess, time, typing)
# r4_bitacora.py — the bitacora flow's io edge. Composes the pure core
# (r0_record.py): Record identities, body builders, frame blocks. Memoized
# _codex root; lazy no-clobber; tuple commands; single clock read per
# invocation. Atomic unit: one subcommand per invocation.

from __future__ import annotations

import os
import subprocess
import sys
import time
from pathlib import Path
from typing import NoReturn

from r0_record import Record, codex_root, frame_header, frame_tail, report_body, todo_body, usage_text

Cmd = tuple[str, ...]

_ROOT: Path | None = None


def root() -> Path:
    """Memoized _codex root — computed once, shared across call sites."""
    global _ROOT
    if _ROOT is None:
        _ROOT = codex_root(Path(__file__).parent)
    return _ROOT


def record_write(rec: Record, body: str) -> Path:
    """Create a record file, no-clobber per topic. io: fs write."""
    base = root()
    rec_dir = base / "_bitacora" / rec.subdir
    rec_dir.mkdir(parents=True, exist_ok=True)
    first = next(iter(rec_dir.glob(f"*-{rec.topic}.md")), None)
    if first is not None:
        raise RuntimeError(f"{rec.subdir} record exists: {first}")
    path = rec.path(base)
    path.write_text(body)
    return path


def cmd_run(name: str, trace: bool, cmd: Cmd) -> int:
    """Frame a command: header, run, tail. io: subprocess + log write."""
    if not cmd:
        print("command required", file=sys.stderr)
        return 2
    base = root()
    stdout_dir = base / "_bitacora" / "task-stdout"
    stdout_dir.mkdir(parents=True, exist_ok=True)
    now = time.localtime()
    log_path = stdout_dir / f"{time.strftime('%Y%m%d-%H%M%S', now)}-{name}.log"

    header = frame_header(cmd, os.getcwd(), time.strftime("%Y-%m-%dT%H:%M:%S%z", now))
    with log_path.open("a") as fh:
        fh.write(header)
    print(header, end="")

    argv = ("tracexec", "log", "--", *cmd) if trace else cmd
    start = time.monotonic()
    try:
        proc = subprocess.run(argv, capture_output=True, text=True)
    except FileNotFoundError:
        print(f"ERROR command not found: {cmd[0]}", file=sys.stderr)
        status = 127
    else:
        status = proc.returncode
        with log_path.open("a") as fh:
            fh.write(proc.stdout)
            fh.write(proc.stderr)
        print(proc.stdout, end="")
        if proc.stderr:
            print(proc.stderr, end="", file=sys.stderr)
    dur_ms = int((time.monotonic() - start) * 1000)

    tail = frame_tail(dur_ms, status, time.strftime("%Y-%m-%dT%H:%M:%S%z", time.localtime()))
    with log_path.open("a") as fh:
        fh.write(tail)
    print(tail, end="")
    return status


def usage() -> NoReturn:
    print(usage_text(), file=sys.stderr)
    sys.exit(2)


def main(argv: list[str]) -> int:
    if not argv:
        usage()
    sub = argv[0]
    try:
        if sub == "todo":
            if len(argv) < 2:
                usage()
            topic = argv[1]
            desc = argv[2] if len(argv) > 2 else topic
            now = time.localtime()
            rec = Record("task-todo", topic, time.strftime("%Y%m%d-%H%M%S", now))
            path = record_write(rec, todo_body(topic, desc, time.strftime("%Y-%m-%d", now)))
            print(f"TODO={path}")
            return 0
        if sub == "report":
            if len(argv) < 2:
                usage()
            topic = argv[1]
            desc = argv[2] if len(argv) > 2 else topic
            now = time.localtime()
            ts = time.strftime("%Y%m%d-%H%M%S", now)
            rec = Record("task-report", topic, ts)
            path = record_write(rec, report_body(ts, topic, desc, time.strftime("%Y-%m-%d", now)))
            print(f"REPORT={path}")
            return 0
        if sub == "run":
            if len(argv) < 3:
                usage()
            name = argv[1]
            rest = argv[2:]
            trace = False
            if rest and rest[0] == "--trace":
                trace = True
                rest = rest[1:]
            if not rest or rest[0] != "--":
                usage()
            return cmd_run(name, trace, tuple(rest[1:]))
    except (RuntimeError, ValueError) as e:
        print(f"ERROR {e}", file=sys.stderr)
        return 1
    usage()


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
