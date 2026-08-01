#!/usr/bin/env bash
# compile all fixtures, report pass/fail per file

set -euo pipefail

root="$(dirname "$0")/.."
pass=0
fail=0

for f in "$root"/fixtures/ch*.rs; do
    name=$(basename "$f" .rs)
    binary="/tmp/$name"

    if echo "$f" | grep -q "test"; then
        rustc --test "$f" -o "$binary" -W warnings 2>/tmp/err-"$name".txt && { echo "PASS: $name"; pass=$((pass+1)); } || { echo "FAIL: $name"; fail=$((fail+1)); }
    else
        rustc "$f" -o "$binary" -W warnings 2>/tmp/err-"$name".txt && { echo "PASS: $name"; pass=$((pass+1)); } || { echo "FAIL: $name"; fail=$((fail+1)); }
    fi
done

echo "---"
echo "pass: $pass  fail: $fail"
[ "$fail" -eq 0 ]
