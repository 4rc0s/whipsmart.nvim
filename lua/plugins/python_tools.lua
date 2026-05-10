local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- PYTHON TOOLS
-- ============================================================

-- Better Python indentation (PEP8 compliant)
-- Handles edge cases that built-in Python indent doesn't
vim.pack.add { gh 'Vimjas/vim-python-pep8-indent' }
