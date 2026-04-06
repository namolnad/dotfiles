return function()
  require('flash').setup {
    modes = {},
  }
  -- stylua: ignore start
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>s', function() require('flash').jump() end, { desc = 'Flash: [s]earch' })
  vim.keymap.set({ 'n', 'x', 'o' }, '<leader>S', function() require('flash').treesitter() end, { desc = 'Flash: [S]earch for Treesitter nodes' })
  vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Flash: [r]emote' })
  vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Flash: Treesitter Search' })
  vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Flash: Toggle during Search' })
  -- stylua: ignore end
end
