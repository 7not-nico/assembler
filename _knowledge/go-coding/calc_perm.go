package main

import (
	"bufio"
	"fmt"
	"os"
	"strings"

	"go-coding/calc"
	"go-coding/lib"
)

// Role — syntactic role in the statement.
type Role int

const (
	RoleSubject Role = iota // accumulator
	RoleObject              // operand
	RoleAction              // operator
)

// orders — statement structure per variant.
// The variant name IS the syntactic order of roles.
var orders = map[string][]Role{
	"soa": {RoleSubject, RoleObject, RoleAction},
	"sao": {RoleSubject, RoleAction, RoleObject},
	"aos": {RoleAction, RoleObject, RoleSubject},
	"aso": {RoleAction, RoleSubject, RoleObject},
	"osa": {RoleObject, RoleSubject, RoleAction},
	"oas": {RoleObject, RoleAction, RoleSubject},
}

// prompts — prompt text per role.
var prompts = map[Role]string{
	RoleSubject: "subject? ",
	RoleObject:  "object? ",
	RoleAction:  "action? (+ - * / **) ",
}

// runPositional — shell for all 6 positional statement structures.
// The order of roles in the statement defines the variant.
func runPositional(name string) {
	scan := bufio.NewScanner(os.Stdin)
	order := orders[name]

	fmt.Printf("  %s calculator — %s\n", strings.ToUpper(name), statementLabel(order))
	fmt.Println("  operators: +  -  *  /  **")
	fmt.Println("  q to quit\n")

	for {
		var subject, object float64
		var op string

		for _, role := range order {
			// Each role loops until valid input or exit.
			for {
				fmt.Print("  " + prompts[role])
				if !scan.Scan() {
					return
				}
				line := strings.TrimSpace(scan.Text())
				if lib.IsExit(line) {
					return
				}

				ok := true
				switch role {
				case RoleSubject:
					v, err := calc.ParseValue(line)
					if err != nil {
						fmt.Println("  enter a number")
						ok = false
						break
					}
					subject = v
				case RoleObject:
					v, err := calc.ParseValue(line)
					if err != nil {
						fmt.Println("  enter a number")
						ok = false
						break
					}
					object = v
				case RoleAction:
					if !calc.IsOperator(line) {
						fmt.Println("  choose: +  -  *  /  **")
						ok = false
						break
					}
					op = line
				}
				if ok {
					break
				}
			}
		}

		// GO.ACTION: semantic core invariant — Apply(action, subject, object)
		result, err := calc.Apply(op, subject, object)
		if err != nil {
			fmt.Printf("  ✗ %v\n", err)
			continue
		}
		fmt.Printf("  = %s\n\n", lib.StripZero(result))
	}
}

// statementLabel — human-readable statement structure.
func statementLabel(order []Role) string {
	names := map[Role]string{
		RoleSubject: "subject",
		RoleObject:  "object",
		RoleAction:  "action",
	}
	parts := make([]string, len(order))
	for i, r := range order {
		parts[i] = names[r]
	}
	return strings.Join(parts, " → ")
}

func runSOA() { runPositional("soa") }
func runSAO() { runPositional("sao") }
func runAOS() { runPositional("aos") }
func runASO() { runPositional("aso") }
func runOSA() { runPositional("osa") }
func runOAS() { runPositional("oas") }
