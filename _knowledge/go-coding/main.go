package main

import (
	"fmt"
	"os"
)

// variants — dispatch table, no switch.
// GO.ACTION: function values select the variant shell.
var variants = map[string]func(args []string){
	"soa":        func(args []string) { runSOA() },
	"sao":        func(args []string) { runSAO() },
	"aos":        func(args []string) { runAOS() },
	"aso":        func(args []string) { runASO() },
	"osa":        func(args []string) { runOSA() },
	"oas":        func(args []string) { runOAS() },
	"method":     func(args []string) { runMethod() },
	"imperative": func(args []string) { runImperative() },
	"stk":        func(args []string) { runSTK() },
	"chn":        func(args []string) { runCHN() },
	"ifc":        func(args []string) { runIFC() },
	"dfr":        func(args []string) { runDFR() },
	"evl":        func(args []string) { runEVL() },
	"map":        func(args []string) { runMAP() },
}

func main() {
	if len(os.Args) < 2 {
		printHelp()
		return
	}

	variant := os.Args[1]
	args := os.Args[2:]

	if variant == "help" || variant == "-h" || variant == "--help" {
		printHelp()
		return
	}

	// GO.ACTION: table dispatch — no conditional branching
	run, ok := variants[variant]
	if !ok {
		fmt.Printf("unknown variant: %s\n", variant)
		fmt.Println()
		printHelp()
		os.Exit(1)
	}
	run(args)
}

func printHelp() {
	fmt.Println("Go Calculator — 14 semantic variants")
	fmt.Println()
	fmt.Println("  Linear S/O/A permutations:")
	fmt.Println("    soa    subject → object → action")
	fmt.Println("    sao    subject → action → object  (infix, takes expression arg)")
	fmt.Println("    aos    action → object → subject  (Polish)")
	fmt.Println("    aso    action → subject → object")
	fmt.Println("    osa    object → subject → action")
	fmt.Println("    oas    object → action → subject")
	fmt.Println()
	fmt.Println("  Go-native structural forms:")
	fmt.Println("    chn          channel-based concurrent")
	fmt.Println("    ifc          interface dispatch (interface{} + type switch)")
	fmt.Println("    dfr          deferred evaluation (defer LIFO)")
	fmt.Println("    evl          lazy evaluation (thunks)")
	fmt.Println("    map          functional reduce")
	fmt.Println("    stk          stack-based (Forth-style)")
	fmt.Println("    method       subject.action(object)")
	fmt.Println("    imperative   subject ← action(subject, object)")
	fmt.Println()
	fmt.Println("  Usage:")
	fmt.Println("    go run . <variant>")
	fmt.Println("    go run . sao \"5 + 3\"")
	fmt.Println("    go run . help")
}
