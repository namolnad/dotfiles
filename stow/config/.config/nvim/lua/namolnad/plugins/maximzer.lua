return {
  '0x00-ketsu/maximizer.nvim',
  config = function()
    local maximizer = require 'maximizer'
    maximizer.setup()
    vim.keymap.set('n', '<leader>mm', maximizer.toggle, { silent = true, noremap = true, desc = '[M]aximzer: Toggle' })
    vim.keymap.set('n', '<leader>mw', maximizer.maximize, { silent = true, noremap = true, desc = '[M]aximizer: Maximize current window' })
    vim.keymap.set('n', '<leader>mr', maximizer.restore, { silent = true, noremap = true, desc = '[M]aximizer: Restore' })
  end,
}
