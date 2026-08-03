# Search

**Route** — find entities by meaning: embed a natural-language query, return ANN top-k matches.

**Target** — load `use-semantic-search` before vector-store queries.

**Notes**

- Describe the query in natural language — the embedder matches meaning.
- Scope with `type` for one entity kind; omit for a full sweep.
- Set `k` to the result bound — 1 to 50, default 10.
- Read the ranked hits with scores — the score shows semantic distance.
