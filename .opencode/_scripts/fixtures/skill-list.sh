#!/usr/bin/env bash
# skill-list.sh — list registered agent skills with a keyed count line.
# stdout: skill names, one per line; SKILL_COUNT=N last
# stderr: diagnostics only
set -u

skills="$(ls -1 .opencode/skills/ 2>/dev/null; ls -1 ~/.agents/skills/ 2>/dev/null)"
count="$(echo "$skills" | wc -l)"

echo "$skills"
echo "SKILL_COUNT=$count"
