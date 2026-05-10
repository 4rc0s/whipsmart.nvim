--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   WHIPSMART.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================

What is Whipsmart?

  Whipsmart.nvim is a modular, native-first Neovim configuration 
  built on top of the Neovim 0.12+ `vim.pack` system.

  It is designed to be:
  - Modular: Plugin configs are split into `lua/plugins/*.lua`.
  - Native: Uses built-in `vim.pack` and 0.12+ features.
  - Ergonomic: Includes `pack-manager.nvim` for a Lazy-like UI.

  See UNIFIED.md for the Grand Unified roadmap and local instructions.

--]]

-- ============================================================
-- SECTION 1: FOUNDATION
-- Core Neovim settings, leaders, options, basic keymaps, basic autocmds
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  -- See `:help mapleader`
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- [[ Machine Specific Setup ]]
  local hostname = vim.uv.os_gethostname()
  if hostname == 'vera' then
    -- Vera specific settings
  elseif hostname == 'tau' then
    -- tau specific settings
  elseif hostname == 'hecate' then
    -- hecate specific settings
  end

  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  --  See `:help vim.o`
  vim.o.number = true
  vim.o.relativenumber = true
  vim.o.mouse = 'a'
  vim.o.showmode = false
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
  vim.o.breakindent = true
  vim.o.undofile = true
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.signcolumn = 'yes'
  vim.o.updatetime = 250
  vim.o.timeoutlen = 300
  vim.o.splitright = true
  vim.o.splitbelow = true
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
  vim.o.inccommand = 'split'
  vim.o.cursorline = true
  vim.o.scrolloff = 10
  vim.o.confirm = true
  vim.o.colorcolumn = '120'
  vim.o.expandtab = false
  vim.opt.isfname:append '@-@'

  -- [[ Basic Keymaps ]]
  --  See `:help vim.keymap.set()`
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostic Config
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    virtual_text = true,
    virtual_lines = false,
    jump = {
      on_jump = function(_, bufnr)
        vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false }
      end,
    },
  }

  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
  vim.keymap.set('n', '[d', function() vim.diagnostic.jump { count = -1 } end, { desc = 'Go to previous [D]iagnostic' })
  vim.keymap.set('n', ']d', function() vim.diagnostic.jump { count = 1 } end, { desc = 'Go to next [D]iagnostic' })
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Split navigation
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Highlight when yanking
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('whipsmart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })
end

-- ============================================================
-- SECTION 2: PLUGIN LOADER
-- vim.pack events and modular plugin loading
-- ============================================================
do
  -- Built-in vim.pack keymaps for low-level access
  vim.keymap.set('n', '<leader>ps', vim.pack.update, { desc = '[P]ackage [S]ync' })
  vim.keymap.set('n', '<leader>pi', function() vim.pack.update(nil, { offline = true }) end, { desc = '[P]ackage [I]nspect' })

  -- Build steps logic
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      vim.notify(('Build failed for %s:\n%s'):format(name, result.stderr or result.stdout or 'No output'), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
      elseif name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
      elseif name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
      end
    end,
  })

  -- Load plugin modules in explicit order
  for _, mod in ipairs {
    'plugins.pack_manager',
    'plugins.core_ui',
    'plugins.telescope',
    'plugins.lsp',
    'plugins.cmp',
    'plugins.treesitter',
    'plugins.format',
  } do
    require(mod)
  end

  -- Load user custom plugins from lua/custom/plugins/
  require 'custom.plugins'
end

-- vim: ts=2 sts=2 sw=2 et
