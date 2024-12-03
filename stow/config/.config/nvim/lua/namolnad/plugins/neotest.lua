return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/nvim-nio',
      'zidhuss/neotest-minitest',
    },
    config = function()
      local neotest = require 'neotest'
      local config = require 'neotest.config'
      config.adapters = {
        -- ruby
        require 'neotest-minitest' {
          test_cmd = function()
            return vim.tbl_flatten {
              'bundle',
              'exec',
              'rails',
              'test',
            }
          end,
        },
      }
      neotest.setup(config)

      -- Test closest
      vim.keymap.set('n', '<leader>tc', function()
        neotest.run.run()
      end, { desc = 'Run closest test' })

      -- Test file
      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run(vim.fn.expand '%')
      end, { desc = 'Test current file' })

      -- Debug the nearest test
      vim.keymap.set('n', '<leader>tD', function()
        neotest.run.run { strategy = 'dap', suite = false }
      end, { desc = 'Debug the nearest test' })
    end,
  },
}
