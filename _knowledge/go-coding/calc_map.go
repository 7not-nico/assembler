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

func runMAP() {
	scan := bufio.NewScanner(os.Stdin)

	fmt.Println("  MAP calculator — functional reduce")
	fmt.Println("  format: val,val,... + - * / **")
	fmt.Println("  example:  1,2,3 + * /")
	fmt.Println("  meaning:  ((0 + 1) * 2) / 3")
	fmt.Println("  q to quit\n")

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

		parts := strings.Fields(line)
		if len(parts) < 2 {
			fmt.Println("  format: val,val,... + - * / **")
			continue
		}

		valStrs := strings.Split(parts[0], ",")
		objects := make([]float64, 0, len(valStrs))
		for _, s := range valStrs {
			s = strings.TrimSpace(s)
			if s == "" {
				continue
			}
			val, err := strconv.ParseFloat(s, 64)
			if err != nil {
				fmt.Printf("  invalid number: %s\n", s)
				continue
			}
			objects = append(objects, val)
		}

		if len(objects) == 0 {
			fmt.Println("  enter at least one operand")
			continue
		}

		// GO.OBJECT: operator symbols — validated against calc.Operators table
		ops := make([]string, 0, len(parts)-1)
		for i := 1; i < len(parts); i++ {
			if !calc.IsOperator(parts[i]) {
				fmt.Printf("  unknown operator: %s\n", parts[i])
				continue
			}
			ops = append(ops, parts[i])
		}

		if len(ops) == 0 {
			fmt.Println("  enter at least one operator")
			continue
		}

		for len(objects) < len(ops) {
			objects = append(objects, 0)
		}
		objects = objects[:len(ops)]

		// GO.ACTION: reduce — sequential function application
		// subject starts at 0.0 (zero value), each action updates it
		result, err := calc.Reduce(ops, objects)
		if err != nil {
			fmt.Printf("  ✗ %v\n", err)
			continue
		}
		fmt.Printf("  = %s\n", lib.StripZero(result))
	}
}
