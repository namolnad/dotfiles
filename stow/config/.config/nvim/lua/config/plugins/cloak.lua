return function()
  local cloak = require 'cloak'
  cloak.setup {
    enabled = true,
    cloak_character = '*',
    highlight_group = 'Comment',
    patterns = {
      {
        file_pattern = {
          '.env*',
          'wrangler.toml',
          '.dev.vars',
          '.credentials',
          '*-production.yml',
          '*-development.yml',
          '*-test.yml',
        },
        cloak_pattern = {
          '=.+',
          ':.+',
        },
      },
    },
  }
  vim.keymap.set('n', '<leader>ct', cloak.toggle, { desc = '[C]loak: [T]oggle' })
end
