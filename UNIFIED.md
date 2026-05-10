# 🌌 Whipsmart Neovim (4rc0s/whipsmart.nvim)

This is the **Grand Unified** Neovim configuration for all my machines, built on the Neovim 0.12+ native `vim.pack` system with a modern modular architecture.

## 🚀 Native Package Workflow (0.12+)
We use **`pack-manager.nvim`** for a Lazy-like UI experience:
1. `<leader>pm`: Open the **Package Manager Menu**.
2. From the menu, you can Update, Install, or Manage plugins.

**Low-level access:**
- `<leader>ps`: **Sync** (Fetch updates via native `vim.pack.update()`).
- `<leader>pi`: **Inspect** (Native offline status).

## 🏗️ Modular Architecture
Plugin configurations are split into logically organized files in `lua/plugins/`:
- `pack_manager.lua`: The `pack-manager.nvim` UI wrapper.
- `core_ui.lua`: UI enhancements (Colorscheme, Gitsigns, Mini, etc.).
- `telescope.lua`: Fuzzy finding and LSP navigation.
- `lsp.lua`: Language Server Protocol and Mason setup.
- `cmp.lua`: Autocompletion and Snippets.
- `treesitter.lua`: Syntax highlighting and parsing.
- `format.lua`: Auto-formatting via `conform.nvim`.

Modules are loaded in this explicit order from `init.lua` (Section 2).

**Opt-in extras** live in `lua/whipsmart/plugins/` and are not loaded by default.
To enable one, require it from a file in `lua/custom/plugins/`:
```lua
-- lua/custom/plugins/debug.lua
require 'whipsmart.plugins.debug'
```

Available extras: `autopairs`, `debug` (DAP/Go), `gitsigns` (extended keymaps),
`indent_line`, `lint`, `markdown` (render-markdown + obsidian), `neo-tree`.

The `markdown` extra reads `vim.g.obsidian_vaults` from `local.lua` to configure
obsidian.nvim; render-markdown loads unconditionally. Example `local.lua` snippet:
```lua
vim.g.obsidian_vaults = { { name = 'personal', path = '~/Obsidian/Main' } }
```
Then activate in `lua/custom/plugins/markdown.lua`:
```lua
require 'whipsmart.plugins.markdown'
```

## 💻 Per-Machine Local Config
Each machine maintains a `lua/local.lua` that is **gitignored** and never committed.
`init.lua` loads it at startup via `pcall(require, 'local')` — silently skipped if absent.

Use it for anything machine-specific: font size, colorscheme overrides, GUI settings,
local interpreter paths, or enabling whipsmart opt-in extras only on that machine.

See `lua/local.lua.example` for a documented template.

**Setup on a new machine:**
```sh
git clone git@github.com:4rc0s/whipsmart.nvim.git ~/.config/nvim
cp ~/.config/nvim/lua/local.lua.example ~/.config/nvim/lua/local.lua
# Edit lua/local.lua for this machine, then launch nvim
```

## 🚀 Migration & New Machine Guide

When moving a new machine to Whipsmart, follow these lessons learned from the `orca` migration:

### 1. The Migration Workflow
If coming from a `lazy.nvim` or single-file config:
- **Core Settings:** Move personal preferences (colorschemes, font sizes, scrolloff) to `lua/local.lua`.
- **Custom Plugins:** Do not edit the core `lua/plugins/` files. Instead, create a new file in `lua/custom/plugins/<name>.lua` for each additional plugin:
  ```lua
  -- Example: lua/custom/plugins/harpoon.lua
  vim.pack.add { 'https://github.com/ThePrimeagen/harpoon' }
  require('harpoon').setup({})
  ```

### 2. Standardize vs. Localize
Before adding a setting to `local.lua`, ask: *"Would every machine benefit from this?"*
- **YES (Global):** Add to `init.lua` or `lua/plugins/`. (Example: Our unified Go indentation standard).
- **NO (Local):** Keep in `lua/local.lua`. (Example: Machine-specific `scrolloff` or `catppuccin` preference).

### 3. Headless Bootstrapping
For a "ready-to-code" experience on a fresh install, run this command to install all plugins and treesitter parsers without opening the UI:
```bash
nvim --headless +PackUpdate +TSUpdateSync +qa
```

### 4. LSP Server Troubleshooting
LSP configuration requires two entries in `lua/plugins/lsp.lua`:
1. The **lspconfig name** in the `servers` table (controls the logic).
2. The **Mason registry name** in the `mason_tools` list (controls the installation).
*Note: These names often differ (e.g., `ts_ls` vs `typescript-language-server`).*

## 🗺️ The Grand Unified Roadmap
- [x] Rename project to **whipsmart.nvim**.
- [x] Refactor into a modular architecture.
- [x] Install `pack-manager.nvim` for an ergonomic frontend.
- [x] Complete rebrand — remove all `kickstart-*` augroup names and namespaces.
- [x] Fix `lua/custom/plugins/` loading (was silently never called).
- [x] Explicit plugin load order in `init.lua`.
- [x] Decouple Mason package names from lspconfig server names.
- [x] Document LSP server setup and opt-in extras workflow.
- [x] Replace hostname detection with gitignored lua/local.lua per-machine overrides.
- [x] Port hecate config: LSP servers, formatters, treesitter parsers, custom plugins.
- [x] Fix `local.lua` load order — `pcall(require, 'local')` moved to end of Section 1 so it can override defaults.
- [x] Add markdown opt-in extra (render-markdown, obsidian, blink.compat).
- [x] Migrate roci to whipsmart.
- [x] Migrate orca to whipsmart (machine-specific scrolloff and catppuccin in local.lua).
- [x] Unify Go configuration (Tabs, width 4) as a global standard in init.lua.
- [ ] Migrate vera and tau to whipsmart (create their lua/local.lua files).
- [ ] Add machine-specific UI toggles for terminal vs. GUI Neovim (via local.lua).
- [ ] Centralize snippet collections.

## 🛠️ Git Maintenance
- **Origin:** `https://github.com/4rc0s/whipsmart.nvim`

> This project has diverged significantly from its kickstart.nvim origin in
> architecture and philosophy. Upstream syncing from kickstart.nvim is no
> longer applicable — whipsmart.nvim is its own project.

### Tracking Key Upstream Dependencies

**`pack-manager.nvim`** (`https://github.com/mplusp/pack-manager.nvim`) is the
UI layer over `vim.pack` and the most architecturally significant third-party
dependency. Watch this repo for new features, API changes, and bug fixes.

To pick up an improvement:
1. Check the [pack-manager.nvim releases/commits](https://github.com/mplusp/pack-manager.nvim/commits/main) for relevant changes.
2. Run `<leader>ps` to pull the latest revision and update `nvim-pack-lock.json`.
3. Commit the updated lockfile to pin the new version.
