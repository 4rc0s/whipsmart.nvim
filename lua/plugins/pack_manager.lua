local function gh(repo) return 'https://github.com/' .. repo end

-- ============================================================
-- PACK-MANAGER.NVIM
-- Lazy-like UI dashboard for vim.pack
-- ============================================================

vim.pack.add { gh 'mplusp/pack-manager.nvim' }

-- Keymap to open the dashboard
vim.keymap.set('n', '<leader>pm', '<cmd>PackMenu<cr>', { desc = '[P]ackage [M]anager (UI)' })
