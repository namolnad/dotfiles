return {
  "nvim-telescope/telescope.nvim",

  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },

  config = function()
    require('telescope').setup({
      pickers = {
        find_files = {
          find_command = {
            'rg',
            '--hidden',
            '--no-ignore',
            '--files',
            '--smart-case',
            '--glob=!.git/',
            '--glob=!node_modules',
            '--glob=!.DS_Store',
            '--glob=!.vim/undodir/',
          },
          -- vimgrep_argments = { '--hidden', '--glob=!.git/' } -- can't seem to make this work
        },
        live_grep = {
          -- find_command = { 'rg', '--ignore', '--hidden', '--glob=!.git/', '--smart-case' }, -- can't seem to make this work
          file_ignore_patterns = { 'node_modules', 'app/assets/builds', '.git/', 'log/test.log', 'package.lock' },
          additional_args = {
            '--hidden',
            '--no-ignore',
            '--smart-case',
            '--glob=!.git/',
            '--glob=!log/test.log',
            '--glob=!.DS_Store',
          }
        }
      }
    })

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
    vim.keymap.set('n', '<leader>fs', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fm', builtin.man_pages, {})
    vim.keymap.set('n', '<leader>fw', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>fW', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end)
  end
}
