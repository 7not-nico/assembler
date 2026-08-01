Since there are 3 components (**S**ubject, **O**bject, **A**ction), there are **6 possible mathematical permutations ($3! = 6$)**. 

Each combination corresponds directly to specific **programming paradigms**, **syntactic patterns**, and even **natural human language structures**.

---

### Overview Matrix

| # | Combination | Primary Paradigm | Typical Languages / Tech | Syntax Style |
|---|---|---|---|---|
| 1 | **S – A – O** | Object-Oriented (OOP) | Java, C++, Python, Ruby, JS | `subject.action(object)` |
| 2 | **S – O – A** | Concatenative / Stack-based | Forth, PostScript, Factor, Elixir pipes | `subject object action` |
| 3 | **A – S – O** | Procedural / Lisp-style Functional | C, Lisp, Clojure, Go, PHP | `action(subject, object)` |
| 4 | **A – O – S** | Data-First / Curried Functional | Haskell, Elm, Ramda.js | `action(object, subject)` |
| 5 | **O – A – S** | Unix Piping / Reactive Streams | Bash, RxJS, Node Streams | `object \| action(subject)` |
| 6 | **O – S – A** | Query / Rule-Based / Declarative | SQL, Prolog, Perl (Postfix) | `OBJECT FROM subject WHERE action` |

---

### Detailed Breakdown of All 6 Combinations

---

#### 1. S – A – O (Subject → Action → Object)
* **Natural Language Equivalent:** Subject-Verb-Object (SVO — *e.g., English: "The dog bit the ball"*)
* **Paradigm:** **Object-Oriented Programming (OOP)**
* **Why it's used:** It feels natural to English speakers. The entity (Subject) explicitly owns the method (Action) operating on payload data (Object).

```javascript
// Paradigm: Object-Oriented
// [SUBJECT] -> [ACTION] -> [OBJECT]

user.sendMessage(emailData);
// ^    ^           ^
// |    |           +-- [OBJECT]:  The email payload
// |    +-------------- [ACTION]:  The method call
// +------------------- [SUBJECT]: The user instance
```

---

#### 2. S – O – A (Subject → Object → Action)
* **Natural Language Equivalent:** Subject-Object-Verb (SOV — *e.g., Japanese, Latin*)
* **Paradigm:** **Concatenative / Stack-Based Programming & Pipeline Chains**
* **Why it's used:** In stack languages, data (Subject & Object) is pushed onto a stack first, and the operator (Action) consumes them. In functional pipelines, you prepare the Subject and Object before triggering execution.

```forth
\ Paradigm: Stack-Based (Forth / PostScript)
\ [SUBJECT] [OBJECT] [ACTION]

user_ptr "Hello" send_mail
\ ^       ^       ^
\ |       |       +-- [ACTION]:  Consumes top 2 items from stack
\ |       +---------- [OBJECT]:  Pushed second
\ +------------------ [SUBJECT]: Pushed first
```

```elixir
# Paradigm: Functional Pipeline (Elixir)
user 
|> with_payload("Hello") # [SUBJECT] + [OBJECT] setup
|> send_mail()           # [ACTION] executed at the end
```

---

#### 3. A – S – O (Action → Subject → Object)
* **Natural Language Equivalent:** Verb-Subject-Object (VSO — *e.g., Classical Arabic, Irish*)
* **Paradigm:** **Procedural Programming & Symbolic/Prefix Functional**
* **Why it's used:** Functions are treated as global entry points. The verb leads the expression, followed by the context parameter (Subject) and target data (Object).

```c
// Paradigm: Procedural (C / Go)
// [ACTION]( [SUBJECT], [OBJECT] )

send_mail(user_ptr, "Hello");
// ^        ^         ^
// |        |         +-- [OBJECT]:  The message payload
// |        +------------ [SUBJECT]: The actor handle passed as parameter 1
// +--------------------- [ACTION]:  The global function verb
```

```clojure
;; Paradigm: Lisp / Prefix Notation (Clojure)
(send-mail user "Hello")
;; ^       ^    ^
;; |       |    +-- [OBJECT]
;; |       +------- [SUBJECT]
;; +--------------- [ACTION]
```

---

#### 4. A – O – S (Action → Object → Subject)
* **Natural Language Equivalent:** Verb-Object-Subject (VOS — *e.g., Fijian, Malagasy*)
* **Paradigm:** **Data-First / Point-Free / Curried Functional Programming**
* **Why it's used:** In functional languages using **Currying** or composition, putting the Object (data/payload) first—or the Subject (receiver/config) last—allows functions to be partially applied and chained together easily.

```haskell
-- Paradigm: Curried Functional (Haskell)
-- [ACTION] [OBJECT] [SUBJECT]

sendMail "Hello" user
-- ^      ^       ^
-- |      |       +-- [SUBJECT]: Passed last (useful for currying/partial application)
-- |      +---------- [OBJECT]:  The payload data
-- +----------------- [ACTION]:  The function
```

```javascript
// Paradigm: Point-Free / Data-First (Ramda.js)
const notifyUser = R.sendMail("Hello"); // [ACTION] + [OBJECT] partially applied
notifyUser(user);                       // [SUBJECT] supplied last
```

---

#### 5. O – A – S (Object → Action → Subject)
* **Natural Language Equivalent:** Object-Verb-Subject (OVS — *extremely rare natively, e.g., Klingon*)
* **Paradigm:** **Reactive Streams, Unix Pipelines, & Data-Centric Event Streams**
* **Why it's used:** When data transformations are the primary focus. The raw data (**Object**) is passed into a processing operation (**Action**), which is finally delivered to or transformed by a target handler (**Subject**).

```bash
# Paradigm: Unix Pipeline / Stream Processing
# [OBJECT] | [ACTION] [SUBJECT]

cat log.txt | grep "ERROR" | process_with logger
# ^           ^              ^
# |           |              +-- [SUBJECT]: The logger system handling output
# |           +----------------- [ACTION]:  The filtering command
# +----------------------------- [OBJECT]:  The input data payload
```

```javascript
// Paradigm: Reactive Streams (RxJS)
dataPayload$                     // [OBJECT]:  Data stream
  .pipe(map(x => x.transform))   // [ACTION]:  Transformation
  .subscribe(loggerSystem);      // [SUBJECT]: Receiver/Subscriber
```

---

#### 6. O – S – A (Object → Subject → Action)
* **Natural Language Equivalent:** Object-Subject-Verb (OSV — *e.g., Yoda-speak: "The apple, I ate"*)
* **Paradigm:** **Declarative Query Languages (SQL), Rule-Based Logic (Prolog), Postfix Conditionals**
* **Why it's used:** Declarative languages focus on *what data you want back* (**Object**) before describing *where it lives* (**Subject**) and *how to filter or process it* (**Action**).

```sql
-- Paradigm: Declarative Query (SQL)
-- [OBJECT] -> [SUBJECT] -> [ACTION]

SELECT message FROM users WHERE is_active = true;
--     ^            ^           ^
--     |            |           +-- [ACTION]:  Filtering condition/action
--     |            +-------------- [SUBJECT]: Source table/domain
--     +--------------------------- [OBJECT]:  Target data requested
```

```perl
# Paradigm: Postfix Conditional (Perl / Ruby Yoda-style)
print("An error occurred") if $logger->is_active();
# ^                        ^  ^
# |                        |  +-- [SUBJECT]: The logging entity
# |                        +----- [ACTION]:  State evaluation/trigger
# +------------------------------ [OBJECT]:  The message output
```

---

### Summary Takeaway

* **S–A–O** and **A–S–O** dominate imperative languages (Java, C, Python) because they match standard human speech logic (*"User, do this to object"* or *"Do this with user to object"*).
* **S–O–A** and **A–O–S** dominate pure functional and concatenative languages (Haskell, Forth) because they optimize for how memory, stacks, and function currying work under the hood.
* **O–A–S** and **O–S–A** dominate data-driven and query systems (SQL, Streams, Bash) because data is the primary concern, while the logic processing it comes second.
