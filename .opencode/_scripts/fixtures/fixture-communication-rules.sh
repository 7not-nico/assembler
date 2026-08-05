#!/usr/bin/env bash
# exports: main
# purity: io
# depends-on: .opencode/entities
# ring: 2 (LOCAL-READ) — audits rule prose against communication rules
# fixture-communication-rules.sh — audits rule prose against communication rules
# Contract: KEY=value lines; last line carries RESULT=pass|fail:count
# Style: bash, atomic units (MAX.ATOMIC.CONCERN)
# Checks: -ed verb forms, gerunds, action-noun suffixes in prose
# Exempts: backticks, quotes, bold labels, headings, fences, label prefixes,
# hyphenated compounds, and parenthesized suffix-name lists
set -u

cd "$(dirname "$0")"
ROOT="$(cd ../../.. && pwd)"
RULES_DIR="$ROOT/.opencode/rules"

# Whitelists hold root nouns, entity labels, and rule-name echoes; they name
# things, not actions. Hyphen stripping removes scope labels and compounds.
ED_EXEMPT="directed undirected completed"
GERUND_EXEMPT="beginning during engineering finding gapping meaning pending ring writing"
NOMINAL_EXEMPT="action assignment association classification cognition communication composition convention decision definition deletion derivation description direction document duration element entity exception expansion explanation function glance illustration instruction judgment mention notation operation position proportion proposition requirement section segment session situation specification statement violation"

# strip_exempt — blank exempt contexts from a rule file's prose
strip_exempt() {
  sed -E '
    /^[[:space:]]*```/,/^[[:space:]]*```/d
    /^[[:space:]]*#/d
    s/`[^`]*`/ /g
    s/"[^"]*"/ /g
    s/\*\*[^*]+\*\*/ /g
    s/\b[a-zA-Z0-9]+(-[a-zA-Z0-9]+)+\b/ /g
    s/\(-[a-z]+(, -[a-z]+)*\)/ /g
    s/^(Scope|Composes with|Aligns with|Rule|Status|Format|Pattern|Convention):[[:space:]]*//
  '
}

# filter_whitelist — drop tokens present in a space-separated whitelist
filter_whitelist() {
  local wl=" $1 "
  while IFS= read -r tok; do
    [[ -z "$tok" ]] && continue
    case "$wl" in
      *" $tok "*) ;;
      *) printf '%s\n' "$tok" ;;
    esac
  done
}

# scan_tokens — distinct non-whitelisted tokens of one class
scan_tokens() { # $1 pattern, $2 whitelist
  grep -oE "$1" | sort -u | filter_whitelist "$2"
}

sanitize() {
  printf '%s' "$1" | tr -c 'A-Za-z0-9' '_'
}

# --- composition (side-effect boundary) ---

if [[ ! -d "$RULES_DIR" ]]; then
  echo "RULES=0"
  echo "RESULT=skip:none"
  exit 0
fi

ed_total=0
ger_total=0
nom_total=0
files_violated=0
all_ed=""
all_ger=""
all_nom=""
violation_lines=""

while IFS= read -r file; do
  name="$(basename "$file")"
  prose="$(strip_exempt < "$file")"
  ed="$(printf '%s\n' "$prose" | scan_tokens '\b[a-z]+ed\b' "$ED_EXEMPT")"
  ger="$(printf '%s\n' "$prose" | scan_tokens '\b[a-z]+ing\b' "$GERUND_EXEMPT")"
  nom="$(printf '%s\n' "$prose" | scan_tokens '\b[a-z]+(tion|sion|ment|ance|ion)\b' "$NOMINAL_EXEMPT")"

  if [[ -z "$ed" && -z "$ger" && -z "$nom" ]]; then
    continue
  fi
  files_violated=$((files_violated + 1))
  [[ -n "$ed" ]] && { ed_total=$((ed_total + $(printf '%s\n' "$ed" | wc -l))); all_ed="$all_ed $ed"; }
  [[ -n "$ger" ]] && { ger_total=$((ger_total + $(printf '%s\n' "$ger" | wc -l))); all_ger="$all_ger $ger"; }
  [[ -n "$nom" ]] && { nom_total=$((nom_total + $(printf '%s\n' "$nom" | wc -l))); all_nom="$all_nom $nom"; }

  parts=""
  [[ -n "$ed" ]] && parts="${parts}ed:$(printf '%s\n' "$ed" | tr '\n' ',')"
  [[ -n "$ger" ]] && parts="${parts}ger:$(printf '%s\n' "$ger" | tr '\n' ',')"
  [[ -n "$nom" ]] && parts="${parts}nom:$(printf '%s\n' "$nom" | tr '\n' ',')"
  parts="${parts%,}"
  violation_lines="${violation_lines}VIOLATION_$(sanitize "$name")=$parts
"
done < <(find "$RULES_DIR" -maxdepth 1 -name '*.md' | sort)

total=$((ed_total + ger_total + nom_total))

echo "RULES=$(find "$RULES_DIR" -maxdepth 1 -name '*.md' | wc -l)"
echo "VIOLATED=$files_violated"
echo "ED=$ed_total"
echo "GERUNDS=$ger_total"
echo "NOMINALS=$nom_total"
echo "TOTAL=$total"
echo "FLAGGED_ED=$(printf '%s\n' $all_ed | sort -u | tr '\n' ',' | sed 's/,$//')"
echo "FLAGGED_GERUNDS=$(printf '%s\n' $all_ger | sort -u | tr '\n' ',' | sed 's/,$//')"
echo "FLAGGED_NOMINALS=$(printf '%s\n' $all_nom | sort -u | tr '\n' ',' | sed 's/,$//')"
printf '%s' "$violation_lines"
echo "RESULT=$([[ $total -eq 0 ]] && echo pass || echo fail):$total"
exit $([[ $total -eq 0 ]] && echo 0 || echo 1)
