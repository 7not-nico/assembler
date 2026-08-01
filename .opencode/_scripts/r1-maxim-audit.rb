#!/usr/bin/env bash
# ring: 1 (DB-READ) — maxim structural audit via Rust binary
exec "$(dirname "$0")/rs" audit maxims
