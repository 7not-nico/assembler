// Package main — core: console validation, filename slugify, image checks.
package main

import "strings"

// validConsole reports whether name is an accepted romsfun console slug.
func validConsole(s *Store, name string) bool {
	for _, c := range split(value(s, "CONSOLE_VALID")) {
		if c == name {
			return true
		}
	}
	return false
}

// consoles lists the accepted console slugs, comma-joined.
func consoles(s *Store) string {
	return strings.Join(split(value(s, "CONSOLE_VALID")), ", ")
}

// slugify converts a filename to a lowercase dash-slug; the single trailing
// extension preserves. Byte-wise ASCII handling matches the shared binary.
func slugify(input string) string {
	base := input
	ext := ""
	if dot := strings.LastIndexByte(input, '.'); dot >= 0 {
		base = input[:dot]
		ext = input[dot+1:]
	}
	var b strings.Builder
	dash := false
	for i := 0; i < len(base); i++ {
		c := base[i]
		if c >= 'A' && c <= 'Z' {
			c += 'a' - 'A'
		}
		keep := (c >= 'a' && c <= 'z') || (c >= '0' && c <= '9')
		if keep {
			b.WriteByte(c)
			dash = false
		} else if !dash {
			b.WriteByte('-')
			dash = true
		}
	}
	slug := strings.Trim(b.String(), "-")
	if ext != "" {
		return slug + "." + ext
	}
	return slug
}

// isImage reports whether ext appears in the seed IMAGE_EXTS set.
func isImage(s *Store, ext string) bool {
	for _, e := range split(value(s, "IMAGE_EXTS")) {
		if e == ext {
			return true
		}
	}
	return false
}
