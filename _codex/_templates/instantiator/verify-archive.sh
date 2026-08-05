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

# shared deps — archive primitives (archive_kind, image_in_archive, image_size_in_archive)
. "$(dirname "$0")/deps/archive.sh"

FT="$(file -b "$FILE")"
KIND="$(archive_kind "$FILE")"
case "$KIND" in
  bare)
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

IMAGE="$(image_in_archive "$FILE" "$EXTS")"
if [ -z "$IMAGE" ]; then
  echo "ERROR no image inside archive (expected .${EXTS// /|.})" >&2
  exit 1
fi
SIZE="$(image_size_in_archive "$FILE" "$IMAGE" | tr -cd '0-9')"

echo "OK   $IMAGE ($SIZE B)"
echo "IMAGE=$IMAGE"
echo "SIZE=$SIZE"
