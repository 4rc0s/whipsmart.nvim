-- Plugins deliberately dropped from this config.
--
-- `vim.pack.del` only acts on the machine it runs on. Every other machine still has the plugin's
-- directory, and on startup vim.pack rebuilds the missing lockfile entry from it ("Repaired
-- corrupted lock data"), which the next `pack update` commit would push back upstream. Listing a
-- name here deletes that directory on every machine once all plugin modules have loaded.
--
-- Only inactive plugins are deleted, so a name re-added to the config without being taken off this
-- list is left alone. Entries cost nothing once a machine is clean and can stay indefinitely.
local removed = {
  'mason-lspconfig.nvim', -- intentionally unused; lsp.lua spells out Mason names itself
  'nvim', -- catppuccin/nvim before it was given an explicit `name = 'catppuccin'`
}

vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    -- Not `vim.pack.get(removed)`: given names, it errors if any one of them is not installed,
    -- which is the normal state on a machine that is already clean.
    local stale = vim
      .iter(vim.pack.get(nil, { info = false }))
      :filter(function(p) return not p.active and vim.tbl_contains(removed, p.spec.name) end)
      :map(function(p) return p.spec.name end)
      :totable()
    if #stale > 0 then vim.pack.del(stale) end
  end,
})
