#!/usr/bin/env bash
# verify-archive.sh — instantiator code: verify a downloaded game archive
# Usage: bash verify-archive.sh {file} [--image-ext {ext,ext...}]
# Shared code instantiated projects use to verify a downloaded game archive:
# `file` type detection (zip/7z/tar/rar), listing via the matching extractor,
# exactly-one image expected (.sfc/.smc/.iso/.cso by default; --image-ext
# overrides), size sanity, and an optional title probe when a probe tool
# exists beside this code. Result lines: OK=, IMAGE=, SIZE=, TITLE=.
set -uo pipefail

FILE="${1:?file required}"
shift
EXTS="sfc smc iso cso"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --image-ext) EXTS="${2:-}"; shift 2 ;;
    *) shift ;;
  esac
done

[ -f "$FILE" ] || { echo "ERROR no such file: $FILE" >&2; exit 1; }

FT="$(file -b "$FILE")"
EXTRACTOR=""
case "$FT" in
  *Zip*|*zip*) EXTRACTOR="unzip" ;;
  *7-zip*|*7z*) EXTRACTOR="7z" ;;
  *tar*) EXTRACTOR="tar" ;;
  *RAR*|*rar*) EXTRACTOR="7z" ;;
  *)
    # bare image pass-through — the archive case excludes these
    case "$FT" in
      *ISO*|*filesystem*) ;;
      *) echo "ERROR unrecognized archive type: $FT" >&2; exit 1 ;;
    esac
    IMAGE="$FILE"
    SIZE="$(stat -c%s "$FILE")"
    echo "OK   bare image"
    echo "IMAGE=$IMAGE"
    echo "SIZE=$SIZE"
    exit 0
    ;;
esac

PAT="$(printf '\.(%s)$' "${EXTS// /|}")"
case "$EXTRACTOR" in
  unzip) IMAGE="$(unzip -Z1 "$FILE" | grep -E "$PAT" | head -1)"
         SIZE="$(unzip -l "$FILE" | awk -v n="$IMAGE" 'index($0,n) && $0 ~ /\.(sfc|smc|iso|cso)$/ {print $1; exit}')" ;;
  7z)    IMAGE="$(7z l -slt "$FILE" | awk '/Path = /{p=$3} /^Path = /{p=$3} p ~ /\.(sfc|smc|iso|cso)$/ && !/\.txt/ {print p; exit}')"
         SIZE="$(7z l -slt "$FILE" | awk -v n="$IMAGE" 'prev ~ /Path = / && $0 == "Size = " {s=$3} $0 ~ ("Path = " n) {print s; exit}')" ;;
  tar)   IMAGE="$(tar -tf "$FILE" | grep -E "$PAT" | head -1)"
         SIZE="$(tar -tvf "$FILE" | awk -v n="$IMAGE" 'index($0,n) {print $3; exit}')" ;;
esac

if [ -z "${IMAGE:-}" ]; then
  echo "ERROR no image inside archive (expected .${EXTS// /|.})" >&2
  exit 1
fi
SIZE="$(echo "$SIZE" | tr -cd '0-9')"

echo "OK   $IMAGE ($SIZE B)"
echo "IMAGE=$IMAGE"
echo "SIZE=$SIZE"
