#!/usr/bin/env bash
# acquire-game.sh — codex shell: extract a game archive, verify the image, stage it
# Usage: bash acquire-game.sh {archive} {target-dir}
# The canonical implementation behind the acquire wrappers. Handles 7z, zip,
# rar, tar archives via 7z; passes a bare image file (iso/cso/sfc/smc/nes/gba/
# chd/pbp/...) straight through. Finds the largest game image inside, verifies
# it with `file`, slugifies the name via the shared _shared/bin/slugify
# binary, and moves it into target-dir. Result lines: IMAGE={absolute path},
# SIZE={bytes}, STATUS={exit}.
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

# shared deps — archive primitives (IMAGE_EXTS, largest_image) + slugify
. "$(dirname "$0")/deps/archive.sh"

# image extensions — a file with one of these IS the game; no extraction
EXT="$(printf '%s' "$ARCHIVE" | sed 's/.*\.//' | tr '[:upper:]' '[:lower:]')"
case " $IMAGE_EXTS " in
	*" $EXT "*)
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
		IMAGE="$(largest_image "$WORK")"
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

# stage — slugify the name (shared Go binary), move into target, report
SLUG="$("$(dirname "$0")/../_shared/bin/slugify" "$(basename "$IMAGE")")"
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
