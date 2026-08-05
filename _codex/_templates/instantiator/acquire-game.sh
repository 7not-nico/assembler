#!/usr/bin/env bash
# acquire-game.sh — codex shell: extract a game archive, verify the image, stage it
# Usage: bash acquire-game.sh {archive} {target-dir}
# The canonical implementation behind the acquire wrappers. Handles 7z, zip,
# rar, tar archives via 7z; passes a bare image file (iso/cso/sfc/smc/nes/gba/
# chd/pbp/...) straight through. Finds the largest game image inside, verifies
# it with `file`, slugifies the name via slugify.sh, and moves it into
# target-dir. Result lines: IMAGE={absolute path}, SIZE={bytes}, STATUS={exit}.
# Cwd-independent. Atomic unit contract: one responsibility, keyed result
# line out, non-zero on failure.
set -uo pipefail

ARCHIVE="${1:?archive path required}"
TARGET="${2:?target dir required}"
[ -f "$ARCHIVE" ] || {
	echo "ERROR archive not found: $ARCHIVE" >&2
	exit 1
}
mkdir -p "$TARGET"

WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# image extensions — a file with one of these IS the game; no extraction
EXT="$(printf '%s' "$ARCHIVE" | sed 's/.*\.//' | tr '[:upper:]' '[:lower:]')"
case "$EXT" in
iso | cso | sfc | smc | nes | gba | gb | gbc | chd | pbp | nds | z64 | n64 | v64 | rom)
	IMAGE="$ARCHIVE"
	;;
*)
	command -v 7z >/dev/null 2>&1 || {
		echo "ERROR 7z required for archives" >&2
		exit 1
	}
	if ! 7z x "$ARCHIVE" -o"$WORK" -y >/dev/null 2>&1; then
		echo "ERROR extract failed: $ARCHIVE" >&2
		exit 1
	fi
	IMAGE="$(find "$WORK" -type f \( -iname '*.iso' -o -iname '*.cso' -o -iname '*.sfc' \
		-o -iname '*.smc' -o -iname '*.nes' -o -iname '*.gba' -o -iname '*.gb' -o -iname '*.gbc' \
		-o -iname '*.chd' -o -iname '*.pbp' -o -iname '*.nds' -o -iname '*.z64' -o -iname '*.n64' \
		-o -iname '*.rom' \) -printf '%s %p\n' | sort -rn | head -1 | cut -d' ' -f2-)"
	[ -n "$IMAGE" ] || {
		echo "ERROR no game image inside $ARCHIVE" >&2
		exit 1
	}
	;;
esac

# verify — warn on an unrecognized image type, never fail on a pass-through
FTYPE="$(file -b "$IMAGE")"
case "$FTYPE" in
*"ISO 9660"* | *CD-ROM* | *CISO* | *"Super NES"* | *Nintendo* | *"Game Boy"* | *PlayStation* | *"Zip archive"* | *"data"*)
	;;
*)
	echo "WARN unverified image type: $FTYPE" >&2
	;;
esac

# stage — slugify the name, move into target, report
SLUG="$(bash "$(dirname "$0")/../shell/slugify.sh" "$(basename "$IMAGE")")"
[ -n "$SLUG" ] || {
	echo "ERROR slugify failed for $IMAGE" >&2
	exit 1
}
mv "$IMAGE" "$TARGET/$SLUG" || {
	echo "ERROR stage failed: $TARGET/$SLUG" >&2
	exit 1
}
SIZE="$(stat -c%s "$TARGET/$SLUG")"

echo "IMAGE=$TARGET/$SLUG"
echo "SIZE=$SIZE"
echo "STATUS=0"
