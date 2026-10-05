return function()
  local cloak = require 'cloak'
  cloak.setup {
    enabled = true,
    cloak_character = '*',
    highlight_group = 'Comment',
    patterns = {
      {
        -- Shared with blink/minuet, which stay switched off in these files
        file_pattern = require('config.modules.secrets').patterns,
        cloak_pattern = {
          '=.+',
          ':.+',
        },
      },
    },
  }
  vim.keymap.set('n', '<leader>ct', cloak.toggle, { desc = '[C]loak: [T]oggle' })
end
