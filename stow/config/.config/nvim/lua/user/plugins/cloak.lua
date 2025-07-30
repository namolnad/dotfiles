return {
  'laytan/cloak.nvim',
  config = function()
    local cloak = require 'cloak'
    cloak.setup {
      enabled = true,
      cloak_character = '*',
      -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
      highlight_group = 'Comment',
      patterns = {
        {
          -- Match any file starting with ".env".
          -- This can be a table to match multiple file patterns.
          file_pattern = {
            '.env*',
            'wrangler.toml',
            '.dev.vars',
            '.credentials',
            '*-production.yml',
            '*-development.yml',
            '*-test.yml',
          },
          -- Match an equals sign and any character after it.
          -- This can also be a table of patterns to cloak,
          -- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
          cloak_pattern = {
            '=.+',
            ':.+',
          },
        },
      },
    }

    -- Add a command to toggle the cloak plugin. via <leader>ct
    vim.keymap.set('n', '<leader>ct', cloak.toggle, { desc = '[C]loak: [T]oggle' })
  end,
}
