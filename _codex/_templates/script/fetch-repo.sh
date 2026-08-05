#!/usr/bin/env bash
# fetch-repo.sh — shallow-clone a repo into {base}/{repo}-repo/{repo}/ (depth 1)
# Usage: bash fetch-repo.sh {repo-url} {base-dir} [fallback-url...]
# Derives {repo} from the URL; creates {base-dir}/{repo}-repo/ project dir and
# clones with --depth 1 into {repo}-repo/{repo}/. Tries fallback URLs in order
# when a clone fails; refuses non-empty project dirs (no clobber).
set -euo pipefail

URL="${1:?repo-url required}"
BASE="${2:?base-dir required}"
shift 2
FALLBACKS=("$@")

repo_name() {
  local path="${1##*/}"
  path="${path%.git}"
  echo "$path"
}

NAME="$(repo_name "$URL")"
PROJECT="$BASE/$NAME-repo"

if [ -e "$PROJECT" ] && [ -n "$(ls -A "$PROJECT" 2>/dev/null)" ]; then
  echo "REFUSE $PROJECT (non-empty — move or clear it first)" >&2
  exit 1
fi

mkdir -p "$PROJECT"

clone() {
  local name
  name="$(repo_name "$1")"
  echo "FETCH  $1 → $PROJECT/$name (depth 1)"
  git clone --depth 1 "$1" "$PROJECT/$name"
}

for attempt in "$URL" "${FALLBACKS[@]}"; do
  if clone "$attempt"; then
    echo "DONE   $PROJECT"
    exit 0
  fi
  echo "FAIL   $attempt — trying next source"
done

echo "ERROR  all sources failed" >&2
exit 1
