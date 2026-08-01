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

// OBJECT — a thunk: delayed computation returning a value.
// GO.OBJECT §Function literals: closures capture surrounding scope.
type thunk func() float64

// lit — OBJECT: wraps an immediate value as a thunk.
func lit(v float64) thunk {
	return func() float64 { return v }
}

// bin — OBJECT: thunk combinator from calc.Operator.
// GO.ACTION: expression evaluation deferred until forced.
func bin(op calc.Operator) func(a, b thunk) thunk {
	return func(a, b thunk) thunk {
		return func() float64 {
			result, err := op(a(), b())
			if err != nil {
				panic(err.Error())
			}
			return result
		}
	}
}

// thunkBin — ACTION: dispatch table mapping op symbol to thunk combinator.
// GO.OBJECT: function values map operator symbol to combinator.
var thunkBin = map[string]func(a, b thunk) thunk{
	"+":  bin(calc.Operators["+"]),
	"-":  bin(calc.Operators["-"]),
	"*":  bin(calc.Operators["*"]),
	"/":  bin(calc.Operators["/"]),
	"**": bin(calc.Operators["**"]),
}

// SUBJECT — the EVL state: current thunk and named thunk store.
type EVL struct {
	current thunk
	thunks  map[string]thunk
}

func (e *EVL) litOp(val float64) {
	e.current = lit(val)
}

func (e *EVL) binaryOp(op string, val float64) {
	if e.current == nil {
		e.current = lit(val)
		return
	}
	right := lit(val)
	// GO.ACTION: function dispatch — no switch, table lookup
	if fn, ok := thunkBin[op]; ok {
		e.current = fn(e.current, right)
	}
}

func (e *EVL) force() (float64, error) {
	if e.current == nil {
		return 0, fmt.Errorf("no expression built")
	}

	defer func() {
		if r := recover(); r != nil {
			fmt.Printf("  ✗ %v\n", r)
		}
	}()
	return e.current(), nil
}

func runEVL() {
	scan := bufio.NewScanner(os.Stdin)
	evl := &EVL{thunks: make(map[string]thunk)}

	fmt.Println("  EVL calculator — lazy evaluation (thunks)")
	fmt.Println("  build: <op> <val>   e.g. + 5  (builds expression tree lazily)")
	fmt.Println("  force               evaluates the accumulated thunk")
	fmt.Println("  lit <val>           sets a literal value")
	fmt.Println("  store <name>        stores current thunk under name")
	fmt.Println("  recall <name>       loads named thunk as current")
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

		tokens := strings.Fields(line)
		if len(tokens) == 0 {
			continue
		}

		switch tokens[0] {
		case "lit":
			if len(tokens) < 2 {
				fmt.Println("  usage: lit <val>")
				continue
			}
			val, err := strconv.ParseFloat(tokens[1], 64)
			if err != nil {
				fmt.Println("  enter a number")
				continue
			}
			evl.litOp(val)
			fmt.Printf("  = %s\n", lib.StripZero(val))

		case "+", "-", "*", "/", "**":
			if len(tokens) < 2 {
				fmt.Println("  usage: <op> <val>")
				continue
			}
			val, err := strconv.ParseFloat(tokens[1], 64)
			if err != nil {
				fmt.Println("  enter a number")
				continue
			}
			evl.binaryOp(tokens[0], val)

			fmt.Printf("  built %s, force to evaluate\n", tokens[0])

		case "force":
			result, err := evl.force()
			if err != nil {
				fmt.Printf("  ✗ %v\n", err)
				continue
			}
			fmt.Printf("  = %s\n", lib.StripZero(result))

		case "store":
			if len(tokens) < 2 {
				fmt.Println("  usage: store <name>")
				continue
			}
			if evl.current == nil {
				fmt.Println("  no expression to store")
				continue
			}
			evl.thunks[tokens[1]] = evl.current
			fmt.Printf("  stored as %s\n", tokens[1])

		case "recall":
			if len(tokens) < 2 {
				fmt.Println("  usage: recall <name>")
				continue
			}
			t, ok := evl.thunks[tokens[1]]
			if !ok {
				fmt.Printf("  unknown thunk: %s\n", tokens[1])
				continue
			}
			evl.current = t
			fmt.Printf("  recalled %s\n", tokens[1])

		default:
			fmt.Println("  commands: lit <val> | <op> <val> | force | store <name> | recall <name> | q")
		}
	}
}
