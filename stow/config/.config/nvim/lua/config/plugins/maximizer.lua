return {
  '0x00-ketsu/maximizer.nvim',
  config = function()
    local maximizer = require('maximizer')
    maximizer.setup {}
    vim.keymap.set('n', '<leader>z', function()
      maximizer.toggle()
    end, { desc = 'Maximize window' })
  end
}
