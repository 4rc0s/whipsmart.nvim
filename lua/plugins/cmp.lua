local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- AUTOCOMPLETE & SNIPPETS
-- blink.cmp and luasnip setup
-- ============================================================

vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
require('luasnip').setup {}

vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }

local is_arm32 = jit.arch == 'arm' or vim.uv.os_uname().machine:match 'armv7'
local has_cargo = vim.fn.executable 'cargo' == 1

require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
  sources = { default = { 'lsp', 'path', 'snippets' } },
  snippets = { preset = 'luasnip' },
  fuzzy = {
    -- Fallback to Lua on 32-bit ARM if Rust is not buildable
    implementation = (is_arm32 and not has_cargo) and 'lua' or 'prefer_rust',
  },
  prebuilt_binaries = {
    -- 32-bit ARM prebuilt binaries are not currently provided by blink.cmp
    download = not is_arm32,
  },
  signature = { enabled = true },
}

-- Autopairs
vim.pack.add { gh 'windwp/nvim-autopairs' }
require('nvim-autopairs').setup {}
