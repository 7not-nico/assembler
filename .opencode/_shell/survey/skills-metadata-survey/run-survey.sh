#!/usr/bin/env bash
# run-survey.sh — orchestrator: s01 frontmatter scan → s02 nexus map
# Survey workflow: .opencode/_shell/survey/skills-metadata-survey/
set -uo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "STAGE=s01-frontmatter-scan"
bash "$DIR/s01-frontmatter-scan.sh" || exit 1
echo
echo "STAGE=s02-nexus-map"
bash "$DIR/s02-nexus-map.sh" || exit 1
echo
echo "SURVEY=complete"
