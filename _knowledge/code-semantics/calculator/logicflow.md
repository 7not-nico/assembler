# Logic Flow — calculator

```
subject → object → action → subject
```

The entire program cycles through four stages. Each stage produces the input for the next. The fourth stage (subject) loops back into the first stage of the next cycle.

---

## Stage 0 — source.string → token.list

```python
# source.string flows through a regex scanner
# every match becomes one token: (type, value)
# whitespace (SKIP) gets discarded
# output: a flat list of tokens

scan(source)
```

Token stream layout for `5.add.3.multiply.4`:

```
idx  type     value
──────────────────────
0    NUM      5           subject start
1    DOT      .
2    ACTION   add         action verb
3    DOT      .
4    NUM      3           object operand
5    DOT      .
6    ACTION   multiply    action verb
7    DOT      .
8    NUM      4           object operand
```

---

## Stage 1 — subject

```python
# pull the first number from the token stream
# this is the initial accumulator
# every cycle starts with a subject value

subject_val = float(toks[0][1])     # subject = first operand
idx = 1                              # advance past NUM
```

Role: the current accumulated value. Starts as the first literal number. Becomes the result of each action cycle.

Source: token stream at position 0 on first cycle; previous action result on subsequent cycles.

---

## Stage 2 — object

```python
# read the next operand from the token stream
# every cycle reads exactly one number

# skip DOT before ACTION
if toks[idx][0] != "DOT":
    raise ValueError(...)
idx += 1

# skip ACTION verb (read but not yet applied)
verb = toks[idx][1]     # stored for Stage 3
idx += 1

# skip DOT before NUM
if toks[idx][0] != "DOT":
    raise ValueError(...)
idx += 1

# object = the next operand number
object_val = float(toks[idx][1])    # object = next operand
idx += 1
```

Role: the right-hand operand. Each cycle consumes exactly one `DOT ACTION DOT NUM` segment from the token stream.

Source: token stream.

---

## Stage 3 — action

```python
# resolve the verb to a function
# apply: result = verb(subject, object)

fn = ACTIONS.get(verb)               # action = lookup verb
if fn is operator.truediv and object_val == 0.0:
    raise ZeroDivisionError(...)

subject_val = float(fn(subject_val, object_val))    # subject = result
```

Role: the transformation. Takes the current subject (accumulator) and the object (operand), applies the verb function, produces a new value.

Source: verb from Stage 2; subject from Stage 1 or previous cycle; object from Stage 2.

---

## Stage 4 — subject (loop back)

```python
# the result of action(subject, object) is the new subject
# the while loop checks if more tokens remain
# if yes: cycle repeats at Stage 2 with the new subject_val
# if no:  return subject_val as the final answer

while idx < len(toks):
    # ... Stage 2 → Stage 3 → Stage 4 ...

return subject_val      # final value after all cycles consumed
```

Role: the accumulator for the next cycle. When no tokens remain, the accumulator is the answer.

---

## Full cycle trace — `2.add.3.multiply.4`

```
token stream:  NUM(2)  DOT  ACTION(add)  DOT  NUM(3)  DOT  ACTION(multiply)  DOT  NUM(4)
               └idx=0┘                                                   └idx=8┘

subject(2)                    initial accumulator from first token
    │
    ├── DOT skip
    ├── action(add)           verb = "add"
    ├── DOT skip
    ├── object(3)             operand from token stream
    │
    ├── action: add(2, 3)     fn = operator.add
    │                             2 + 3 = 5
    │
    └── subject(5)            result becomes new accumulator
         │
         ├── DOT skip
         ├── action(multiply) verb = "multiply"
         ├── DOT skip
         ├── object(4)        operand from token stream
         │
         ├── action: multiply(5, 4)
         │                        fn = operator.mul
         │                            5 * 4 = 20
         │
         └── subject(20)      final — no more tokens
                                   return 20
```

---

## Error paths

```python
# empty input
if not toks:
    raise ValueError("empty expression")

# missing number at subject position
if toks[0][0] != "NUM":
    raise ValueError(...)

# malformed DOT ACTION DOT NUM sequence
if toks[idx][0] != "DOT":        raise ValueError(...)
if toks[idx][0] != "ACTION":     raise ValueError(...)
if toks[idx][0] != "DOT":        raise ValueError(...)
if toks[idx][0] != "NUM":        raise ValueError(...)

# undefined action verb
fn = ACTIONS.get(verb)
if fn is None:
    raise ValueError(f"unknown action: {verb}")

# division by zero
if fn is operator.truediv and object_val == 0.0:
    raise ZeroDivisionError(...)
```

Each error corresponds to a specific stage in the cycle. The error message names the expected token and the actual token, so the user knows exactly where the `subject → object → action → subject` chain broke.
