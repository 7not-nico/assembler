#!/usr/bin/env bash
# run.sh — the launcher fixture gate: build samples, run every fixture, aggregate exit.
# Run:   bash fixture/run.sh
# Proves every component behavior listed in fixture/README.md before smoke/integrity/launch.

set -uo pipefail

S="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
Root="$(cd "$S/.." && pwd)"

pass=0
fail=0

check() {
    name="$1"
    shift
    echo "== fixture: $name =="
    if "$@"; then
        echo "pass $name"
        pass=$((pass + 1))
    else
        echo "FAIL $name"
        fail=$((fail + 1))
    fi
}

bash "$S/sample/build.sh" > /dev/null || {
    echo "FAIL sample build"
    exit 1
}

check scan-iwad   uv run --project "$Root" python "$S/scan-iwad-test.py"
check scan-map    uv run --project "$Root" python "$S/scan-map-test.py"
check scan-mods   uv run --project "$Root" python "$S/scan-mods-test.py"
check command     uv run --project "$Root" python "$S/command-build-test.py"
check extract     bash "$S/extract-wads-test.sh"
check probe       bash "$S/probe-header-test.sh"
check append-upsert bash "$S/append-upsert-test.sh"

echo "FIXTURES pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
