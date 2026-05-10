local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- UI / CORE UX PLUGINS
-- guess-indent, gitsigns, which-key, colorscheme, todo-comments, mini modules
-- ============================================================

-- Detect and set indentation
vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
require('guess-indent').setup {}

-- Pretty icons (if Nerd Font is available)
if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end

-- Git related signs in the gutter
vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Keybind popup
vim.pack.add { gh 'folke/which-key.nvim' }
require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}

-- Colorscheme
vim.pack.add { gh 'folke/tokyonight.nvim' }
require('tokyonight').setup {
  styles = {
    comments = { italic = false },
  },
}
vim.cmd.colorscheme 'tokyonight-night'

-- File explorer
vim.pack.add { gh 'stevearc/oil.nvim' }
require('oil').setup {
  view_options = { show_hidden = true },
}
vim.keymap.set('n', '-', '<cmd>Oil<cr>', { desc = 'Open parent directory' })

-- TODO comments
vim.pack.add { gh 'folke/todo-comments.nvim' }
require('todo-comments').setup { signs = false }

-- mini.nvim modules
vim.pack.add { gh 'nvim-mini/mini.nvim' }
require('mini.ai').setup {
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}
require('mini.surround').setup()
local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }
statusline.section_location = function() return '%2l:%-2v' end
