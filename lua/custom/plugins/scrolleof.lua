local function gh(repo) return 'https://github.com/' .. repo end

vim.pack.add { gh 'Aasim-A/scrollEOF.nvim' }

require('scrollEOF').setup {
  disabled_filetypes = { 'snacks_terminal' },
}
