// Package rings carries the ring topology per SPEC.KNOWLEDGE.CLASSIFICATION.TOPOLOGY.
// ring: 0 (PURE) — no I/O.
package rings

import (
	"sort"
	"strings"
)

// RingInfo names the entity kinds at one ring of a group.
type RingInfo struct {
	Ring int
	Name string
}

// groupRings maps group name to its ordered ring sequence.
var groupRings = map[string][]RingInfo{
	"axiomatic": {
		{Ring: 0, Name: "Maxim, Precept, Specification"},
		{Ring: 1, Name: "Identity"},
		{Ring: 2, Name: "Abstraction, Algorithm, Linguistic"},
	},
	"encyclopedic": {
		{Ring: 0, Name: "Etymology"},
		{Ring: 1, Name: "Cognition"},
		{Ring: 2, Name: "Concept, Definition, Taxonomy"},
		{Ring: 3, Name: "Term, Biology, Chemical"},
	},
	"composition": {
		{Ring: 0, Name: "Protocol"},
		{Ring: 1, Name: "Pattern"},
		{Ring: 2, Name: "Nexus"},
		{Ring: 3, Name: "Illustration, Reference"},
	},
	"architectonic": {
		{Ring: 0, Name: "Rule"},
		{Ring: 1, Name: "Command, Skill"},
		{Ring: 2, Name: "Tool"},
	},
	"chronicle": {
		{Ring: 0, Name: "Person"},
		{Ring: 1, Name: "Investigation, Apologia, Manifest"},
		{Ring: 2, Name: "Archive, Note"},
	},
}

// groupOrder keeps ring output deterministic (Rust HashMap order was not).
var groupOrder = []string{"axiomatic", "encyclopedic", "composition", "architectonic", "chronicle"}

// RingRow is one line of ring topology output.
type RingRow struct {
	Group string
	Ring  int
	Name  string
}

// AllRings returns the full topology as ordered rows.
func AllRings() []RingRow {
	var rows []RingRow
	for _, group := range groupOrder {
		for _, info := range groupRings[group] {
			rows = append(rows, RingRow{Group: group, Ring: info.Ring, Name: info.Name})
		}
	}
	return rows
}

// typeToRing maps a singular entity-kind name ("protocols") to (group, ring).
var typeToRing = func() map[string][2]any {
	m := make(map[string][2]any)
	for group, infos := range groupRings {
		for _, info := range infos {
			for _, kind := range strings.Split(info.Name, ", ") {
				m[strings.ToLower(kind)] = [2]any{group, info.Ring}
			}
		}
	}
	return m
}()

// TypeRing resolves an entity type directory name to (group, ring).
func TypeRing(entityType string) (string, int, bool) {
	v, ok := typeToRing[entityType]
	if !ok {
		return "", 0, false
	}
	return v[0].(string), v[1].(int), true
}

// GroupNames lists the groups in display order.
func GroupNames() []string {
	out := make([]string, len(groupOrder))
	copy(out, groupOrder)
	sort.Strings(out)
	return out
}
