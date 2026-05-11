# Whipsmart Architecture

Unified Neovim configuration for all machines.

## Core Philosophy

1.  **Universal Core:** Every machine runs the same core `init.lua` and `lua/plugins/*.lua`.
2.  **Explicit Extras:** Functionality like LSP, Debugging, and Linting are handled by a thin wrapper (`lua/whipsmart/plugins/*.lua`) that only initializes if the underlying plugin is present in `nvim-pack-lock.json`.
3.  **Machine Overrides:** Machine-specific settings (background color, UI toggles, custom keymaps) live in `lua/local.lua` (git-ignored).
4.  **Lockfile Driven:** The `nvim-pack-lock.json` file is the source of truth for installed plugins and their versions.

## Directory Structure

```text
~/.config/nvim/
├── init.lua                # Main entry point (Section 1: Options, Section 2: Plugins, Section 3: LSP/Extra Config)
├── nvim-pack-lock.json     # Plugin manifest and lockfile
├── lua/
│   ├── local.lua           # (Git-ignored) Machine-specific overrides
│   ├── plugins/            # Universal plugin specifications
│   │   ├── core_ui.lua     # basic UI, icons, statusline
│   │   ├── telescope.lua   # fuzzy finder
│   │   └── ...
│   ├── custom/             # Custom plugin specs or opt-in extras
│   │   └── ...
│   └── whipsmart/          # Internal framework
│       ├── health.lua      # :checkhealth whipsmart
│       └── plugins/        # Conditional wrappers for LSP, DAP, Lint, etc.
│           ├── lsp.lua     # only runs if 'neovim/nvim-lspconfig' is in lockfile
│           └── ...
└── doc/
    └── whipsmart.txt       # Vim help doc
```

## Adding a Plugin

1.  Add the plugin to `nvim-pack-lock.json`.
2.  Add a configuration file in `lua/plugins/` (for universal plugins) or `lua/custom/plugins/` (for extras).
3.  Restart Neovim and run `:Pack install`.

## Migration Guide (Hecate -> Whipsmart)

The goal is to move all machine-specific logic out of the main config and into `lua/local.lua`.

### Step 1: Initialize local.lua
```bash
cp ~/.config/nvim/lua/local.lua.example ~/.config/nvim/lua/local.lua
```

### Step 2: LSP Configuration
LSP configuration requires two entries in `lua/local.lua`:
1.  `vim.g.lsp_servers`: A list of LSP servers to ensure are installed via Mason.
2.  `vim.g.lsp_config`: A table mapping server names to their `lspconfig` setup tables.

Example:
```lua
vim.g.lsp_servers = { 'pyright', 'rust_analyzer' }
vim.g.lsp_config = {
  pyright = {
    settings = {
      python = {
        analysis = { autoSearchPaths = true }
      }
    }
  }
}
```

## Status / Roadmap

- [x] Initial structure and Section 1-3 implementation.
- [x] Port core plugins (telescope, treesitter, etc.).
- [x] Implement `whipsmart.plugins` conditional loading.
- [x] Move per-machine overrides to `local.lua`.
- [x] Fix `local.lua` load order — `pcall(require, 'local')` moved to end of Section 1 so it can override defaults.
- [x] Add markdown opt-in extra (render-markdown, obsidian, blink.compat).
- [x] Migrate roci to whipsmart.
- [x] Migrate orca to whipsmart (machine-specific scrolloff and catppuccin in local.lua).
- [x] Migrate cygnus to whipsmart (machine-specific keymaps and plugins mainlined).
- [x] Unify Go configuration (Tabs, width 4) as a global standard in init.lua.
- [x] Unify Python configuration (Spaces, width 4, textwidth 88) in init.lua.
- [x] Migrate tau to whipsmart (create lua/local.lua).
- [ ] Migrate vera to whipsmart (create lua/local.lua).
- [ ] Add machine-specific UI toggles for terminal vs. GUI Neovim (via local.lua).
- [ ] Centralize snippet collections.
