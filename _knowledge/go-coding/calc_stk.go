package main

import (
	"bufio"
	"fmt"
	"os"

	"go-coding/calc"
	"go-coding/lib"
	"strconv"
	"strings"
)

func runSTK() {
	scan := bufio.NewScanner(os.Stdin)

	var stack []float64

	fmt.Println("  STK calculator — stack-based (Forth-style)")
	fmt.Println("  push numbers, operators (+ - * / **) act on stack")
	fmt.Println("  . prints top   clear resets stack   q to quit\n")

	for {
		fmt.Print("  > ")
		if !scan.Scan() {
			break
		}
		line := strings.TrimSpace(scan.Text())
		if line == "" {
			continue
		}
		if lib.IsExit(line) {
			break
		}

		tokens := strings.Fields(line)

		for _, token := range tokens {
			switch token {
			case "+", "-", "*", "/", "**":

				if len(stack) < 2 {
					fmt.Println("  ✗ stack underflow")
					continue
				}

				b := stack[len(stack)-1]
				a := stack[len(stack)-2]

				if token == "/" && b == 0 {
					fmt.Println("  ✗ division by zero")
					continue
				}

				stack = stack[:len(stack)-1]
				stack = stack[:len(stack)-1]

				result, err := calc.Apply(token, a, b)
				if err != nil {
					fmt.Printf("  ✗ %v\n", err)
					continue
				}

				stack = append(stack, result)

			case ".":

				if len(stack) == 0 {
					fmt.Println("  ✗ stack empty")
					continue
				}
				fmt.Printf("  = %s\n", lib.StripZero(stack[len(stack)-1]))

			case "clear", "clr":

				stack = nil
				fmt.Println("  stack cleared")

			default:

				val, err := strconv.ParseFloat(token, 64)
				if err != nil {
					fmt.Printf("  ✗ unknown word: %s\n", token)
					continue
				}
				stack = append(stack, val)
			}
		}
	}
}
