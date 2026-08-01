// Package frontmatter parses entity metadata — leading frontmatter or
// trailing backmatter (the encyclopedic format: prose body, then --- block).
// ring: 0 (PURE) — no I/O.
package frontmatter

import (
	"regexp"
	"strings"
)

// Frontmatter holds the metadata fields the audit toolchain consumes.
type Frontmatter struct {
	ID       string
	Title    string
	Source   string
	Precedes []string
	Related  []string
	Tags     []string
}

var (
	// (?s) dotall: . matches newline so (.*?) spans the multi-line block.
	frontRe = regexp.MustCompile(`(?s)\A---\s*\n(.*?)\n---\s*\n`)
	backRe  = regexp.MustCompile(`(?s)(?:^|\n)---\s*\n(.*?)\n---\s*$`)
)

// ParseMetadata extracts metadata from leading frontmatter or trailing
// backmatter. Returns nil when neither format appears.
func ParseMetadata(text string) *Frontmatter {
	var block string
	if m := frontRe.FindStringSubmatch(text); m != nil {
		block = m[1]
	} else if m := backRe.FindStringSubmatch(text); m != nil {
		block = m[1]
	} else {
		return nil
	}
	return parseBlock(block)
}

func parseBlock(block string) *Frontmatter {
	lines := strings.Split(block, "\n")
	fm := &Frontmatter{}

	scalar := func(key string) (string, bool) {
		for _, line := range lines {
			trimmed := strings.TrimSpace(line)
			if strings.HasPrefix(trimmed, key+":") {
				return clean(strings.TrimSpace(strings.TrimPrefix(trimmed, key+":"))), true
			}
		}
		return "", false
	}

	blockList := func(key string) []string {
		var out []string
		for i, line := range lines {
			trimmed := strings.TrimSpace(line)
			if !strings.HasPrefix(trimmed, key+":") {
				continue
			}
			rest := strings.TrimSpace(strings.TrimPrefix(trimmed, key+":"))
			switch {
			case rest == "":
				// block form: following indented "- item" lines
				for j := i + 1; j < len(lines); j++ {
					item := strings.TrimSpace(lines[j])
					if strings.HasPrefix(item, "- ") {
						out = append(out, clean(strings.TrimPrefix(item, "- ")))
					} else if item != "" {
						break
					}
				}
			case strings.HasPrefix(rest, "[") && strings.HasSuffix(rest, "]"):
				inner := strings.TrimSuffix(strings.TrimPrefix(rest, "["), "]")
				for _, part := range strings.Split(inner, ",") {
					if v := clean(part); v != "" {
						out = append(out, v)
					}
				}
			default:
				out = append(out, clean(rest))
			}
			return out
		}
		return nil
	}

	if v, ok := scalar("id"); ok {
		fm.ID = v
	}
	if v, ok := scalar("title"); ok {
		fm.Title = v
	}
	if v, ok := scalar("source"); ok {
		fm.Source = v
	}
	fm.Precedes = blockList("precedes")
	fm.Related = blockList("related")
	fm.Tags = blockList("tags")
	return fm
}

func clean(s string) string {
	s = strings.TrimSpace(s)
	if len(s) >= 2 && ((s[0] == '"' && s[len(s)-1] == '"') || (s[0] == '\'' && s[len(s)-1] == '\'')) {
		s = s[1 : len(s)-1]
	}
	return s
}
