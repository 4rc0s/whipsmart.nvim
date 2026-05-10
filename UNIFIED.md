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
- `core_ui.lua`: UI enhancements (Colorscheme, Gitsigns, Mini, etc.).
- `telescope.lua`: Fuzzy finding and LSP navigation.
- `lsp.lua`: Language Server Protocol and Mason setup.
- `format.lua`: Auto-formatting via `conform.nvim`.
- `cmp.lua`: Autocompletion and Snippets.
- `treesitter.lua`: Syntax highlighting and parsing.
- `pack_manager.lua`: The `pack-manager.nvim` UI wrapper.

## 💻 Machine Detection
We use `vim.uv.os_gethostname()` in `init.lua` to toggle settings.
Current machines:
- **vera**: (Primary Linux workstation) - High-res font, full LSP suite.

## 🗺️ The Grand Unified Roadmap
- [x] Rename project to **whipsmart.nvim**.
- [x] Refactor into a modular architecture.
- [x] Install `pack-manager.nvim` for an ergonomic frontend.
- [ ] Merge legacy plugins from other machine forks.
- [ ] Add machine-specific UI toggles for terminal vs. GUI Neovim.
- [ ] Centralize snippet collections.

## 🛠️ Git Maintenance
- **Upstream:** `https://github.com/nvim-lua/kickstart.nvim`
- **Origin:** `https://github.com/4rc0s/whipsmart.nvim`
- **Syncing:** `git fetch upstream && git merge upstream/master`
