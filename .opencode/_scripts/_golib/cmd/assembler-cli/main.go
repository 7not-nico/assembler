// assembler-cli — entity audit and survey toolchain (Go port of _rs/_bin).
// ring: 6 (DB-WRITE) — orchestrates internal packages, writes to stdout.
//
// Commands: list [type], count, check {id-match|ring-match|source|precedes|stale-refs},
//           audit {type}, rings
package main

import (
	"fmt"
	"os"
	"sort"
	"strings"

	"assembler/scripts/golib/internal/check"
	"assembler/scripts/golib/internal/entity"
	"assembler/scripts/golib/internal/paths"
	"assembler/scripts/golib/internal/report"
	"assembler/scripts/golib/internal/rings"
	"assembler/scripts/golib/internal/violation"
)

func main() {
	args := os.Args[1:]
	if len(args) == 0 {
		usage()
		os.Exit(2)
	}
	switch args[0] {
	case "list":
		if len(args) > 1 {
			cmdList(args[1])
		} else {
			cmdListAll()
		}
	case "count":
		cmdCount()
	case "check":
		if len(args) < 2 {
			fmt.Fprintln(os.Stderr, "check requires a subcommand: id-match|ring-match|source|precedes|stale-refs")
			os.Exit(2)
		}
		cmdCheck(args[1])
	case "audit":
		if len(args) < 2 {
			fmt.Fprintln(os.Stderr, "audit requires an entity type")
			os.Exit(2)
		}
		if err := cmdAudit(args[1]); err != nil {
			fmt.Fprintln(os.Stderr, "Error:", err)
			os.Exit(1)
		}
	case "rings":
		cmdRings()
	default:
		usage()
		os.Exit(2)
	}
}

func usage() {
	fmt.Fprintln(os.Stderr, `Entity audit and survey toolchain

Usage: assembler-cli <COMMAND>

Commands:
  list   List entity types or entities of a type
  count  Count entities per type
  check  Run an entity integrity check
  audit  Run a structural audit scoped to one entity type
  rings  Show ring topology`)
}

func cmdList(entityType string) {
	entries := entity.LoadEntities(entityType)
	fmt.Printf("%d entities of type '%s':\n", len(entries), entityType)
	for _, entry := range entries {
		fmt.Printf("  %s — %s\n", entry.ID, entry.Title)
	}
}

func cmdListAll() {
	types := paths.EntityTypes()
	fmt.Printf("Entity types (%d):\n", len(types))
	for _, entityType := range types {
		count := len(entity.LoadEntities(entityType))
		fmt.Printf("  %s (%d entities)\n", entityType, count)
	}
}

func cmdCount() {
	types := paths.EntityTypes()
	rows := make([][]string, 0, len(types))
	for _, entityType := range types {
		rows = append(rows, []string{entityType, fmt.Sprint(len(entity.LoadEntities(entityType)))})
	}
	fmt.Println(report.FormatTable(rows, []string{"Entity Type", "Count"}))
}

func cmdCheck(sub string) {
	all := entity.LoadAllEntities()
	allIDs := entity.IdentifierSet(all)
	var faults []violation.Fault
	switch sub {
	case "id-match":
		faults = check.CheckIDMatch(all)
	case "ring-match":
		faults = check.CheckRingMatch(all)
	case "source":
		faults = check.CheckSource(all, allIDs)
	case "precedes":
		precedesFaults, cycles := check.CheckPrecedes(all)
		faults = precedesFaults
		if len(cycles) > 0 {
			fmt.Printf("Precedes cycles (%d):\n", len(cycles))
			for _, cycle := range cycles {
				fmt.Printf("  %s\n", cycle)
			}
		}
	case "stale-refs":
		faults = check.CheckStaleRefs(all)
	default:
		fmt.Fprintln(os.Stderr, "unknown check:", sub)
		os.Exit(2)
	}
	fmt.Println(violation.ReportFaults(faults))
	if len(faults) == 0 {
		fmt.Printf("ok — %d entities, all checks passed\n", len(all))
	}
}

func cmdAudit(entityType string) error {
	all := entity.LoadAllEntities()
	allIDs := entity.IdentifierSet(all)
	entries := entity.LoadEntities(entityType)

	if len(entries) == 0 {
		types := paths.EntityTypes()
		for _, t := range types {
			if t == entityType {
				fmt.Printf("audit ok — 0 entities of type '%s'\n", entityType)
				return nil
			}
		}
		sort.Strings(types)
		return fmt.Errorf("unknown entity type '%s' — valid: %s", entityType, strings.Join(types, ", "))
	}

	idFaults := check.CheckIDMatch(entries)
	ringFaults := check.CheckRingMatch(entries)
	sourceFaults := check.CheckSource(entries, allIDs)
	precedesAll, cycles := check.CheckPrecedes(all)
	precedesScoped := make([]violation.Fault, 0, len(precedesAll))
	for _, fault := range precedesAll {
		if fault.Type == entityType {
			precedesScoped = append(precedesScoped, fault)
		}
	}

	fmt.Printf("== audit: %s (%d entities) ==\n", entityType, len(entries))
	fmt.Println("-- id-match --")
	fmt.Println(violation.ReportFaults(idFaults))
	fmt.Println("-- ring-match --")
	fmt.Println(violation.ReportFaults(ringFaults))
	fmt.Println("-- source --")
	fmt.Println(violation.ReportFaults(sourceFaults))
	fmt.Println("-- precedes --")
	fmt.Println(violation.ReportFaults(precedesScoped))
	if len(cycles) > 0 {
		fmt.Printf("precedes cycles (%d):\n", len(cycles))
		for _, cycle := range cycles {
			fmt.Printf("  %s\n", cycle)
		}
	}

	total := len(idFaults) + len(ringFaults) + len(sourceFaults) + len(precedesScoped)
	if total == 0 && len(cycles) == 0 {
		fmt.Printf("audit ok — %d entities of type '%s', 0 faults\n", len(entries), entityType)
	} else {
		fmt.Printf("audit FAIL — %d faults, %d cycles\n", total, len(cycles))
	}
	return nil
}

func cmdRings() {
	fmt.Println("Ring topology per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY:")
	for _, row := range rings.AllRings() {
		fmt.Printf("  %s R%d — %s\n", row.Group, row.Ring, row.Name)
	}
}
