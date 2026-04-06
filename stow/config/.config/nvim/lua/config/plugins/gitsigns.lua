return function()
  local gitsigns = require 'gitsigns'
  gitsigns.setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  }
  vim.keymap.set('n', '<leader>gp', gitsigns.preview_hunk, { desc = '[G]itsigns: Preview hunk' })
  vim.keymap.set('n', '<leader>gb', gitsigns.toggle_current_line_blame, { desc = '[G]itsigns: Toggle git blame' })
end
