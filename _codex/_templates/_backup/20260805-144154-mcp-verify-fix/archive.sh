#!/usr/bin/env bash
# deps/archive.sh — instantiator dependency: game-image archive primitives
# Sourced by archive-backed instantiator tools (acquire-game, verify-archive).
# Provides IMAGE_EXTS (canonical image-extension set), archive_kind {file}
# (bare|zip|7z|tar|rar via file -b), largest_image {dir} (biggest matching
# image inside an extracted workdir), image_in_archive {archive} {exts}
# (per-extractor listing, first match), image_size_in_archive {archive}
# {image} (per-extractor byte size). Pure: functions + constant only.
set -uo pipefail

IMAGE_EXTS="iso cso sfc smc nes gba gb gbc chd pbp nds z64 n64 v64 rom"

archive_kind() {
	local ft
	ft="$(file -b "$1")"
	case "$ft" in
	*Zip* | *zip*) echo "zip" ;;
	*7-zip* | *7z*) echo "7z" ;;
	*tar*) echo "tar" ;;
	*RAR* | *rar*) echo "rar" ;;
	*) echo "bare" ;;
	esac
}

largest_image() {
	find "$1" -type f \( -iname '*.iso' -o -iname '*.cso' -o -iname '*.sfc' \
		-o -iname '*.smc' -o -iname '*.nes' -o -iname '*.gba' -o -iname '*.gb' -o -iname '*.gbc' \
		-o -iname '*.chd' -o -iname '*.pbp' -o -iname '*.nds' -o -iname '*.z64' -o -iname '*.n64' \
		-o -iname '*.rom' \) -printf '%s %p\n' | sort -rn | head -1 | cut -d' ' -f2-
}

image_in_archive() {
	local archive="$1" exts="${2:-$IMAGE_EXTS}" pat
	pat="$(printf '\.(%s)$' "${exts// /|}")"
	case "$(archive_kind "$archive")" in
	zip)
		unzip -Z1 "$archive" | grep -E "$pat" | head -1
		;;
	7z | rar)
		7z l -slt "$archive" | awk -v pat="\\.(${exts// /|})$" '/^Path = /{p=$3} p ~ pat && !/\.txt/ {print p; exit}'
		;;
	tar)
		tar -tf "$archive" | grep -E "$pat" | head -1
		;;
	*) echo "" ;;
	esac
}

image_size_in_archive() {
	local archive="$1" image="$2"
	case "$(archive_kind "$archive")" in
	zip)
		unzip -l "$archive" | awk -v n="$image" 'index($0,n) && $0 ~ /\.(sfc|smc|iso|cso)$/ {print $1; exit}'
		;;
	7z | rar)
		7z l -slt "$archive" | awk -v n="$image" '/^Size = /{size=$3} /^Path = /{path=$3} path == n {print size; exit}'
		;;
	tar)
		tar -tvf "$archive" | awk -v n="$image" 'index($0,n) {print $3; exit}'
		;;
	*) echo "" ;;
	esac
}
