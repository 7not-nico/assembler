package calc

import (
	"fmt"
	"math"
	"strconv"
)

// Operator — binary function value.
// GO.OBJECT: functions are first-class values in Go.
type Operator func(a, b float64) (float64, error)

// Operators — function table, extensible without touching Apply.
// GO.ACTION: each entry is an expression evaluation.
var Operators = map[string]Operator{
	"+": func(a, b float64) (float64, error) { return a + b, nil },
	"-": func(a, b float64) (float64, error) { return a - b, nil },
	"*": func(a, b float64) (float64, error) { return a * b, nil },
	"/": func(a, b float64) (float64, error) {
		if b == 0 {
			return 0, fmt.Errorf("division by zero")
		}
		return a / b, nil
	},
	"**": func(a, b float64) (float64, error) { return math.Pow(a, b), nil },
}

// Apply — pure: delegates to the Operators function table.
func Apply(op string, a, b float64) (float64, error) {
	fn, ok := Operators[op]
	if !ok {
		return 0, fmt.Errorf("unknown operator: %s", op)
	}
	return fn(a, b)
}

// Compose — higher-order: combines two operators into a pipeline.
// f then g applied to (a, b) then (mid, b).
func Compose(f, g Operator) Operator {
	return func(a, b float64) (float64, error) {
		mid, err := f(a, b)
		if err != nil {
			return 0, err
		}
		return g(mid, b)
	}
}

// ParseValue — pure: parses string to float64.
func ParseValue(s string) (float64, error) {
	return strconv.ParseFloat(s, 64)
}

// Token — a parsed unit: number or operator.
type Token struct {
	Kind string
	Text string
}

// Scan — pure: tokenizes an infix expression string.
func Scan(expr string) []Token {
	var tokens []Token
	runes := []rune(expr + "\x00")
	i := 0

	for i < len(runes) {
		c := runes[i]
		if c == ' ' || c == '\t' {
			i++
			continue
		}
		if c == '\x00' {
			break
		}
		if c >= '0' && c <= '9' {
			start := i
			for i < len(runes) && ((runes[i] >= '0' && runes[i] <= '9') || runes[i] == '.') {
				i++
			}
			tokens = append(tokens, Token{"NUM", string(runes[start:i])})
			continue
		}
		if c == '*' && i+1 < len(runes) && runes[i+1] == '*' {
			tokens = append(tokens, Token{"OP", "**"})
			i += 2
			continue
		}
		if c == '+' || c == '-' || c == '*' || c == '/' {
			tokens = append(tokens, Token{"OP", string(c)})
			i++
			continue
		}
		i++
	}
	return tokens
}

// Evaluate — pure: evaluates an infix expression string left-to-right.
func Evaluate(expr string) (float64, error) {
	toks := Scan(expr)
	if len(toks) == 0 {
		return 0, fmt.Errorf("empty expression")
	}
	if toks[0].Kind != "NUM" {
		return 0, fmt.Errorf("expected number, got %s", toks[0].Text)
	}
	subject, err := ParseValue(toks[0].Text)
	if err != nil {
		return 0, err
	}
	pos := 1

	for pos < len(toks) {
		if pos >= len(toks) || toks[pos].Kind != "OP" {
			return 0, fmt.Errorf("expected operator at position %d", pos)
		}
		op := toks[pos].Text
		pos++
		if pos >= len(toks) || toks[pos].Kind != "NUM" {
			return 0, fmt.Errorf("expected number after operator")
		}
		obj, err := ParseValue(toks[pos].Text)
		if err != nil {
			return 0, err
		}
		pos++
		subject, err = Apply(op, subject, obj)
		if err != nil {
			return 0, err
		}
	}
	return subject, nil
}

// Reduce — pure: folds operator list over operand list.
// subject starts at 0.0 (zero value). Each action updates it.
func Reduce(ops []string, vals []float64) (float64, error) {
	subject := 0.0
	for i := 0; i < len(ops) && i < len(vals); i++ {
		var err error
		subject, err = Apply(ops[i], subject, vals[i])
		if err != nil {
			return 0, err
		}
	}
	return subject, nil
}

// IsOperator — pure: returns true if s is a known operator.
func IsOperator(s string) bool {
	_, ok := Operators[s]
	return ok
}
