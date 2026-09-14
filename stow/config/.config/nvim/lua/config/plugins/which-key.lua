return function()
  local wk = require('which-key')
  wk.setup {}
  wk.add({ { '<leader>l', group = 'Plugins (vim.pack)' } })
  vim.keymap.set('n', '<leader>?', function()
    wk.show({ global = false })
  end, { desc = 'WhichKey: Buffer Local Keymaps' })
end
