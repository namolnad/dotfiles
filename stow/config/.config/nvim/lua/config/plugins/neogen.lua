return function()
  local neogen = require 'neogen'

  neogen.setup {
    snippet_engine = 'luasnip',
  }

  vim.keymap.set('n', '<leader>nf', function()
    neogen.generate { type = 'func' }
  end, { desc = '[N]eoGen: Generate annotations for current [f]unction' })

  vim.keymap.set('n', '<leader>nt', function()
    neogen.generate { type = 'type' }
  end, { desc = '[N]eoGen: Generate annotations for current [t]ype' })
end
