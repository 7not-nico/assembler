package lib

import (
	"fmt"
	"strings"
)

// StripZero — removes ".0" suffix for clean integer display.
func StripZero(val float64) string {
	s := fmt.Sprintf("%v", val)
	if strings.HasSuffix(s, ".0") {
		return s[:len(s)-2]
	}
	return s
}
