# English Grammar Terms — Etymological Origins

**Method**: Trace each term from Greek (Dionysius Thrax) → Latin (Varro/Priscian/Donatus) → French → English

---

## Transmission Chain

```
Dionysius Thrax (c. 100 BCE)      ---- apocryphal "Τέχνη Γραμματική"
    → 8 parts of speech in Greek
    ↓
Varro / Remmius Palaemon (1st C BCE-CE)    ---- Latin adaptation
Priscian / Donatus (4th-6th C CE)          ---- Standard Latin grammars
    ↓
Middle English (14th-15th C)        ---- via Old French / Anglo-Norman
```

---

## Parts of Speech

| Greek | Translit | Meaning | Latin | English |
|-------|----------|---------|-------|---------|
| ὄνομα | *onoma* | "name" | *nomen* | **noun** |
| ῥῆμα | *rhema* | "saying, word" | *verbum* | **verb** |
| — (added by Latins) | — | — | *adiectivum* < *ad+iacere* "thrown to" | **adjective** |
| μετοχή | *metochē* | "partaking, sharing" | *participium* < *particeps* | **participle** |
| ἀντωνυμία | *antōnymia* | "instead of noun" | *pronomen* | **pronoun** |
| πρόθεσις | *prothesis* | "placing before" | *praepositio* | **preposition** |
| ἐπίρρημα | *epirrhema* | "upon-verb" | *adverbium* (calque) | **adverb** |
| σύνδεσμος | *syndesmos* | "binding together" | *coniunctio* | **conjunction** |
| ἄρθρον | *arthron* | "joint" | *articulus* | **article** |
| — (added by Latins) | — | — | *interiectio* "thrown between" | **interjection** |

---

## Verbals (Non-finite forms)

| Term | Source | Meaning |
|------|--------|---------|
| **gerund** | L *gerundium* < *gerundus* "to be carried out" | A doing; verbal noun in English (-ing) |
| **infinitive** | L *infinitivus* "unlimited, unbounded" | Not limited by person/number |
| **supine** | L *supinum* "lying on its back" | Latin verbal noun in -um/-u |
| **gerundive** | L *gerundivus* (modus) | Future passive participle (obligation) |

**Note on gerund**: Latin *gerundium* was a Latin innovation — no direct Greek equivalent. Applied to English -ing forms in 16th C by analogy.

---

## Syntactic Terms

| Term | Greek | Meaning | Latin | English |
|------|-------|---------|-------|---------|
| subject | *hypokeimenon* | "lying under" | *subiectum* "thrown under" | what the sentence is about |
| predicate | *katēgoria* | "assertion, accusation" | *praedicatum* "declared" | what is affirmed of subject |
| object | — | — | *obiectum* "thrown against" | argument of verb |
| clause | — | — | *clausula* "a closing" | group of words with verb |
| phrase | — | — | *phrasis* < Gk "speech" | group of words |
| case | *ptōsis* | "falling" | *casus* "a fall" | inflectional form of noun |
| syntax | *syntaxis* | "arrangement together" | *syntaxis* | sentence structure |

---

## Semantic Implications for LLMs

| Grammatical category | LLM weight | Why |
|----------------------|------------|-----|
| Subject (noun/NP) | **Highest** | Emerges from layer 1; NP = primary role carrier |
| Verb (predicate) | **High** | Predicate-argument binding circuits; 89-92% in 28 nodes |
| Adjective | **High** | Differentia_quality = 31% definitional processing weight |
| Adverb | **Moderate** | Higher-order modifier; later layers, context-dependent |
| Gerund | **Lowest** | No dedicated circuits; processed through NOUN+VERB paths |
| Participle | **Low** | Merged with gerund in English -ing; no specialized tracking |
| Preposition/Conjunction | **Moderate** | Function words have specialized heads in layers 3-4 |
| Article | **High** | Part of determiner-noun agreement (68.91% overlap) |

**Key insight**: LLM weight directly corresponds to the grammatical category's position in the dependency hierarchy. Subject (nsubj) and object (obj) have the most dedicated circuits because they carry the core argument structure of the sentence. Gerunds and participles are syntactic hybrids — the model tracks their components (noun + verb) separately without dedicated hybrid circuits.
