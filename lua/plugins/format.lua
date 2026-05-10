local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- FORMATTING
-- conform.nvim setup and keymap
-- ============================================================

vim.pack.add { gh 'stevearc/conform.nvim' }

-- Add filetypes here to enable format-on-save for them, e.g. lua = true
local fmt_on_save_fts = {}

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    if fmt_on_save_fts[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end
  end,
  default_format_opts = { lsp_format = 'fallback' },
  formatters_by_ft = {},
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })
