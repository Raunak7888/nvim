# Neovim Keymaps Reference

This document lists the keymaps defined by this configuration, plus the important default behaviors that are intentionally preserved.

## Conventions

- `Leader` = `<Space>`
- `LocalLeader` = `\`
- `Modes`: `n` = normal, `i` = insert, `v` = visual, `x` = visual-select, `o` = operator-pending
- `Buffer-local` means the mapping only exists when the related feature or plugin is attached

## Core Global Keymaps

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n,v` | `<Space>` | Disable raw space so it can act as leader | `lua/core/keymaps.lua` |
| `n` | `;` | Enter command-line mode quickly | `lua/core/keymaps.lua` |
| `i` | `jk` | Exit insert mode | `lua/core/keymaps.lua` |
| `n` | `<Esc>` | Clear search highlight, then send normal Escape | `lua/core/keymaps.lua` |
| `n` | `<leader>w` | Write current buffer | `lua/core/keymaps.lua` |
| `n` | `<leader>q` | Quit current window | `lua/core/keymaps.lua` |
| `n` | `<leader>Q` | Quit all windows | `lua/core/keymaps.lua` |
| `n` | `<C-h>` | Move to left split | `lua/core/keymaps.lua` |
| `n` | `<C-j>` | Move to lower split | `lua/core/keymaps.lua` |
| `n` | `<C-k>` | Move to upper split | `lua/core/keymaps.lua` |
| `n` | `<C-l>` | Move to right split | `lua/core/keymaps.lua` |
| `n` | `<leader>-` | Horizontal split | `lua/core/keymaps.lua` |
| `n` | `<leader>\|` | Vertical split | `lua/core/keymaps.lua` |
| `n` | `<leader>bd` | Delete current buffer | `lua/core/keymaps.lua` |
| `n` | `<leader>bo` | Delete all other buffers | `lua/core/keymaps.lua` |
| `n` | `]d` | Go to next diagnostic | `lua/core/keymaps.lua` |
| `n` | `[d` | Go to previous diagnostic | `lua/core/keymaps.lua` |
| `n` | `<leader>cd` | Show line diagnostics in a float | `lua/core/keymaps.lua` |
| `n` | `<leader>xx` | Open diagnostics in Trouble | `lua/core/keymaps.lua` |
| `n` | `<leader>xX` | Open current-buffer diagnostics in Trouble | `lua/core/keymaps.lua` |
| `n` | `<A-j>` | Move current line down | `lua/core/keymaps.lua` |
| `n` | `<A-k>` | Move current line up | `lua/core/keymaps.lua` |
| `v` | `<A-j>` | Move selected lines down | `lua/core/keymaps.lua` |
| `v` | `<A-k>` | Move selected lines up | `lua/core/keymaps.lua` |
| `n` | `<leader>un` | Toggle line numbers and keep relative numbers in sync | `lua/core/keymaps.lua` |
| `n` | `<leader>ur` | Toggle relative line numbers | `lua/core/keymaps.lua` |

## Telescope Keymaps

These mappings load Telescope on demand.

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n` | `<leader>ff` | Find files, including hidden files | `lua/plugins/telescope.lua` |
| `n` | `<leader>fg` | Live grep with extra ripgrep arguments | `lua/plugins/telescope.lua` |
| `n` | `<leader>fG` | Find Git-tracked and untracked files | `lua/plugins/telescope.lua` |
| `n` | `<leader>fb` | List open buffers | `lua/plugins/telescope.lua` |
| `n` | `<leader>fh` | Search help tags | `lua/plugins/telescope.lua` |
| `n` | `<leader>fr` | Open recent files | `lua/plugins/telescope.lua` |
| `n` | `<leader>fs` | Search document symbols | `lua/plugins/telescope.lua` |
| `n` | `<leader>fS` | Search workspace symbols | `lua/plugins/telescope.lua` |
| `n` | `<leader>fd` | Search diagnostics | `lua/plugins/telescope.lua` |
| `n` | `<leader>fw` | List Git worktrees | `lua/plugins/telescope.lua` |
| `n` | `<leader>fW` | Create a Git worktree | `lua/plugins/telescope.lua` |
| `n` | `<leader>fu` | Browse undo history | `lua/plugins/telescope.lua` |

### Telescope Picker Defaults

These apply inside Telescope prompt windows.

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `i` | `<C-j>` | Move to next selection | `lua/plugins/telescope.lua` |
| `i` | `<C-k>` | Move to previous selection | `lua/plugins/telescope.lua` |
| `i` | `<C-q>` | Send results to quickfix and open it | `lua/plugins/telescope.lua` |

## File Explorer and Editor Plugin Keymaps

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n` | `<leader>e` | Toggle Neo-tree filesystem explorer | `lua/plugins/editor.lua` |
| `n` | `<leader>ge` | Open Neo-tree Git status view in a float | `lua/plugins/editor.lua` |
| `n,x,o` | `s` | Flash jump | `lua/plugins/editor.lua` |
| `n,x,o` | `S` | Flash Treesitter jump | `lua/plugins/editor.lua` |
| `o` | `r` | Remote Flash jump | `lua/plugins/editor.lua` |
| `o,x` | `R` | Treesitter search via Flash | `lua/plugins/editor.lua` |

### Session Keymaps

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n` | `<leader>qs` | Restore session for current working directory | `lua/plugins/editor.lua` |
| `n` | `<leader>qS` | Select and restore a saved session | `lua/plugins/editor.lua` |
| `n` | `<leader>ql` | Restore last session | `lua/plugins/editor.lua` |
| `n` | `<leader>qd` | Stop automatic session saving | `lua/plugins/editor.lua` |

## Git Keymaps

These are buffer-local and appear when `gitsigns.nvim` attaches.

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n` | `]h` | Jump to next Git hunk | `lua/plugins/git.lua` |
| `n` | `[h` | Jump to previous Git hunk | `lua/plugins/git.lua` |
| `n` | `<leader>gs` | Stage current hunk | `lua/plugins/git.lua` |
| `v` | `<leader>gs` | Stage selected hunks | `lua/plugins/git.lua` |
| `n` | `<leader>gr` | Reset current hunk | `lua/plugins/git.lua` |
| `v` | `<leader>gr` | Reset selected hunks | `lua/plugins/git.lua` |
| `n` | `<leader>gS` | Stage entire buffer | `lua/plugins/git.lua` |
| `n` | `<leader>gR` | Reset entire buffer | `lua/plugins/git.lua` |
| `n` | `<leader>gp` | Preview current hunk | `lua/plugins/git.lua` |
| `n` | `<leader>gb` | Blame current line | `lua/plugins/git.lua` |
| `n` | `<leader>gd` | Diff current buffer | `lua/plugins/git.lua` |

## LSP Keymaps

These are buffer-local and only exist after an LSP client attaches.

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n` | `gd` | Go to definition via Telescope | `lua/util/lsp.lua` |
| `n` | `gD` | Go to declaration | `lua/util/lsp.lua` |
| `n` | `gr` | Find references via Telescope | `lua/util/lsp.lua` |
| `n` | `gI` | Go to implementation via Telescope | `lua/util/lsp.lua` |
| `n` | `gy` | Go to type definition via Telescope | `lua/util/lsp.lua` |
| `n` | `K` | Hover documentation | `lua/util/lsp.lua` |
| `n` | `<C-k>` | Signature help | `lua/util/lsp.lua` |
| `n` | `<leader>ca` | Code actions | `lua/util/lsp.lua` |
| `n` | `<leader>cr` | Rename symbol | `lua/util/lsp.lua` |
| `n` | `<leader>cA` | Source actions only, auto-apply when possible | `lua/util/lsp.lua` |
| `n` | `<leader>cl` | Open `:LspInfo` | `lua/util/lsp.lua` |
| `n` | `<leader>cf` | Format current buffer through Conform | `lua/util/lsp.lua` |
| `n` | `<leader>uh` | Toggle inlay hints when supported | `lua/util/lsp.lua` |

## Debugging Keymaps

These load `nvim-dap` on demand.

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n` | `<F5>` | Continue / start debugging | `lua/plugins/dap.lua` |
| `n` | `<F10>` | Step over | `lua/plugins/dap.lua` |
| `n` | `<F11>` | Step into | `lua/plugins/dap.lua` |
| `n` | `<F12>` | Step out | `lua/plugins/dap.lua` |
| `n` | `<leader>db` | Toggle breakpoint | `lua/plugins/dap.lua` |
| `n` | `<leader>dB` | Set conditional breakpoint | `lua/plugins/dap.lua` |
| `n` | `<leader>dc` | Continue | `lua/plugins/dap.lua` |
| `n` | `<leader>di` | Step into | `lua/plugins/dap.lua` |
| `n` | `<leader>do` | Step out | `lua/plugins/dap.lua` |
| `n` | `<leader>dO` | Step over | `lua/plugins/dap.lua` |
| `n` | `<leader>dr` | Toggle DAP REPL | `lua/plugins/dap.lua` |
| `n` | `<leader>du` | Toggle DAP UI | `lua/plugins/dap.lua` |
| `n` | `<leader>dt` | Terminate debug session | `lua/plugins/dap.lua` |

## Comment Plugin Defaults Kept

`Comment.nvim` uses its standard mappings because this config does not override them.

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n,v` | `gc` | Linewise comment operator and toggles | plugin default, declared in `lua/plugins/editor.lua` |
| `n,v` | `gb` | Blockwise comment operator and toggles | plugin default, declared in `lua/plugins/editor.lua` |

Examples:

- `gcc` toggles comment on the current line
- `gcj` comments the current line and the one below
- `gbc` toggles a block comment on the current line

## Surround Plugin Defaults Kept

`nvim-surround` also keeps its standard mappings because this config does not override them.

| Mode | Key | Description | Source |
| --- | --- | --- | --- |
| `n` | `ys` | Add surrounding text using a motion | plugin default, declared in `lua/plugins/editor.lua` |
| `n` | `yss` | Surround the whole current line | plugin default, declared in `lua/plugins/editor.lua` |
| `n` | `ds` | Delete surrounding text | plugin default, declared in `lua/plugins/editor.lua` |
| `n` | `cs` | Change surrounding text | plugin default, declared in `lua/plugins/editor.lua` |
| `v` | `S` | Surround current visual selection | plugin default, declared in `lua/plugins/editor.lua` |

Examples:

- `ysiw"` surrounds the current word with double quotes
- `cs"'` changes double quotes to single quotes
- `ds)` removes surrounding parentheses

## Neo-tree Internal Default Note

Neo-tree keeps its normal internal mappings, except one explicit override:

| Context | Key | Description | Source |
| --- | --- | --- | --- |
| Neo-tree window | `<Space>` | Disabled inside Neo-tree so it does not conflict with leader usage | `lua/plugins/editor.lua` |

All other Neo-tree window bindings remain the plugin defaults.

## Which-key Group Prefixes

These are not executable actions by themselves. They are grouping labels shown by `which-key.nvim`.

| Prefix | Group |
| --- | --- |
| `<leader>b` | Buffers |
| `<leader>c` | Code |
| `<leader>d` | Debug |
| `<leader>f` | Find |
| `<leader>g` | Git |
| `<leader>q` | Quit / Session |
| `<leader>s` | Search |
| `<leader>t` | Toggle / Tasks |
| `<leader>u` | UI |
| `<leader>x` | Diagnostics |

## Built-in Neovim Defaults Preserved

This configuration intentionally keeps the normal Vim and Neovim defaults unless listed elsewhere in this file. Important examples:

- Standard motions like `h`, `j`, `k`, `l`, `w`, `b`, `e`, `gg`, `G`
- Standard text objects like `iw`, `aw`, `i"`, `a)`
- Standard window commands under `<C-w>`
- Standard search keys like `/`, `?`, `n`, `N`, `*`, `#`
- Standard marks, registers, macros, folds, and quickfix/location list commands

## Conflicts and Overrides Summary

- `<Space>` is reserved as `mapleader`
- `;` is remapped to `:`
- `jk` is used to leave insert mode
- `<Esc>` also clears search highlight in normal mode
- `<C-k>` has two meanings depending on context:
  - Global normal mode: move to the upper split
  - LSP-attached buffer: show signature help

## Maintenance Tip

Whenever keymaps change, update this file alongside the Lua source so the reference stays accurate.
