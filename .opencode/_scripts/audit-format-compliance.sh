#!/usr/bin/env bash
# audit-format-compliance.sh — verify skills + AGENTS.md against the categorical-junction template
# Action (read): audits SKILL.md and AGENTS.md files for template compliance
# Checks: ## categorical headings, junction bullets, no bold headers, no numbered steps,
#         no md tables outside code fences, no inline bold in bullets, no leading-space bullets
# Usage: bash audit-format-compliance.sh [--root DIR] [--kind skills|agents|all] [--exit]
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
KIND="all"
EXIT_ON_FAIL=""
while [ $# -gt 0 ]; do
  case "$1" in
    --root) ROOT="$2"; shift 2 ;;
    --kind) KIND="$2"; shift 2 ;;
    --exit) EXIT_ON_FAIL=1; shift ;;
    *) shift ;;
  esac
done

h2c()      { awk 'BEGIN{fence=0} /^```/{fence=!fence; next} !fence && /^## /{c++} END{print c+0}' "$1"; }
bulletsc() { awk 'BEGIN{fence=0} /^```/{fence=!fence; next} !fence && /^- /{c++} END{print c+0}' "$1"; }
boldc()    { awk 'BEGIN{fence=0} /^```/{fence=!fence; next} !fence && /^\*\*/{c++} END{print c+0}' "$1"; }
numc()     { awk 'BEGIN{fence=0} /^```/{fence=!fence; next} !fence && /^[0-9]+\./{c++} END{print c+0}' "$1"; }
tblc()     { awk 'BEGIN{fence=0} /^```/{fence=!fence; next} !fence && /^\|/{c++} END{print c+0}' "$1"; }
inlinec()  { awk 'BEGIN{fence=0} /^```/{fence=!fence; next} !fence && /^-[^-]*\*\*[^`]/{c++} END{print c+0}' "$1"; }
leadc()    { awk 'BEGIN{fence=0} /^```/{fence=!fence; next} !fence && /^ - /{c++} END{print c+0}' "$1"; }

audit_one() { # file -> 0 pass / 1 fail; echoes reason on fail
  local f="$1"
  local h2 bullets bold num tbl inline lead
  h2=$(h2c "$f")
  bullets=$(bulletsc "$f")
  bold=$(boldc "$f")
  num=$(numc "$f")
  tbl=$(tblc "$f")
  inline=$(inlinec "$f")
  lead=$(leadc "$f")
  if [ "$h2" -ge 1 ] && [ "$bullets" -ge 1 ] && [ "$bold" -eq 0 ] && [ "$num" -eq 0 ] && [ "$tbl" -eq 0 ] && [ "$inline" -eq 0 ] && [ "$lead" -eq 0 ]; then
    return 0
  fi
  echo "  FAIL: $f h2=$h2 bullets=$bullets bold=$bold num=$num tbl=$tbl inline=$inline lead=$lead"
  return 1
}

PASS=0; FAIL=0
audit_kind() { # label find-pattern
  local label="$1" pattern="$2"
  echo "== $label =="
  while IFS= read -r f; do
    [ -z "$f" ] && continue
    if audit_one "$f"; then PASS=$((PASS+1)); else FAIL=$((FAIL+1)); fi
  done < <(find "$ROOT" -name "$pattern" \
    -not -path "*/.git/*" -not -path "*/node_modules/*" \
    -not -path "*/.backups/*" -not -path "*/.archive/*" | sort)
}

case "$KIND" in
  skills) audit_kind "skills" "SKILL.md" ;;
  agents) audit_kind "agents" "AGENTS.md" ;;
  all)    audit_kind "skills" "SKILL.md"; audit_kind "agents" "AGENTS.md" ;;
esac

echo "PASS=$PASS FAIL=$FAIL"
[ "$FAIL" -gt 0 ] && [ -n "$EXIT_ON_FAIL" ] && exit 1
exit 0
