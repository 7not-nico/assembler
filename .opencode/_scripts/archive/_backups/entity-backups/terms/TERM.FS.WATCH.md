**fs.watch** — the Node.js-compatible file system watcher exposed by Bun's `node:fs` module — no external watcher daemon required. Watches files or directories for changes, emitting `'rename'` or `'change'` events with the filename. Supports `AbortSignal` for cancellation and optional `encoding` configuration. Its Bun implementation matches the Node.js API for portable file-watching across projects.


---
reference:
---
