package lib

import (
	"bufio"
	"fmt"
	"strconv"
	"strings"
)

// ReadValue — reads a float64 value from the scanner with prompt.
// Returns false on exit or EOF.
func ReadValue(scan *bufio.Scanner, prompt string) (float64, bool) {
	for {
		fmt.Print(prompt)
		if !scan.Scan() {
			return 0, false
		}
		line := strings.TrimSpace(scan.Text())
		if IsExit(line) {
			return 0, false
		}
		val, err := strconv.ParseFloat(line, 64)
		if err != nil {
			fmt.Println("  enter a number")
			continue
		}
		return val, true
	}
}

// ReadOp — reads an operator symbol from the scanner with prompt.
// Returns false on exit or EOF.
func ReadOp(scan *bufio.Scanner, prompt string) (string, bool) {
	for {
		fmt.Print(prompt)
		if !scan.Scan() {
			return "", false
		}
		line := strings.TrimSpace(scan.Text())
		if IsExit(line) {
			return "", false
		}
		switch line {
		case "+", "-", "*", "/", "**":
			return line, true
		default:
			fmt.Println("  choose: +  -  *  /  **")
		}
	}
}

// ReadLine — reads a trimmed line from the scanner.
func ReadLine(scan *bufio.Scanner, prompt string) (string, bool) {
	fmt.Print(prompt)
	if !scan.Scan() {
		return "", false
	}
	line := strings.TrimSpace(scan.Text())
	if IsExit(line) {
		return "", false
	}
	return line, true
}
