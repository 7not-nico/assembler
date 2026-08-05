#!/usr/bin/env bash
# build-cmake.sh — instantiator code: build a cmake tree and verify the binary
# Usage: bash build-cmake.sh {build-dir} [--timeout {seconds}] [--binary {relpath}] [--log {name}]
# Shared code instantiated projects use to build cmake-based trees. Runs
# `cmake --build {build-dir} -j$(nproc)`; with --log {name}, pipes the build
# through the codex bitacora wrapper. Verifies the binary (default
# PPSSPPSDL; --binary overrides the relpath). Result lines: BUILD=pass,
# BINARY=, SIZE=.
set -uo pipefail

BUILD_DIR="${1:?build dir required}"
shift
TIMEOUT=""
BINARY="PPSSPPSDL"
LOG=""
while [ "$#" -gt 0 ]; do
	case "$1" in
	--timeout)
		TIMEOUT="${2:-}"
		shift 2
		;;
	--binary)
		BINARY="${2:-}"
		shift 2
		;;
	--log)
		LOG="${2:-}"
		shift 2
		;;
	*) shift ;;
	esac
done

[ -f "$BUILD_DIR/CMakeCache.txt" ] || {
	echo "ERROR no configured build tree: $BUILD_DIR" >&2
	exit 1
}

# shared deps — codex path resolution
. "$(dirname "$0")/deps/paths.sh"
WRAP="$CODEX/_templates/wrapper/run-bitacora.sh"

if [ -n "$LOG" ] && [ -f "$WRAP" ]; then
	bash "$WRAP" "$LOG" -- cmake --build "$BUILD_DIR" -j"$(nproc)"
else
	cmake --build "$BUILD_DIR" -j"$(nproc)"
fi
STATUS=$?
[ $STATUS -eq 0 ] || {
	echo "ERROR build failed (exit $STATUS)" >&2
	exit $STATUS
}

BIN_PATH="$BUILD_DIR/$BINARY"
if [ -f "$BIN_PATH" ]; then
	echo "BUILD=pass"
	echo "BINARY=$BIN_PATH"
	echo "SIZE=$(stat -c%s "$BIN_PATH")"
else
	echo "ERROR binary missing after build: $BIN_PATH" >&2
	exit 1
fi
