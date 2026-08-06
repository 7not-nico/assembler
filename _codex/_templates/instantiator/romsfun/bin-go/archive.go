// Package main — archive: game-image archive primitives.
package main

import (
	"archive/zip"
	"fmt"
	"os"
	"regexp"
	"strconv"
	"strings"
)

// kind classifies a `file -b` type string: zip|7z|tar|rar|bare.
func kind(t string) string {
	switch {
	case strings.Contains(t, "Zip"), strings.Contains(t, "zip"):
		return "zip"
	case strings.Contains(t, "7-zip"), strings.Contains(t, "7z"):
		return "7z"
	case strings.Contains(t, "tar"):
		return "tar"
	case strings.Contains(t, "RAR"), strings.Contains(t, "rar"):
		return "rar"
	default:
		return "bare"
	}
}

// bareAcceptable reports whether a `file -b` type names a console ROM image.
func bareAcceptable(t string) bool {
	return strings.Contains(t, "ROM image") || strings.Contains(t, "ISO") ||
		strings.Contains(t, "filesystem") || strings.Contains(t, "Game Boy")
}

// imagePattern compiles the match pattern for a space-separated ext set.
func imagePattern(exts string) *regexp.Regexp {
	var esc []string
	for _, e := range split(exts) {
		esc = append(esc, regexp.QuoteMeta(e))
	}
	return regexp.MustCompile(`\.(` + strings.Join(esc, "|") + `)$`)
}

// firstImage returns the first archive member whose name ends in one of the
// image extensions; the ext set is space-separated.
func firstImage(path, exts string) (string, bool) {
	pat := imagePattern(exts)
	switch k := kind(typeOf(path)); k {
	case "zip":
		zr, err := zip.OpenReader(path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR unzip failed: %s\n", path)
			os.Exit(1)
		}
		defer zr.Close()
		for _, f := range zr.File {
			if pat.MatchString(f.Name) {
				return f.Name, true
			}
		}
	case "7z", "rar":
		out, err := run("7z", "l", "-slt", path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR 7z listing failed: %s\n", path)
			os.Exit(1)
		}
		for _, line := range strings.Split(out, "\n") {
			if rest, ok := strings.CutPrefix(line, "Path = "); ok && pat.MatchString(rest) {
				return rest, true
			}
		}
	case "tar":
		out, err := run("tar", "-tf", path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR tar listing failed: %s\n", path)
			os.Exit(1)
		}
		for _, line := range strings.Split(out, "\n") {
			if pat.MatchString(line) {
				return line, true
			}
		}
	}
	return "", false
}

// sizeInArchive returns the byte size of an archive member.
func sizeInArchive(path, image string) (int64, bool) {
	switch k := kind(typeOf(path)); k {
	case "zip":
		zr, err := zip.OpenReader(path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR unzip failed: %s\n", path)
			os.Exit(1)
		}
		defer zr.Close()
		for _, f := range zr.File {
			if f.Name == image {
				return int64(f.UncompressedSize64), true
			}
		}
	case "7z", "rar":
		out, err := run("7z", "l", "-slt", path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR 7z listing failed: %s\n", path)
			os.Exit(1)
		}
		cur := int64(0)
		for _, line := range strings.Split(out, "\n") {
			if rest, ok := strings.CutPrefix(line, "Size = "); ok {
				cur, _ = strconv.ParseInt(strings.TrimSpace(rest), 10, 64)
			} else if rest, ok := strings.CutPrefix(line, "Path = "); ok && rest == image {
				return cur, true
			}
		}
	case "tar":
		out, err := run("tar", "-tvf", path)
		if err != nil {
			fmt.Fprintf(os.Stderr, "ERROR tar listing failed: %s\n", path)
			os.Exit(1)
		}
		for _, line := range strings.Split(out, "\n") {
			if !strings.HasSuffix(line, image) {
				continue
			}
			f := split(line)
			if len(f) > 2 {
				if n, err := strconv.ParseInt(f[2], 10, 64); err == nil {
					return n, true
				}
			}
		}
	}
	return 0, false
}
