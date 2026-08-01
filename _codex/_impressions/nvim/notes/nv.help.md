`:help` splits the Neovim window — default is a **horizontal split** occupying the top half — and loads the requested Vimdoc help file from `$VIMRUNTIME/doc/`. Navigation uses **tag jumping**: `Ctrl-]` follows a tag reference, `Ctrl-O` / `Ctrl-I` traverse the jump stack. Each help file is a plain .txt with `*tag*` anchors for cross-reference. The split occupies a full-width window; `Ctrl-W` directionals move focus between help and the original buffer.

---
id: NV.HELP
title: Neovim Help Screen-Split
source: nvim
related: NV.NOTES
tags: [neovim, help, vimdoc, navigation, split]
reference:
  - title: Neovim help — :help
    url: https://neovim.io/doc/user/helphelp.html
---

