return {
  {
    'folke/trouble.nvim',
    dependencies = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      local trouble = require 'trouble'

      trouble.setup {
        icons = true,
      }

      vim.keymap.set('n', '<leader>tt', function()
        trouble.toggle()
      end)
      vim.keymap.set('n', '<leader>tw', function()
        trouble.toggle 'workspace_diagnostics'
      end)
      vim.keymap.set('n', '<leader>td', function()
        trouble.toggle 'document_diagnostics'
      end)
      vim.keymap.set('n', '<leader>tq', function()
        trouble.toggle 'quickfix'
      end)
      vim.keymap.set('n', '<leader>tl', function()
        trouble.toggle 'loclist'
      end)

      vim.keymap.set('n', 'gR', function()
        trouble.toggle 'lsp_references'
      end)

      vim.keymap.set('n', '[t', function()
        trouble.next { skip_groups = true, jump = true }
      end)
      vim.keymap.set('n', ']t', function()
        trouble.previous { skip_groups = true, jump = true }
      end)
    end,
  },
}
