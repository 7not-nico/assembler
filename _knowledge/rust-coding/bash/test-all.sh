#!/usr/bin/env bash
# run all fixture test suites, report pass/fail per file

set -euo pipefail

root="$(dirname "$0")/.."
pass=0
fail=0

for f in "$root"/fixtures/ch*.rs; do
    name=$(basename "$f" .rs)
    binary="/tmp/test-$name"

    if rustc --test "$f" -o "$binary" -W warnings 2>/tmp/err-"$name".txt; then
        if "$binary" 2>/tmp/run-"$name".txt >/tmp/out-"$name".txt; then
            result=$(grep "^test result:" /tmp/out-"$name".txt | head -1)
            echo "PASS: $name — $result"
            pass=$((pass+1))
        else
            echo "FAIL: $name — tests exited non-zero"
            fail=$((fail+1))
        fi
    else
        echo "FAIL: $name — compile error"
        fail=$((fail+1))
    fi
done

echo "---"
echo "pass: $pass  fail: $fail"
[ "$fail" -eq 0 ]
