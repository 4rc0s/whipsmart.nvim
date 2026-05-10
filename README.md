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
├── init.lua                # Core options, keymaps, and modular loader
├── UNIFIED.md              # The Grand Unified roadmap and local instructions
├── nvim-pack-lock.json     # Plugin lockfile (Tracked in Git)
└── lua/
    └── plugins/            # Individual plugin modules
        ├── core_ui.lua     # Which-key, Colorscheme, Oil, Mini.nvim
        ├── lsp.lua         # LSP, Mason, and Tooling
        ├── telescope.lua   # Fuzzy Finding
        ├── cmp.lua         # Autocompletion and Snippets
        ├── treesitter.lua  # Syntax Highlighting
        ├── format.lua      # Conform.nvim Formatting
        └── pack_manager.lua # pack-manager.nvim UI setup
```

## 💻 Customization

### Adding a New Plugin
To add a plugin, create a new `.lua` file in `lua/plugins/`. Whipsmart will automatically detect and load it.

Example `lua/plugins/harpoon.lua`:
```lua
vim.pack.add({ "https://github.com/ThePrimeagen/harpoon" })
-- Your configuration here
```

### Machine-Specific Settings
Whipsmart uses hostname detection. Open `init.lua` and locate the **Machine Specific Setup** section to add overrides for your specific hardware.

## 📜 Credits
Whipsmart started as a fork of [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) and maintains its spirit of being a starting point rather than a distribution.
