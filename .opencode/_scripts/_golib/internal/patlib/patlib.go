// Package patlib routes PATLIB entity IDs — prefix to type map, ID shape.
// ring: 0 (PURE) — no I/O.
package patlib

import (
	"regexp"
	"strings"
)

// prefixToType maps entity ID prefix to entity type directory name.
var prefixToType = map[string]string{
	"COG": "cognitions", "CON": "concepts",
	"DEF": "definitions", "TAX": "taxonomies",
	"TERM": "terms", "IDENTITY": "identities",
	"BIO": "biology", "CHE": "chemistry",
	"MAX": "maxims", "ABS": "abstractions",
	"ALG": "algorithms", "LING": "linguistics",
	"RUL": "rules", "NEX": "nexus",
	"PROT": "protocols", "PAT": "patterns",
	"ILL": "illustrations", "REF": "references",
	"PER": "persons", "PRE": "precepts",
	"SPEC": "specifications", "INV": "investigations",
	"APO": "apologias", "MAN": "manifests",
	"ARC": "archives", "NOTE": "notes",
}

var (
	idPrefixRe  = regexp.MustCompile(`\A([A-Z]{2,})((?:\.[A-Z][A-Z0-9.\/-]*)+)`)
	idShapeRe   = regexp.MustCompile(`^(PROT|PAT|NEX|ILL|REF|MAX|SPEC|PER|COG|CON|DEF|TERM|SKL|CMD|RUL|PRE|ABS|LING|BIO|CHE|TAX|ML|INV|APO|MAN|ARC|NOTE)\.[A-Z][A-Z0-9]*(\.[A-Z0-9]+)+$`)
	knownPrefix = regexp.MustCompile(`^(PROT|PAT|NEX|ILL|REF|MAX|SPEC|PER|COG|CON|DEF|TERM|SKL|CMD|RUL|PRE|ABS|LING|BIO|CHE|TAX|ML|INV|APO|MAN|ARC|NOTE)\.`)
)

// IDPrefix extracts the leading prefix of a PATLIB ID, e.g. "PROT.TOOL" -> "PROT".
func IDPrefix(id string) string {
	if m := idPrefixRe.FindStringSubmatch(id); m != nil {
		return m[1]
	}
	return ""
}

// IDToType maps an entity ID to its type name, e.g. "PROT.TOOL.CUSTOM" -> "protocols".
func IDToType(id string) (string, bool) {
	prefix := IDPrefix(id)
	if prefix == "" {
		return "", false
	}
	entityType, ok := prefixToType[prefix]
	return entityType, ok
}

// IsIDShape reports whether a string looks like a dotted entity ID
// (used by the source check to skip citation strings).
func IsIDShape(s string) bool { return idShapeRe.MatchString(s) }

// IsKnownPrefix reports whether a string starts with a registered ID prefix.
func IsKnownPrefix(s string) bool { return knownPrefix.MatchString(s) }

// EntityPrefixToType returns the prefix-to-type map (read-only view).
func EntityPrefixToType() map[string]string {
	out := make(map[string]string, len(prefixToType))
	for k, v := range prefixToType {
		out[k] = v
	}
	return out
}

// EntityTypeFromPrefix resolves a directory name from a prefix.
func EntityTypeFromPrefix(prefix string) string {
	if v, ok := prefixToType[strings.ToUpper(prefix)]; ok {
		return v
	}
	return ""
}
