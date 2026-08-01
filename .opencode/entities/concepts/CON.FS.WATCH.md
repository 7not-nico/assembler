**fs.watch** — the Node.js-compatible file system watcher exposed by Bun's `node:fs` module — no external watcher daemon required. Watches files or directories for changes via OS kernel (inotify on Linux), emitting `'rename'` or `'change'` events with the filename. Detects writes from any source — opencode editor, agent tools (Write, Bash), external editors, shell commands. This distinguishes it from plugin lifecycle hooks: `file.edited` fires on opencode editor manual saves only, `tool.execute.after` fires on agent tool execution only. `fs.watch` at the MCP server level provides the widest detection scope — all filesystem writes from any process. Supports `AbortSignal` for cancellation and optional `encoding` configuration. Bun implementation matches the Node.js API for portable file-watching across projects.

---
id: CON.FS.WATCH
mode: practical
title: fs.watch
source: COG.COMPUTER.SCIENCE
tags: filesystem,watch,event,detection,monitoring,kernel,inotify,mcp

---
