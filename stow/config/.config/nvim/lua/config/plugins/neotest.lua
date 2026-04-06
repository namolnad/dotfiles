return function()
  local neotest = require 'neotest'
  local config = require 'neotest.config'
  config.adapters = {
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
    require 'neotest-rspec',
  }
  neotest.setup(config)

  vim.keymap.set('n', '<leader>tc', function()
    neotest.run.run()
  end, { desc = 'NeoTest: [T]est [c]losest/current test' })

  vim.keymap.set('n', '<leader>tC', function()
    neotest.run.run(vim.fn.expand '%')
  end, { desc = 'NeoTest: [T]est [C]urrent file' })

  vim.keymap.set('n', '<leader>tD', function()
    neotest.run.run { strategy = 'dap', suite = false }
  end, { desc = 'NeoTest: [T]est and [d]ebug closest/current' })
end
