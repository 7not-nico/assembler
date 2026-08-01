# calc_perm.go — all comments

Total comments: 9

## Header

- L13: Role — syntactic role in the statement.
- L22: orders — statement structure per variant.
- L23: The variant name IS the syntactic order of roles.
- L33: prompts — prompt text per role.
- L40: runPositional — shell for all 6 positional statement structures.
- L41: The order of roles in the statement defines the variant.

## Body

- L55: Each role loops until valid input or exit.
- L98: GO.ACTION: semantic core invariant — Apply(action, subject, object)
- L108: statementLabel — human-readable statement structure.