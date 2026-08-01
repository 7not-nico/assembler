# Neovim Plugin Landscape

## Core plugin managers
- lazy.nvim — modern, lazy-loading, lockfile
- packer.nvim — predecessor, now archived
- vim-plug — minimalist, still maintained

## Essential categories
| Category     | Popular picks                    |
| ------------ | -------------------------------- |
| File explorer| oil.nvim, neo-tree, telescope    |
| LSP          | mason, mason-lspconfig, lazydev |
| Snippets     | luasnip, vim-snippets            |
| Colorscheme  | tokyonight, catppuccin, kanagawa |
| Statusline   | lualine, feline, staline         |

## lazy.nvim patterns
<!-- this is an object, -->

Stable spec:
```lua
{
  "username/repo",
  opts = {},
  keys = { ... },
  cmd = { ... },
}
```
