---
id: ILL.PROTOTYPE.REWRITE
title: "Prototype to Learn — Rewriting a Surviving Prototype Into Production Code"
source: PROT.TOOL.DEFINITION
summary: "A quick prototype validates the arxiv API integration. It works well enough to keep. The agent rewrites it properly — typed, tested, error-handled — before evolving it further."
illustration: "An arxiv API integration prototype of 30 lines in a single file validates end-to-end connectivity. The agent rewrites it with typed return values, error boundaries, test coverage, and CLI entry point — then evolves it into the paper-acquisition pipeline."
illustrates: [MAX.PROTOTYPE.TO.LEARN]
tags: walkthrough,prototype,rewrite,production,evolution,throwaway
related: [PAT.TRACER.BULLETS.PRACTICE, MAX.CATALYST.FOR.CHANGE, MAX.PROGRAMMING.DELIBERATELY.PRACTICE]
---
## Context

`MAX.PROTOTYPE.TO.LEARN` says prototypes are written to be discarded; rewrite any survivor into production code. An agent writes a 30-line script to test the arxiv API: fetch a paper by ID, parse the XML response, print the title. It works. The next task is to build the full paper acquisition pipeline. The temptation is to keep the prototype and add features to it.

## Walkthrough

### Step 1: The prototype — 30 lines, no error handling

```ts
// prototype-fetch.ts
const url = "https://export.arxiv.org/api/query?id_list=2507.01103";
const xml = await fetch(url).then(r => r.text());
const title = xml.match(/<title>(.*?)<\/title>/)?.[1] ?? "unknown";
console.log(title);
```

It works. The agent prints the title. The API connection is validated.

### Step 2: Decision — keep or discard?

The prototype validated the hypothesis: arxiv API is reachable, XML parsing works. The code is 30 lines, no error handling, no types, no tests. The agent decides: rewrite from scratch before evolving.

### Step 3: Rewrite as production code

The rewritten version lives in `lib/arxiv.ts`:

```ts
interface ArxivPaper {
  id: string;
  title: string;
  summary: string;
  authors: string[];
}

async function fetchPaper(id: string): Promise<ArxivPaper> {
  const url = `https://export.arxiv.org/api/query?id_list=${id}`;
  const response = await fetch(url);
  if (!response.ok) throw new Error(`arxiv API: ${response.status}`);
  const xml = await response.text();
  return parseArxivXml(xml);
}
```

Error handling, typed return values, parse function separated.

### Step 4: Add test coverage

A test validates the parse function against known XML:

```ts
describe("parseArxivXml", () => {
  it("extracts title from response", () => {
    const paper = parseArxivXml(sampleXml);
    expect(paper.title).toBe("A Sample Paper");
  });
});
```

### Step 5: Add CLI entry point

The tool entry point wraps the lib function:

```ts
// tools/fetch-paper.ts
import { fetchPaper } from "../lib/arxiv";

export default async function (args: { id: string }) {
  const paper = await fetchPaper(args.id);
  return { content: JSON.stringify(paper, null, 2) };
}
```

### Step 6: Evolve into the pipeline

The rewritten, tested, typed lib function is now safe to compose into the acquisition pipeline. The prototype file is deleted.

## Key insight

The prototype's value was the learning — the API works, XML parses, response schema is as documented. The prototype itself was disposable. Keeping it and adding features would have produced untested, untyped, un-errrored code that grew brittle. The rewrite from scratch took 20 minutes and produced a foundation that safely evolves into the full pipeline.

## See also

- `MAX.PROTOTYPE.TO.LEARN` — the maxim this illustrates
- `PAT.TRACER.BULLETS.PRACTICE` — tracer bullets grow; prototypes get thrown away
- `MAX.CATALYST.FOR.CHANGE` — ship the 80% lib, not the 30% prototype
- `MAX.PROGRAMMING.DELIBERATELY.PRACTICE` — explain the architecture before evolving
