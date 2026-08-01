# path-activation.md

Path activation is mise's mechanism of prepending resolved tool binaries to PATH with zero shim overhead.

`eval "$(mise activate zsh)"` hooks the shell prompt; `mise hook-env` updates env on directory change (fast-exit when unchanged). PATH modified ahead of time — `which node` returns the real binary path in `~/.local/share/mise/installs/...`. On-demand alternative: `mise exec -- node script.js`.

## Grounding

| Research capture | Key claim |
|------------------|-----------|
| research/mise-dev-tools.md | "calling a tool has zero overhead and commands like which node returns the real path" |
| research/mise-homepage.md | "which node gives us a real path to node, not a shim" |
| research/mise-dev-tools.md | "After mise activation in a project with node@20: /home/user/.local/share/mise/installs/node/20.11.0/bin:..." |

## Sub-concepts

- tool-resolution (PATH setup is step 3 of resolution)

## Distilled into

- note/ch03-dev-tools.md

## Precedes

tool-resolution
