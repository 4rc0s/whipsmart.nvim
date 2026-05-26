# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Overview

This is **whipsmart.nvim** — a modular, native-first Neovim configuration built on the
Neovim 0.12+ `vim.pack` system. It replaced a kickstart.nvim + Lazy.nvim setup on all machines.

- Core plugin modules live in `lua/plugins/`.
- Opt-in extras live in `lua/whipsmart/plugins/` (not loaded by default).
- Per-machine overrides live in `lua/local.lua` (gitignored, never committed).
- Personal plugins go in `lua/custom/plugins/` (auto-loaded, gitignored-friendly).
- The roadmap and architecture notes are in `UNIFIED.md`.

## Plugin Management (inside Neovim)

- `<leader>pm` — open the **Package Manager Menu** (pack-manager.nvim UI)
- `<leader>ps` — sync packages (`vim.pack.update()`)
- `<leader>pi` — inspect package status (offline)
- `:checkhealth whipsmart` — diagnose config/plugin issues
- `:Mason` — manage LSP servers, linters, formatters
- `:TSUpdate` — update treesitter parsers
- `:ConformInfo` — show active formatters for current buffer

### Managing `nvim-pack-lock.json` Across Machines

The `nvim-pack-lock.json` lockfile ensures all machines install the exact same version of Neovim plugins. It is fully tracked in Git without workarounds.

If you update plugins locally:
1. Stage and commit the updated `nvim-pack-lock.json`:
   ```bash
   git add nvim-pack-lock.json
   git commit -m "Update package lockfile"
   ```
2. Push your changes so your other machines stay in sync:
   ```bash
   git push origin master
   ```

If you want to pull changes but have local lockfile changes you do not want to keep:
1. Discard the local lockfile changes:
   ```bash
   git restore nvim-pack-lock.json
   ```
2. Pull the changes:
   ```bash
   git pull
   ```

If a merge conflict occurs on the lockfile during a pull:
1. Accept the upstream lockfile:
   ```bash
   git checkout --theirs nvim-pack-lock.json
   ```
2. Open Neovim, run a package sync (`<leader>ps` or `<leader>pm`), and verify everything is correct.
3. Commit the resolved lockfile.

## Architecture

### Adding an LSP server

`lua/plugins/lsp.lua` has **two separate lists** that must both be updated:

1. **`servers`** — uses **lspconfig names**, passed to `vim.lsp.config` / `vim.lsp.enable`:
   ```lua
   local servers = {
     lua_ls  = { ... },  -- lspconfig name
     gopls   = {},
   }
   ```

2. **`mason_tools`** — uses **Mason registry names**, passed to `mason-tool-installer`:
   ```lua
   local mason_tools = {
     'lua-language-server',  -- Mason name for lua_ls (differs!)
     'gopls',
   }
   ```

lspconfig names and Mason names often differ. Look up the Mason name at
[mason-registry.dev](https://mason-registry.dev/registry/list) and the lspconfig name in the
[lspconfig server list](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md).

System-installed LSPs (not managed by Mason) are added at the bottom of `lsp.lua` with an
`executable` guard — see `nimls` and `gleam` as examples.

### Adding a formatter

Add to `formatters_by_ft` in `lua/plugins/format.lua`. Also add the Mason package name to
`mason_tools` in `lsp.lua` if it needs auto-installation.

To enable format-on-save for a filetype, add it to `fmt_on_save_fts` in `format.lua`.

### Adding treesitter parsers

Add the language name to the `parsers` list in `lua/plugins/treesitter.lua`. Only parsers
not already installed will be fetched on the next launch.

### Adding a plugin

**Personal plugin** — drop a `.lua` file in `lua/custom/plugins/`. It is loaded automatically
and will never conflict with upstream changes:
```lua
-- lua/custom/plugins/harpoon.lua
vim.pack.add { 'https://github.com/ThePrimeagen/harpoon' }
require('harpoon').setup {}
```

**Core plugin** — create `lua/plugins/my_plugin.lua` and register it in the explicit loader
list in `init.lua` (Section 2):
```lua
for _, mod in ipairs {
  ...
  'plugins.my_plugin',  -- add here
} do
```

### Enabling opt-in extras

Extras in `lua/whipsmart/plugins/` are not loaded by default. Enable one from a file in
`lua/custom/plugins/`:
```lua
-- lua/custom/plugins/debug.lua
require 'whipsmart.plugins.debug'
```

Available extras: `autopairs`, `debug` (DAP/Go), `gitsigns` (extended keymaps),
`indent_line`, `lint`, `markdown` (render-markdown + obsidian), `neo-tree`.

### Per-machine configuration (`lua/local.lua`)

`lua/local.lua` is gitignored and loaded at the **end** of Section 1 in `init.lua`, after
all defaults are set, so it can override anything. Copy `lua/local.lua.example` on each
new machine.

Common uses: Nerd Font toggle, colorscheme, GUI font, Python path, enabling opt-in extras,
setting `vim.g.obsidian_vaults` for the markdown extra.

## Markdown / Obsidian setup (`lua/whipsmart/plugins/markdown.lua`)

The markdown opt-in bundles render-markdown.nvim (always) and obsidian.nvim + blink.compat
(gated on `vim.g.obsidian_vaults`).

**To enable on a machine:**

In `lua/local.lua`:
```lua
vim.g.obsidian_vaults = { { name = 'personal', path = '~/Obsidian/Main' } }
```

In `lua/custom/plugins/markdown.lua`:
```lua
require 'whipsmart.plugins.markdown'
```

**Why `require` goes in `custom/plugins/` not `local.lua`:**
`local.lua` runs in Section 1, before `plugins.cmp` loads blink.cmp. The markdown opt-in
calls `require('blink.cmp.config').merge_with(...)` which needs blink.cmp already set up
(Section 2). `custom/plugins/` loads in Section 3, so the timing is correct.

**blink.compat** is added without a version pin (HEAD/main) — released tags lack
`cmp.get_config()` that obsidian.nvim calls internally.

**Completion trigger behaviour in markdown:**

- `[` is removed from `show_on_x_blocked_trigger_characters` so `[[` wikilinks trigger completion.
- `completion.menu.auto_show` suppresses the popup for regular word typing in markdown/text;
  the menu only auto-opens when the trigger character was `[`. Ctrl-Space always works.
- `min_chars = 2` means the menu appears after the second character of a wikilink query.

```lua
-- ctx fields available in auto_show:
--   ctx.trigger.initial_kind      → 'manual' | 'trigger_character' | 'insert_enter'
--   ctx.trigger.initial_character → the character that opened the context (or nil)
```

## Git Remotes

- `origin` → `https://github.com/4rc0s/whipsmart.nvim.git` (Grand Unified config)

Upstream syncing from kickstart.nvim is no longer applicable — whipsmart.nvim is its own project.

## Key Conventions

- `vim.g.have_nerd_font` — gates icon usage throughout the config; defaults to `true`.
  Override in `local.lua` on terminals without a Nerd Font.
- `mason-lspconfig` is kept as a dependency even without an explicit `setup()` call —
  it provides lspconfig↔Mason package name translation that `mason-tool-installer` relies on.
- `blink.cmp` sources use `sources.default`; per-filetype overrides go in `sources.per_filetype`.
- LSP is configured with Neovim's native `vim.lsp.config` / `vim.lsp.enable` API (0.11+),
  not through `lspconfig.server.setup()`.
