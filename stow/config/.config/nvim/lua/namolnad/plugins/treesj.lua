return {
  'Wansmer/treesj',
  -- keys = { '<space>m', '<space>j', '<space>s' },
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  config = function()
    local tsj_utils = require 'treesj.langs.utils'
    local ruby = require 'treesj.langs.ruby'
    local options = {
      join = {
        space_in_brackets = false,
      },
    }

    local langs = {
      ruby = tsj_utils.merge_preset(ruby, {
        array = tsj_utils.set_preset_for_list(options),
      }),
    }
    local treesj = require('treesj')
    treesj.setup {
      langs = langs,
    }
    vim.keymap.set('n', '<leader>m', '<cmd>TSJToggle<CR>', { desc = 'TreeSJ: Split or Join codeblock with autodetect' })
    vim.keymap.set('n', '<leader>j', '<cmd>TSJJoin<CR>', { desc = 'TreeSJ: [j]oin codeblock' })
    vim.keymap.set('n', '<leader>J', '<cmd>TSJSplit<CR>', { desc = 'TreeSJ: Split (Un[J]oin) codeblock' })
  end,
}
