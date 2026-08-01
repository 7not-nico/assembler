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

type cmd struct {
	op    string
	value float64
}

// actions — channel worker dispatch table.
// GO.OBJECT: function values map op symbol to accumulator update.
var actions = map[string]func(acc *float64, v float64){
	"+": func(acc *float64, v float64) { *acc += v },
	"-": func(acc *float64, v float64) { *acc -= v },
	"*": func(acc *float64, v float64) { *acc *= v },
	"/": func(acc *float64, v float64) { *acc /= v },
}

func runCHN() {
	input := make(chan cmd)
	output := make(chan float64)

	go func() {
		var acc float64

		for c := range input {
			switch c.op {
			case "=":
				output <- acc
			case "+", "-", "*", "/":
				if c.op == "/" && c.value == 0 {
					fmt.Println("  ✗ division by zero")
					continue
				}
				// GO.ACTION: table dispatch — no conditional operator logic
				actions[c.op](&acc, c.value)
			case "q":
				close(output)
				return
			}
		}
	}()

	scan := bufio.NewScanner(os.Stdin)

	fmt.Println("  CHN calculator — channel-based concurrent")
	fmt.Println("  send:  <op> <value>   e.g. + 5")
	fmt.Println("  read:  =              prints accumulator")
	fmt.Println("  q to quit\n")

	for {
		fmt.Print("  > ")
		if !scan.Scan() {
			input <- cmd{op: "q"}
			break
		}
		line := strings.TrimSpace(scan.Text())
		if line == "" {
			continue
		}
		if lib.IsExit(line) {
			input <- cmd{op: "q"}
			break
		}

		tokens := strings.Fields(line)
		if len(tokens) == 0 {
			continue
		}

		switch tokens[0] {
		case "=":
			input <- cmd{op: "="}
			val := <-output
			fmt.Printf("  = %s\n", lib.StripZero(val))
		default:
			if len(tokens) != 2 {
				fmt.Println("  format: + 5   or   =   or   q")
				continue
			}
			op := tokens[0]
			if !calc.IsOperator(op) {
				fmt.Printf("  unknown op: %s\n", op)
				continue
			}
			val, err := strconv.ParseFloat(tokens[1], 64)
			if err != nil {
				fmt.Println("  enter a number")
				continue
			}
			input <- cmd{op: op, value: val}
		}
	}
}
