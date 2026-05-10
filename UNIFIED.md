# 🌌 Grand Unified Neovim (4rc0s/my-kickstart)

This is the unified Neovim configuration for all my machines, based on the Neovim 0.12+ native `vim.pack` system.

## 🚀 Native Package Workflow (0.12+)
Since we moved from Lazy to `vim.pack`, the workflow is buffer-centric:
1. `<leader>ps`: **Sync** (Fetch updates from Git).
2. `w`: **Apply** (Inside the update buffer, write to disk/install).
3. `q`: **Quit** the update buffer.
4. `<leader>pi`: **Inspect** (Check current offline status).

## 💻 Machine Detection
We use `vim.uv.os_gethostname()` in `init.lua` to toggle settings.
Current machines:
- **vera**: (Primary Linux workstation) - High-res font, full LSP suite.

## 🗺️ The Grand Unified Roadmap
- [x] Migrate to Neovim 0.12 `vim.pack`.
- [x] Set up personal fork and unified remote (`origin`).
- [x] Implement ergonomic keymaps for native package management.
- [ ] Merge legacy plugins from other machine forks.
- [ ] Add machine-specific UI toggles for terminal vs. GUI Neovim.
- [ ] Centralize snippet collections.

## 🛠️ Git Maintenance
- **Upstream:** `https://github.com/nvim-lua/kickstart.nvim`
- **Origin:** `https://github.com/4rc0s/my-kickstart`
- **Syncing:** `git fetch upstream && git merge upstream/master`
