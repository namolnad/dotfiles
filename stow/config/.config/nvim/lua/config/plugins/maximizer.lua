return function()
  local maximizer = require('maximizer')
  maximizer.setup {}
  vim.keymap.set('n', '<leader>z', function()
    maximizer.toggle()
  end, { desc = 'Maximize window' })
end
