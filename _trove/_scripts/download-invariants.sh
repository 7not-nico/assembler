#!/usr/bin/env bash
# download-invariants.sh — fetch curated invariant-theory PDFs from arxiv
# Script dir: _trove/_scripts/ ; output: _trove/math/invariant-theory/

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="$SCRIPT_DIR/../math/invariant-theory"
mkdir -p "$OUT_DIR"

# fields: id|url|slug
papers=(
  "1512.06411|https://arxiv.org/pdf/1512.06411v3|hilbert-series-noncommutative-invariant-theory"
  "2511.07718|https://arxiv.org/pdf/2511.07718v2|homological-properties-invariant-rings-permutation-groups"
  "alg-geom/9402008|https://arxiv.org/pdf/alg-geom/9402008v4|variation-git-quotients"
  "2506.19431|https://arxiv.org/pdf/2506.19431v2|compgit-package"
  "math/0112026|https://arxiv.org/pdf/math/0112026v2|quandle-homology-cocycle-knot-invariants"
  "1910.11129|https://arxiv.org/pdf/1910.11129v1|instantons-concordance-invariants-knots"
  "1112.6290|https://arxiv.org/pdf/1112.6290v2|cohomological-invariants-weyl-groups-mod-2"
  "2302.03021|https://arxiv.org/pdf/2302.03021v3|kontsevich-characteristic-classes-topological-invariants"
)

ok=0
fail=0
declare -a failed_rows

for row in "${papers[@]}"; do
  IFS='|' read -r id url slug <<< "$row"
  target="$OUT_DIR/$slug.pdf"

  if curl -fsSL --retry 2 --connect-timeout 20 -o "$target" "$url"; then
    magic="$(head -c 4 "$target")"
    if [[ "$magic" == "%PDF" ]]; then
      printf 'ok      %s (%s)\n' "$slug" "$id"
      ok=$((ok + 1))
    else
      printf 'BADPDF  %s — magic=%s\n' "$slug" "$magic"
      rm -f "$target"
      fail=$((fail + 1))
      failed_rows+=("$id|$slug|bad-pdf")
    fi
  else
    printf 'FAIL    %s (%s)\n' "$slug" "$id"
    rm -f "$target"
    fail=$((fail + 1))
    failed_rows+=("$id|$slug|download-error")
  fi
done

printf '\nresult ok=%d fail=%d out=%s\n' "$ok" "$fail" "$OUT_DIR"
if (( fail > 0 )); then
  printf 'failed:\n'
  for row in "${failed_rows[@]}"; do
    IFS='|' read -r id slug reason <<< "$row"
    printf '  %s (%s) — %s\n' "$slug" "$id" "$reason"
  done
  exit 1
fi
