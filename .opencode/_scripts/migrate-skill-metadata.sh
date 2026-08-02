#!/usr/bin/env bash
# migrate-skill-metadata.sh — rewrite skills frontmatter to canonical set
# Action (write): replaces related/patterns/terms with nexus in .opencode/skills/*/SKILL.md
# Canonical frontmatter: name, description, state-profile, nexus (optional)
# Drops: type, related, patterns, terms (stale metadata)
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SKILLS="$ROOT/.opencode/skills"

# nexus mapping — reviewed, corrected from survey s02 proposals
declare -A NEXUS=(
  [bootstrap-db]="NEX.META.PROPOSAL"
  [classify-tool]="NEX.TOOL.SEQUENCE"
  [compose-web]="NEX.INVESTIGATION.STAGE"
  [declare-grounded-entity]="NEX.META.PROPOSAL"
  [guide-architecture]="NEX.TOOL.CHOICE"
  [guide-reasoning]="NEX.META.CANVAS"
  [judge-semantic]="NEX.META.PROPOSAL"
  [knowledge-ruby]=""
  [manage-bash-flows]="NEX.ACQUIRE.PIPELINE"
  [orchestrate-research]="NEX.INVESTIGATION.STAGE"
  [propose-command]="NEX.META.PROPOSAL"
  [propose-investigation]="NEX.META.PROPOSAL"
  [propose-mcp]="NEX.META.PROPOSAL"
  [propose-pattern]="NEX.META.PROPOSAL"
  [propose-protocol]="NEX.META.PROPOSAL"
  [propose-rule]="NEX.META.PROPOSAL"
  [propose-term]="NEX.META.PROPOSAL"
  [propose-tool]="NEX.META.PROPOSAL"
  [reason-invariants]="NEX.TOOL.SEQUENCE"
  [reason-quantitative]="NEX.META.CANVAS"
  [reason-verbal]="NEX.META.CANVAS"
  [refactor-skill]="NEX.TOOL.SEQUENCE"
  [scaffold-tools]="NEX.META.PROPOSAL"
  [search-geo]="NEX.INVESTIGATION.STAGE"
  [search-maxims]=""
  [search-nexus]=""
  [search-papers]="NEX.ACQUIRE.PIPELINE"
  [search-patterns]=""
  [search-protocols]=""
  [stage-create]="NEX.META.ORCHESTRATION"
  [structure-stdout]="NEX.ACQUIRE.PIPELINE"
  [study-foundations]="NEX.INVESTIGATION.STAGE"
  [survey-scripts]="NEX.META.PROPOSAL"
  [use-context-seven]="NEX.INVESTIGATION.STAGE"
  [use-entity-audit]="NEX.TOOL.SEQUENCE"
  [use-exa]="NEX.INVESTIGATION.STAGE"
  [use-parallel-search]="NEX.INVESTIGATION.STAGE"
  [use-playwright-ai-mode]="NEX.BROWSER.STACK"
  [use-playwright-core]="NEX.BROWSER.STACK"
  [use-playwright-debug]="NEX.BROWSER.STACK"
  [use-playwright-network-storage]="NEX.BROWSER.STACK"
  [use-playwright-vision]="NEX.BROWSER.STACK"
  [vet-proposal]="NEX.META.PROPOSAL"
)

count=0
for dir in "$SKILLS"/*/; do
  name="$(basename "$dir")"
  [ -f "$dir/SKILL.md" ] || continue
  [ -n "${NEXUS[$name]+x}" ] || { echo "SKIP=$name UNMAPPED"; continue; }

  # split frontmatter / body
  fm="$(awk 'BEGIN{c=0} /^---$/{c++; next} c==1{print} c==2{exit}' "$dir/SKILL.md")"
  body="$(awk 'BEGIN{c=0} /^---$/{c++; next} c==2{print}' "$dir/SKILL.md")"

  name_v="$(echo "$fm" | sed -n 's/^name:\s*//p' | tr -d ' "')"
  desc_v="$(echo "$fm" | sed -n 's/^description:\s*//p')"
  sp_v="$(echo "$fm" | sed -n 's/^state-profile:\s*//p' | tr -d ' "')"
  nex_v="${NEXUS[$name]}"

  # rebuild canonical frontmatter
  out="---\nname: $name_v\ndescription: $desc_v\nstate-profile: $sp_v\n"
  [ -n "$nex_v" ] && out+="nexus: $nex_v\n"
  out+="---"

  printf '%b\n' "$out" > "$dir/SKILL.md"
  printf '%s\n' "$body" >> "$dir/SKILL.md"
  count=$((count+1))
  echo "UPDATED=$name NEXUS=${nex_v:-none}"
done

echo "MIGRATED=$count"
