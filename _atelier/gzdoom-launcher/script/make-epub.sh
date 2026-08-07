#!/usr/bin/env bash
# make-epub.sh — builds ZScript.epub from the ZDoom docs staging site.
# Fetches the mdBook print.html, enumerates every sidebar page, fetches all
# pages in parallel, merges any content not already in print.html, converts
# with pandoc, and verifies the epub.
#
# usage: script/make-epub.sh [base-url]
# output: ZScript.epub in the project root
# result lines: EPUB= PAGES= CHAPTERS= FETCHED= FAILED= MISSING= BYTES=

set -euo pipefail

base="${1:-https://zdoom-docs.github.io/staging}"
here="$(cd "$(dirname "$0")/.." && pwd)"
out="$here/ZScript.epub"
work="$(mktemp -d)"
export base work
trap 'rm -rf "$work"' EXIT

echo "== fetch print.html =="
curl -sfL --retry 3 --connect-timeout 15 --max-time 60 "$base/print.html" -o "$work/print.html"

echo "== enumerate book pages from the sidebar =="
curl -sfL --retry 3 --connect-timeout 15 --max-time 60 "$base/ZScript.html" -o "$work/toc.html"
rg -o 'href="[^"]+\.html"' "$work/toc.html" \
  | sed 's/^href="//; s/"$//' \
  | sed 's/^\.\///' \
  | rg -v '^(https?:|#|\.\./|print\.html|index\.html$)' \
  | sort -u > "$work/pages.txt"
pages=$(wc -l < "$work/pages.txt")
echo "book pages: $pages"

echo "== fetch all pages in parallel (bounded 180s) =="
mkdir -p "$work/fetched"
timeout 180 bash -c 'cat "$1" | xargs -P 16 -I{} bash -c "
  page=\"\$1\"
  slug=\$(printf \"%s\" \"\$page\" | tr \"/\" \"_\")
  curl -sfL --retry 0 --connect-timeout 6 --max-time 12 \
    \"\$base/\$page\" -o \"\$work/fetched/\$slug.html\" 2>/dev/null \
    || rm -f \"\$work/fetched/\$slug.html\"
" _ {}' _ "$work/pages.txt" || echo "fetch phase timed out — continuing with partial set"

echo "== merge pages not already in print.html =="
fetched=0
failed=0
missing=0
: > "$work/merge.html"
while IFS= read -r page; do
  slug=$(printf "%s" "$page" | tr "/" "_")
  f="$work/fetched/$slug.html"
  if [ -s "$f" ]; then
    fetched=$((fetched + 1))
    awk '/<main>/{flag=1} flag{print} /<\/main>/{flag=0}' "$f" > "$work/main.html"
    probe=$(tr -s '[:space:]' ' ' < "$work/main.html" | head -c 200)
    if [ -n "$probe" ] && ! rg -qF "$probe" "$work/print.html"; then
      cat "$work/main.html" >> "$work/merge.html"
      printf '\n' >> "$work/merge.html"
      missing=$((missing + 1))
    fi
  else
    echo "UNFETCHABLE: $page"
    failed=$((failed + 1))
  fi
done < "$work/pages.txt"
echo "pages merged: $missing"
if [ -s "$work/merge.html" ]; then
  awk -v m="$work/merge.html" 'BEGIN{done=0}
    /<\/body>/ && !done {while ((getline line < m) > 0) print line; done=1}
    {print}' "$work/print.html" > "$work/merged.html"
  mv "$work/merged.html" "$work/print.html"
fi

echo "== convert with pandoc =="
chapters=$(rg -c '<h1' "$work/print.html")
pandoc "$work/print.html" \
  -f html -t epub3 -o "$out" \
  --metadata title="ZDoom Docs — ZScript" \
  --metadata author="ZDoom Docs" \
  --toc --toc-depth=2

echo "== verify epub =="
unzip -tq "$out" > /dev/null
mime=$(unzip -p "$out" mimetype)
bytes=$(stat -c %s "$out")
[ "$mime" = "application/epub+zip" ]

echo "EPUB=$out"
echo "PAGES=$pages"
echo "CHAPTERS=$chapters"
echo "FETCHED=$fetched"
echo "FAILED=$failed"
echo "MISSING=$missing"
echo "BYTES=$bytes"
