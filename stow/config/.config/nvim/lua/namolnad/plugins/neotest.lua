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
            return vim.iter({
              'bundle',
              'exec',
              'rails',
              'test',
            }):flatten()
          end,
        },
      }
      neotest.setup(config)

      -- Test closest
      vim.keymap.set('n', '<leader>tc', function()
        neotest.run.run()
      end, { desc = '[T]est [c]losest/current test' })

      -- Test file
      vim.keymap.set('n', '<leader>tf', function()
        neotest.run.run(vim.fn.expand '%')
      end, { desc = '[T]est current [f]ile' })

      -- Debug the nearest test
      vim.keymap.set('n', '<leader>tD', function()
        neotest.run.run { strategy = 'dap', suite = false }
      end, { desc = '[T]est and [d]ebug closest/current' })
    end,
  },
}
