return function()
  local neogen = require 'neogen'

  -- Neovim's own snippets, which blink's <Tab> knows how to jump through
  neogen.setup {
    snippet_engine = 'nvim',
  }

  vim.keymap.set('n', '<leader>nf', function()
    neogen.generate { type = 'func' }
  end, { desc = '[N]eoGen: Generate annotations for current [f]unction' })

  vim.keymap.set('n', '<leader>nt', function()
    neogen.generate { type = 'type' }
  end, { desc = '[N]eoGen: Generate annotations for current [t]ype' })
end
