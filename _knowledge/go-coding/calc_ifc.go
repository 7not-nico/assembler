package main

import (
	"bufio"
	"fmt"
	"go-coding/calc"
	"go-coding/lib"
	"os"
	"strconv"
	"strings"
)

// OBJECT — an interface value holding a (type, value) pair.
// GO.OBJECT §Interface: "an interface value holds a (type, value) pair."
// Declared at top of file — values flow through the computation.
type operand interface{}

// SUBJECT — the accumulator as a struct.
// Declared after OBJECT — storage location receiving values.
type Subject struct {
	value float64
}

// parseObject — OBJECT: parse a string into an interface value.
// GO.OBJECT §Types: int64 and float64 are distinct typed values.
func parseObject(s string) (operand, bool) {
	if val, err := strconv.ParseInt(s, 10, 64); err == nil {
		return val, true
	}
	if val, err := strconv.ParseFloat(s, 64); err == nil {
		return val, true
	}
	return nil, false
}

// action — ACTION: read operator symbol or "=" print command.
// IFC statement structure: subject → action → object.
func action(scan *bufio.Scanner, prompt string) (string, bool) {
	for {
		fmt.Print(prompt)
		if !scan.Scan() {
			return "", false
		}
		line := strings.TrimSpace(scan.Text())
		if lib.IsExit(line) {
			return "", false
		}
		if line == "=" || calc.IsOperator(line) {
			return line, true
		}
		fmt.Println("  choose: +  -  *  /  **")
	}
}

func runIFC() {
	scan := bufio.NewScanner(os.Stdin)

	fmt.Println("  ifc calculator — subject → action → object (interface dispatch)")
	fmt.Println("  operators: +  -  *  /  **")
	fmt.Println("  = prints accumulator   q to quit\n")

	var subject Subject

	// SUBJECT: read until valid or exit.
	for {
		fmt.Print("  subject? ")
		if !scan.Scan() {
			return
		}
		line := strings.TrimSpace(scan.Text())
		if lib.IsExit(line) {
			return
		}
		raw, ok := parseObject(line)
		if !ok {
			fmt.Println("  enter a number")
			continue
		}
		// GO.ACTION: type switch — dispatch by concrete type
		switch v := raw.(type) {
		case int64:
			subject = Subject{value: float64(v)}
		case float64:
			subject = Subject{value: v}
		default:
			fmt.Println("  unsupported type")
			continue
		}
		break
	}

	for {
		// ACTION: read operator until valid or exit.
		op, ok := action(scan, "  action? (+ - * / **) ")
		if !ok {
			break
		}
		if op == "=" {
			fmt.Printf("  = %s\n", lib.StripZero(subject.value))
			continue
		}

		// OBJECT: read operand until valid or exit.
		objStr, ok := lib.ReadLine(scan, "  object? ")
		if !ok {
			break
		}
		raw, ok := parseObject(objStr)
		if !ok {
			fmt.Println("  enter a number")
			continue
		}
		// GO.ACTION: type switch — extract concrete numeric value
		// GO.OBJECT §Interface: "interface value holds (type, value) pair"
		var object float64
		switch v := raw.(type) {
		case int64:
			object = float64(v)
		case float64:
			object = v
		default:
			fmt.Println("  unsupported type for arithmetic")
			continue
		}

		// GO.ACTION: expression evaluation through shared functional core
		result, err := calc.Apply(op, subject.value, object)
		if err != nil {
			fmt.Printf("  ✗ %v\n", err)
			continue
		}
		subject = Subject{value: result}

		fmt.Printf("  = %s\n", lib.StripZero(subject.value))
	}
}
