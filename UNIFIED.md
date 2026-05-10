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
`indent_line`, `lint`, `neo-tree`.

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
