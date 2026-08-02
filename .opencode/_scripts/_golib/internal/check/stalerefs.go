// Stale cross-reference check — detect references to non-existent entity IDs
// in .md files across the project.
// ring: 2 (LOCAL-READ) — scans all .md files via filepath.WalkDir.
package check

import (
	"os"
	"path/filepath"
	"regexp"
	"strings"

	"assembler/scripts/golib/internal/entity"
	"assembler/scripts/golib/internal/paths"
	"assembler/scripts/golib/internal/violation"
)

// Segments must end in an alphanumeric — trailing sentence periods ("PROT.X.") are
// not captured, so existing IDs with a following dot no longer false-positive.
var entityPattern = regexp.MustCompile(`\b(PROT|PAT|NEX|ILL|REF|MAX|SPEC|PER|COG|CON|DEF|TERM|SKL|CMD|RUL|PRE|ABS|LING|BIO|CHE|TAX|ML|INV|APO|MAN|ARC|NOTE)\.[A-Z][A-Z0-9]*(?:\.[A-Z0-9]+)*`)

var falsePositivePatterns = []string{
	"pat.no.env", "pat.file.as", "pat.no.relative", "pat.no.shared",
	"pat.patlib.query", "pat.study.after", "pat.schema.as",
	"pat.yaml.inline", "pat.read.vs",
	"ill.entity.pipeline", "nex.entity.pipeline",
	"prot.meta.project.structure", "prot.meta.toon",
}

func isFalsePositive(id string) bool {
	lower := strings.ToLower(id)
	for _, pattern := range falsePositivePatterns {
		if strings.Contains(lower, pattern) {
			return true
		}
	}
	return false
}

// CheckStaleRefs scans project .md files for entity-ID references that do not
// exist in the current entity set.
func CheckStaleRefs(entries []entity.EntityEntry) []violation.Fault {
	var faults []violation.Fault
	known := entity.IdentifierSet(entries)

	root := paths.Root()
	_ = filepath.WalkDir(root, func(path string, d os.DirEntry, err error) error {
		if err != nil {
			return nil
		}
		if d.IsDir() {
			name := d.Name()
			if name == "target" || name == "node_modules" || name == ".git" {
				return filepath.SkipDir
			}
			return nil
		}
		if !strings.HasSuffix(d.Name(), ".md") {
			return nil
		}
		content, err := os.ReadFile(path)
		if err != nil {
			return nil
		}
		flagged := make(map[string]struct{})
		for _, match := range entityPattern.FindAllString(string(content), -1) {
			if strings.Count(match, ".") < 2 {
				continue
			}
			if _, ok := known[match]; ok {
				continue
			}
			if isFalsePositive(match) {
				continue
			}
			if _, seen := flagged[match]; seen {
				continue
			}
			flagged[match] = struct{}{}
			rel, _ := filepath.Rel(root, path)
			faults = append(faults, violation.Fault{
				ID:      match,
				Type:    "crossref",
				Field:   "reference",
				Value:   rel,
				Problem: "potential stale reference to non-existent entity",
			})
		}
		return nil
	})
	return faults
}
