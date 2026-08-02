#!/usr/bin/env bash
# fixture-ruby-sim.sh — exercises the _sandbox Ruby simulation family
# Shape: KEY=value contract; composes three stdlib Ruby programs through the
# wrapper: random-sum.rb, random-stats.rb, monte-carlo.rb.
# Graceful SKIP when the gitignored _sandbox/ directory is absent (fresh clone).
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"     # repo root
SANDBOX="$ROOT/_sandbox"
PROGRAMS=(random-sum.rb random-stats.rb monte-carlo.rb)

if [[ ! -d "$SANDBOX" ]]; then
  echo "SANDBOX=absent"
  echo "RESULT=skip:none"
  exit 0
fi

echo "SANDBOX=$SANDBOX"
runs=0
fails=0
for prog in "${PROGRAMS[@]}"; do
  name="${prog%.rb}"
  out="$(ruby "$SANDBOX/$prog" 2>&1)"
  rc=$?
  result_line="$(printf '%s\n' "$out" | sed -n 's/^RESULT=//p' | tail -1)"
  printf 'RUN_%s=%s\n' "$name" "$result_line"
  echo "RUN_${name}_EXIT=$rc"
  runs=$((runs + 1))
  [[ $rc -eq 0 ]] || fails=$((fails + 1))
done

echo "RUNS=$runs"
echo "FAILS=$fails"
if [[ $fails -eq 0 && $runs -eq ${#PROGRAMS[@]} ]]; then
  echo "RESULT=pass:$runs"
  exit 0
else
  echo "RESULT=fail:$fails"
  exit 1
fi
