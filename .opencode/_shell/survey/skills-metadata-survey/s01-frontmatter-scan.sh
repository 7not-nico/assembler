#!/usr/bin/env bash
# s01-frontmatter-scan.sh — scan every .opencode/skills/*/SKILL.md frontmatter
# ring: 1 (LOCAL-READ) — metadata inventory, read-only
# survey: skills-metadata-survey
# Emits keyed lines: SKILL=<name> FIELDS=<csv> STYLE=<json|yaml|mixed> NEX=<csv> TYPE=<val>
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
SKILLS="$ROOT/.opencode/skills"
SEP="────────────────────────────────────────────────────────"

echo "# s01 — skills frontmatter scan"
echo "SKILLS_DIR=$SKILLS"
echo

total=0
json=0
yaml=0
mixed=0
no_nex=0

for dir in "$SKILLS"/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] || { echo "SKILL=$name FIELDS=NO_FILE"; total=$((total+1)); continue; }
  total=$((total+1))

  # extract frontmatter block (between first two --- lines)
  fm="$(awk 'BEGIN{c=0} /^---$/{c++; next} c==1{print} c==2{exit}' "$dir/SKILL.md")"
  [ -n "$fm" ] || { echo "SKILL=$name FIELDS=NO_FRONTMATTER"; continue; }

  # field presence
  f_name="$(echo "$fm" | grep -c '^name:' || true)"
  f_desc="$(echo "$fm" | grep -c '^description:' || true)"
  f_sp="$(echo "$fm" | grep -c '^state-profile:' || true)"
  f_type="$(echo "$fm" | grep -c '^type:' || true)"
  f_rel="$(echo "$fm" | grep -c '^related:' || true)"
  f_pat="$(echo "$fm" | grep -c '^patterns:' || true)"
  f_ter="$(echo "$fm" | grep -c '^terms:' || true)"
  f_nex="$(echo "$fm" | grep -c '^nexus:' || true)"

  # array style: quote presence inside related/patterns/terms values
  style="none"
  if echo "$fm" | grep -qE '^(related|patterns|terms):\s*\['; then
    if echo "$fm" | grep -qE '^(related|patterns|terms):\s*\[[^]]*"' ; then style="json"
    elif echo "$fm" | grep -qE '^(related|patterns|terms):\s*\[[^]]*\]' ; then style="yaml"
    fi
  fi
  case "$style" in json) json=$((json+1));; yaml) yaml=$((yaml+1));; esac

  # type value
  tval="$(echo "$fm" | sed -n 's/^type:\s*//p' | tr -d ' "')"

  # NEX references across related/patterns/terms (uppercase dot tokens starting NEX.)
  nex="$(echo "$fm" | grep -oE 'NEX\.[A-Z0-9._-]+' | sort -u | tr '\n' ',' | sed 's/,$//')"
  [ -n "$nex" ] || no_nex=$((no_nex+1))

  # stale/phantom NEX ids
  stale=""
  for n in $(echo "$nex" | tr ',' ' '); do
    case "$n" in
      NEX.INVESTIGATION.PIPELINE.STAGE) stale="$stale $n→NEX.INVESTIGATION.STAGE";;
      NEX.META.TOON.ORCHESTRATION) stale="$stale $n→NEX.META.ORCHESTRATION";;
      NEX.META.ENTITY.PROPOSAL) stale="$stale $n→NEX.META.PROPOSAL";;
    esac
  done

  echo "SKILL=$name FIELDS=name:$f_name,description:$f_desc,state-profile:$f_sp,type:$f_type,related:$f_rel,patterns:$f_pat,terms:$f_ter,nexus:$f_nex STYLE=$style TYPE=${tval:-none} NEX=${nex:-none} STALE=${stale:-none}"
done

echo
echo "$SEP"
echo "SUMMARY total=$total json_style=$json yaml_style=$yaml no_nex_ref=$no_nex"
