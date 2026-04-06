return function()
  local wk = require('which-key')
  wk.setup {}
  vim.keymap.set('n', '<leader>?', function()
    wk.show({ global = false })
  end, { desc = 'WhichKey: Buffer Local Keymaps' })
end
