#!/usr/bin/env python3
# purity: pure
# ring: 0 (PURE) — pure core: path math, body builders, Record dataclass
# depends-on: stdlib only (pathlib, dataclasses, typing)
# r0_record.py — the bitacora flow's pure core. No I/O, no side effects.
# Composes the io edge (r4_bitacora.py). One unit per function.

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import NoReturn


def codex_root(start: Path) -> Path:
    """Walk up from start to the _codex ancestor. Pure: path math only."""
    d = start.resolve()
    while True:
        if d.name == "_codex":
            return d
        if d.parent == d:
            raise ValueError(f"no _codex ancestor above {start}")
        d = d.parent


@dataclass(frozen=True)
class Record:
    """A record identity: subdir + topic. Owns its own path derivation."""

    subdir: str
    topic: str
    ts: str

    def path(self, base: Path) -> Path:
        return base / "_bitacora" / self.subdir / f"{self.ts}-{self.topic}.md"


def todo_body(topic: str, desc: str, date: str) -> str:
    """The task-todo record body. Pure: string composition only."""
    return (
        f"# {topic} — todo\n\n"
        f"**Date:** {date}\n"
        f"**Project:** {desc}\n\n"
        f"## Tasks\n\n"
    )


def report_body(ts: str, topic: str, desc: str, date: str) -> str:
    """The task-report record body. Pure: string composition only."""
    return (
        f"# {ts} — {topic} close-out\n\n"
        f"**Date:** {date}\n"
        f"**Project:** {desc}\n\n"
        "## What happened\n\n"
        "## Decisions\n\n"
        "## Verification\n\n"
        "## Open edges\n\n"
        "## Todo state\n\n"
    )


def frame_header(cmd: tuple[str, ...], cwd: str, date: str) -> str:
    """The # CMD:/# DATE:/# CWD: header block. Pure."""
    quoted = " ".join(f'"{c}"' for c in cmd)
    return (
        f"# CMD: {quoted}\n"
        f"# DATE: {date}\n"
        f"# CWD: {cwd}\n"
        "# --------------------\n"
    )


def frame_tail(dur_ms: int, status: int, date: str) -> str:
    """The # DUR:/# DATE:/# exit: tail block. Pure."""
    return (
        f"# DUR: {dur_ms}ms\n"
        f"# DATE: {date}\n"
        f"# exit: {status}\n"
    )


def usage_text() -> str:
    """The usage block. Pure: string composition only."""
    return (
        "usage: bitacora {todo|run|report} ...\n"
        "  bitacora todo   {topic} [\"{desc}\"]\n"
        "  bitacora run    {name} [--trace] -- {cmd...}\n"
        "  bitacora report {topic} [\"{desc}\"]"
    )
