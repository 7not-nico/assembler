# Logic Flow — subject → object → action convention

Three phases. Every arithmetic operation follows them.

```
source
  │
  ▼
scan() → tokens
  │
  ▼
subject ← first number (accumulator start)
  │
  ├── object ──→ next number from tokens
  ├── action ──→ verb lookup → fn(subject, object)
  │
  ▼
subject ← result (cycles back)
  │
  ├── object ──→ next number from tokens
  ├── action ──→ verb lookup → fn(subject, object)
  │
  ▼
subject ← result (cycles back)
  ...
  │
  ▼
return final subject
```

---

## subject

The accumulator. Starts as the first number in the expression. After each action, it becomes the result.

```
tokens[0] is NUM?
  → parse as float
  → set subject = that value
  → advance cursor
```

## object  

The operand. Every cycle reads the next `VERB NUM` pair from the token stream.

```
tokens[cursor] is VERB?
  → capture verb string
  → advance cursor
tokens[cursor] is NUM?
  → parse as float
  → set object = that value
  → advance cursor
```

## action  

The transformation. One function, three inputs, one output.

```python
result = act(verb, subject, object)
```

The result becomes the new subject. The cycle starts again.

## evaluate

```python
subject = float(toks[0][1])       # subject: first number
cursor = 1

while cursor < len(toks):
    verb = toks[cursor][1]        # object: verb
    cursor += 1
    object = float(toks[cursor][1]) # object: operand
    cursor += 1
    subject = act(verb, subject, object)  # action → new subject

return subject                     # final subject
```

## Trace — `5 add 3 multiply 2`

```
token stream:  NUM(5)  VERB(add)  NUM(3)  VERB(multiply)  NUM(2)

subject = 5.0                    # first NUM
cursor = 1

object:   verb = "add"           # VERB at cursor 1
          object = 3.0           # NUM at cursor 2
action:   act("add", 5.0, 3.0) → 8.0
subject = 8.0                    # result → new subject

object:   verb = "multiply"      # VERB at cursor 3
          object = 2.0           # NUM at cursor 4
action:   act("multiply", 8.0, 2.0) → 16.0
subject = 16.0                   # result → new subject

cursor = 5 == len(tokens) → exit loop
return 16.0
```
