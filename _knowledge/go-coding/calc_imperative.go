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

func imperative(scan *bufio.Scanner, prompt string) (float64, bool) {
	for {
		fmt.Print(prompt)
		if !scan.Scan() {
			return 0, false
		}
		line := strings.TrimSpace(scan.Text())
		if lib.IsExit(line) {
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

func operator(scan *bufio.Scanner, prompt string) (string, bool) {
	for {
		fmt.Print(prompt)
		if !scan.Scan() {
			return "", false
		}
		line := strings.TrimSpace(scan.Text())
		if lib.IsExit(line) {
			return "", false
		}
		if calc.IsOperator(line) {
			return line, true
		}
		fmt.Println("  choose: +  -  *  /  **")
	}
}

func runImperative() {
	scan := bufio.NewScanner(os.Stdin)

	fmt.Println("  imperative calculator — subject ← action(subject, object)")
	fmt.Println("  operators: +  -  *  /  **")
	fmt.Println("  exit / q to quit\n")

	var subject float64

	val, ok := imperative(scan, "  subject? ")
	if !ok {
		return
	}
	subject = val

	for {
		op, ok := operator(scan, "  action? (+ - * / **) ")
		if !ok {
			break
		}

		object, ok := imperative(scan, "  object? ")
		if !ok {
			break
		}

		result, err := calc.Apply(op, subject, object)
		if err != nil {
			fmt.Printf("  ✗ %v\n", err)
			continue
		}
		subject = result

		fmt.Printf("  = %s\n\n", lib.StripZero(subject))
	}
}
