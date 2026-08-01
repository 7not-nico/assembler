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

type Accumulator struct {
	value float64
}

func (s Accumulator) add(object float64) (Accumulator, error) {
	result, err := calc.Apply("+", s.value, object)
	return Accumulator{value: result}, err
}

func (s Accumulator) subtract(object float64) (Accumulator, error) {
	result, err := calc.Apply("-", s.value, object)
	return Accumulator{value: result}, err
}

func (s Accumulator) multiply(object float64) (Accumulator, error) {
	result, err := calc.Apply("*", s.value, object)
	return Accumulator{value: result}, err
}

func (s Accumulator) divide(object float64) (Accumulator, error) {
	result, err := calc.Apply("/", s.value, object)
	return Accumulator{value: result}, err
}

func (s Accumulator) power(object float64) (Accumulator, error) {
	result, err := calc.Apply("**", s.value, object)
	return Accumulator{value: result}, err
}

type MethodDispatch struct {
	scan    *bufio.Scanner
	methods map[string]func(Accumulator, float64) (Accumulator, error)
}

func (m *MethodDispatch) subject(prompt string) (Accumulator, bool) {
	for {
		fmt.Print(prompt)
		if !m.scan.Scan() {
			return Accumulator{}, false
		}
		line := strings.TrimSpace(m.scan.Text())
		if lib.IsExit(line) {
			return Accumulator{}, false
		}
		val, err := strconv.ParseFloat(line, 64)
		if err != nil {
			fmt.Println("  enter a number")
			continue
		}
		return Accumulator{value: val}, true
	}
}

func (m *MethodDispatch) object(prompt string) (float64, bool) {
	for {
		fmt.Print(prompt)
		if !m.scan.Scan() {
			return 0, false
		}
		line := strings.TrimSpace(m.scan.Text())
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

func (m *MethodDispatch) action(prompt string) (string, bool) {
	for {
		fmt.Print(prompt)
		if !m.scan.Scan() {
			return "", false
		}
		line := strings.TrimSpace(m.scan.Text())
		if lib.IsExit(line) {
			return "", false
		}
		if _, ok := m.methods[line]; ok {
			return line, true
		}
		fmt.Println("  choose: add | subtract | multiply | divide | power")
	}
}

func runMethod() {
	md := &MethodDispatch{
		scan: bufio.NewScanner(os.Stdin),
		methods: map[string]func(Accumulator, float64) (Accumulator, error){
			"add":      Accumulator.add,
			"subtract": Accumulator.subtract,
			"multiply": Accumulator.multiply,
			"divide":   Accumulator.divide,
			"power":    Accumulator.power,
		},
	}

	fmt.Println("  method calculator — subject.action(object)")
	fmt.Println("  actions: add | subtract | multiply | divide | power")
	fmt.Println("  exit / q to quit\n")

	subject, ok := md.subject("  subject? ")
	if !ok {
		return
	}

	for {
		method, ok := md.action("  action? (add | subtract | multiply | divide | power) ")
		if !ok {
			break
		}

		obj, ok := md.object("  object? ")
		if !ok {
			break
		}

		result, err := md.methods[method](subject, obj)
		if err != nil {
			fmt.Printf("  ✗ %v\n", err)
			continue
		}

		subject = result
		fmt.Printf("  = %s\n\n", lib.StripZero(subject.value))
	}
}
