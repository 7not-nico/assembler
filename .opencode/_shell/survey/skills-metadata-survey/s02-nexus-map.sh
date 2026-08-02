#!/usr/bin/env bash
# s02-nexus-map.sh — derive proposed `nexus:` for each skill from current refs + composition fit
# ring: 1 (LOCAL-READ) — read-only mapping proposal
# survey: skills-metadata-survey
# Emits: SKILL=<name> PROPOSED=<NEX.ID|none> FROM=<explicit|derive|none> EVIDENCE=<csv>
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
SKILLS="$ROOT/.opencode/skills"
NEXUS_DIR="$ROOT/.opencode/entities/nexus"
SEP="────────────────────────────────────────────────────────"

# canonical nexus ids (from entities/nexus/*.md)
mapfile -t NEXIDS < <(basename -s .md "$NEXUS_DIR"/*.md 2>/dev/null)
echo "# s02 — nexus mapping proposal"
echo "CANONICAL_NEXUS=$(IFS=,; echo "${NEXIDS[*]}")"
echo

# alias normalization for stale/legacy ids
norm() {
  case "$1" in
    NEX.INVESTIGATION.PIPELINE.STAGE) echo "NEX.INVESTIGATION.STAGE";;
    NEX.META.TOON.ORCHESTRATION) echo "NEX.META.ORCHESTRATION";;
    NEX.META.ENTITY.PROPOSAL) echo "NEX.META.PROPOSAL";;
    *) echo "$1";;
  esac
}

for dir in "$SKILLS"/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] || continue
  fm="$(awk 'BEGIN{c=0} /^---$/{c++; next} c==1{print} c==2{exit}' "$dir/SKILL.md")"
  [ -n "$fm" ] || continue

  # collect NEX ids from related/patterns/terms
  refs="$(echo "$fm" | grep -oE 'NEX\.[A-Z0-9._-]+' | sort -u)"
  proposed=""
  from="none"
  evidence=""

  if [ -n "$refs" ]; then
    # normalize, filter to canonical, pick first as primary proposal
    props=""
    for r in $refs; do
      n="$(norm "$r")"
      # keep only canonical ids
      for c in "${NEXIDS[@]}"; do
        [ "$n" = "$c" ] && { props="$props $c"; evidence="$evidence $r"; }
      done
    done
    # single canonical -> that; multiple -> first (primary) noted in evidence
    props="$(echo "$props" | tr ' ' '\n' | sort -u | tr '\n' ' ' | sed 's/ $//')"
    if [ -n "$props" ]; then
      first="$(echo "$props" | awk '{print $1}')"
      proposed="$first"
      from="derive"
      if [ "$(echo "$props" | wc -w)" -eq 1 ]; then from="explicit"; fi
    fi
  fi

  # heuristic fallback for search/propose/use families when no canonical ref found
  if [ -z "$proposed" ]; then
    case "$name" in
      search-patterns|search-protocols|search-maxims|search-nexus) proposed="NEX.TOOL.SEQUENCE"; from="derive";;
      search-papers) proposed="NEX.ACQUIRE.PIPELINE"; from="derive";;
      use-playwright-*) proposed="NEX.BROWSER.STACK"; from="derive";;
      propose-*) proposed="NEX.META.PROPOSAL"; from="derive";;
      use-exa|use-parallel-search|use-context-seven) proposed="NEX.INVESTIGATION.STAGE"; from="derive";;
      use-entity-audit) proposed="NEX.TOOL.SEQUENCE"; from="derive";;
      vet-proposal|judge-semantic|declare-grounded-entity) proposed="NEX.META.PROPOSAL"; from="derive";;
      guide-architecture|propose-mcp|propose-tool) proposed="NEX.TOOL.CHOICE"; from="derive";;
      knowledge-ruby|compose-web) proposed="NEX.INVESTIGATION.STAGE"; from="derive";;
      refactor-skill) proposed="NEX.TOOL.SEQUENCE"; from="derive";;
      stage-create) proposed="NEX.META.ORCHESTRATION"; from="derive";;
      scaffold-tools|bootstrap-db) proposed="NEX.META.PROPOSAL"; from="derive";;
      reason-*) proposed="NEX.META.CANVAS"; from="derive";;
      survey-scripts) proposed="NEX.META.ORCHESTRATION"; from="derive";;
      *) proposed="none";;
    esac
  fi

  echo "SKILL=$name PROPOSED=${proposed:-none} FROM=$from EVIDENCE=$(echo ${evidence:-none} | sed 's/^ //')"
done
