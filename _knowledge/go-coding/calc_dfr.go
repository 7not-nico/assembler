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

// OBJECT — one deferred step: operator and operand value.
// Declared at top of file — values flow through the computation.
type step struct {
	op  string
	val float64
}

// SUBJECT — the accumulator variable.
// Declared after OBJECT — storage location receiving values.
type accumulator float64

func runDFR() {
	scan := bufio.NewScanner(os.Stdin)

	fmt.Println("  DFR calculator — deferred evaluation (defer LIFO)")
	fmt.Println("  enter:  <op> <value>  e.g.  + 5")
	fmt.Println("  blank line or 'run' executes ALL deferred ops (LIFO)")
	fmt.Println("  q to quit\n")

	for {
		// OBJECT: collect a batch of operand steps
		var steps []step

		for {
			fmt.Print("  > ")
			if !scan.Scan() {
				return
			}
			line := strings.TrimSpace(scan.Text())
			if lib.IsExit(line) {
				return
			}
			if line == "" || line == "run" {
				break
			}

			tokens := strings.Fields(line)
			if len(tokens) != 2 {
				fmt.Println("  format: <op> <value>")
				continue
			}

			op := tokens[0]
			if !calc.IsOperator(op) {
				fmt.Println("  operators: +  -  *  /  **")
				continue
			}

			val, err := strconv.ParseFloat(tokens[1], 64)
			if err != nil {
				fmt.Println("  enter a number")
				continue
			}

			steps = append(steps, step{op, val})
		}

		if len(steps) == 0 {
			continue
		}

		// ACTION: deferred LIFO execution via function dispatch.
		// SUBJECT (acc) captured by reference; OBJECT (val) by value.
		func() {
			var acc float64

			defer func() {
				fmt.Printf("  = %s\n", lib.StripZero(acc))
			}()

			for _, s := range steps {
				s := s
				defer func() {
					result, err := calc.Apply(s.op, acc, s.val)
					if err != nil {
						fmt.Printf("  ✗ %v\n", err)
						return
					}
					acc = result
				}()
			}
		}()
	}
}
