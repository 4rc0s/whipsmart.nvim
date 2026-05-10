# 🌌 Whipsmart.nvim

Whipsmart.nvim is a modular, native-first Neovim configuration built on top of the Neovim 0.12+ `vim.pack` system. It evolved from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) into a modular, machine-aware "Grand Unified" configuration.

## ✨ Features

- **Modular Architecture**: Plugin configurations are isolated in `lua/plugins/*.lua`.
- **Native-First**: Leverages Neovim 0.12's built-in `vim.pack` for plugin management and native LSP/Autocomplete improvements.
- **Ergonomic Dashboard**: Includes `pack-manager.nvim` to provide a polished, Lazy-like UI on top of native primitives.
- **Machine Awareness**: Built-in hostname detection in `init.lua` for machine-specific overrides.
- **Version Pinning**: Uses `nvim-pack-lock.json` for reproducible environments across all your hardware.

## 🚀 Quick Start

### 1. Prerequisites

Ensure you are running **Neovim 0.12+** (nightly or latest stable). You will also need:
- `git`, `make`, `unzip`, `gcc`
- [ripgrep](https://github.com/BurntSushi/ripgrep) and [fd](https://github.com/sharkdp/fd)
- A [Nerd Font](https://www.nerdfonts.com/) (recommended)

### 2. Installation

```sh
# Clone your fork (replace <your_username> with your GitHub handle)
git clone https://github.com/<your_username>/whipsmart.nvim.git ~/.config/nvim

# Start Neovim
nvim
```

## 🛠️ Package Management

Whipsmart provides two ways to manage your plugins:

### The "Lazy" Way (High-Level UI)
Press **`<leader>pm`** to open the **Package Manager Menu**. This dashboard allows you to:
- Check for updates
- Install new plugins
- Disable/Enable existing plugins
- Clean up unused packages

### The "Native" Way (Low-Level Access)
Whipsmart also exposes the raw `vim.pack` primitives:
- **`<leader>ps`**: **Sync** (Triggers `vim.pack.update()` to fetch new metadata).
- **`<leader>pi`**: **Inspect** (View current plugin status offline).
- **`:w`**: Inside the update buffer, write to disk to apply changes.

## 🏗️ Project Layout

```text
~/.config/nvim/
├── init.lua                # Core options, keymaps, and plugin loader
├── UNIFIED.md              # The Grand Unified roadmap and local instructions
├── nvim-pack-lock.json     # Plugin lockfile (Tracked in Git)
└── lua/
    ├── plugins/            # Core plugin modules (explicit load order in init.lua)
    │   ├── pack_manager.lua # pack-manager.nvim UI setup
    │   ├── core_ui.lua     # Which-key, Colorscheme, Oil, Mini.nvim
    │   ├── telescope.lua   # Fuzzy Finding
    │   ├── lsp.lua         # LSP, Mason, and Tooling
    │   ├── cmp.lua         # Autocompletion and Snippets
    │   ├── treesitter.lua  # Syntax Highlighting
    │   └── format.lua      # Conform.nvim Formatting
    ├── whipsmart/          # Opt-in extras (not loaded by default)
    │   ├── health.lua      # :checkhealth whipsmart
    │   └── plugins/        # autopairs, debug, gitsigns+, indent, lint, neo-tree
    └── custom/
        └── plugins/        # Your personal plugins — no merge conflicts here
```

## 💻 Customization

### Adding a Personal Plugin
Drop a `.lua` file in `lua/custom/plugins/` — it is loaded automatically on startup and will never conflict with upstream changes.

Example `lua/custom/plugins/harpoon.lua`:
```lua
vim.pack.add { 'https://github.com/ThePrimeagen/harpoon' }
require('harpoon').setup {}
```

### Adding a Core Plugin
To add a plugin to the core `lua/plugins/` layer, create the file and then register it in the explicit loader list in `init.lua` (Section 2):

```lua
for _, mod in ipairs {
  ...
  'plugins.my_new_plugin',  -- add here
} do
```

### Adding LSP Servers
LSP configuration lives in `lua/plugins/lsp.lua` and has two separate lists that must both be updated:

1. **`servers`** — uses **lspconfig names** (passed to `vim.lsp.config` / `vim.lsp.enable`):
   ```lua
   local servers = {
     lua_ls = { ... },   -- lspconfig name
     pyright = {},       -- lspconfig name
   }
   ```

2. **`mason_tools`** — uses **Mason registry names** (passed to `mason-tool-installer`):
   ```lua
   local mason_tools = {
     'lua-language-server',  -- Mason name for lua_ls
     'pyright',              -- Mason name (happens to match here)
     'stylua',               -- formatter, Mason name
   }
   ```

> **Note:** lspconfig names and Mason names often differ. Look up the correct Mason name at [mason-registry](https://mason-registry.dev/registry/list) and the lspconfig name in the [lspconfig server list](https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md).

### Enabling Format-on-Save
In `lua/plugins/format.lua`, add filetypes to `fmt_on_save_fts`:

```lua
local fmt_on_save_fts = {
  lua = true,
  go  = true,
}
```

### Machine-Specific Settings
Whipsmart uses hostname detection. Open `init.lua` and locate the **Machine Specific Setup** section to add overrides for your specific hardware.

## 📜 Credits
Whipsmart started as a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and maintains its spirit of being a starting point rather than a distribution.
