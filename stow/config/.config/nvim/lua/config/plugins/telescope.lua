return function()
  local telescope = require 'telescope'

  telescope.setup {
    defaults = {
      mappings = {
        i = { ['<c-enter>'] = 'to_fuzzy_refine' },
      },
      dynamic_preview_title = true,
    },
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
          '--glob=!.rbenv/versions/',
          '--glob=!.rbenv/shims/',
          '--glob=!stow/config/.config/alfred',
          '--glob=!tmp/**/*'
        },
      },
      live_grep = {
        file_ignore_patterns = {
          'node_modules',
          'app/assets/builds',
          '.git/',
          'log/',
          'package.lock',
          'rbenv/versions',
          'rbenv/shims',
          'alfredpreferences',
          'tmp/',
        },
        additional_args = {
          '--hidden',
          '--no-ignore',
          '--smart-case',
          '--glob=!.git/',
          '--glob=!log/test.log',
          '--glob=!.DS_Store',
          '--glob=!.vim/undodir/',
          '--glob=!tmp/**/*'
        },
      },
    },
    extensions = {
      ['ui-select'] = {
        require('telescope.themes').get_dropdown(),
      },
      frecency = {
        auto_validate = true,
        show_scores = true,
        show_unindexed = true,
        ignore_patterns = { '*.git/*', '*/tmp/*' },
        workspaces = {
          ['CWD'] = vim.fn.getcwd(),
          ['nvim'] = vim.fn.stdpath 'config',
        },
      },
      fzf = {
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = 'smart_case',
      },
    },
  }

  -- Load extensions (fzf only if make was available)
  if vim.fn.executable('make') == 1 then
    pcall(telescope.load_extension, 'fzf')
  end
  telescope.load_extension 'ui-select'
  telescope.load_extension 'frecency'

  local builtin = require 'telescope.builtin'

  vim.keymap.set('n', '<leader>fs',
    require "config.modules.telescope.multi-ripgrep",
    { desc = 'Telescope: [F]ind [S]tring by MultiGrep' })
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope: [F]ind [H]elp' })
  vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = 'Telescope: [F]ind [K]eymaps' })
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope: [F]ind [F]iles' })
  vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = 'Telescope: [F]ind [T]elescope commands' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope: [F]ind by [g]rep' })
  vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Telescope: [F]ind [D]iagnostics' })
  vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = 'Telescope: [F]ind [M]an pages' })
  vim.keymap.set('n', '<leader>fG', builtin.git_files, { desc = 'Telescope: [F]ind [G]it files' })
  vim.keymap.set('n', '<leader>fR', builtin.resume, { desc = 'Telescope: [F]ind [R]esume' })
  vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Telescope: [F]ind [R]egisters' })
  vim.keymap.set('n', '<leader>f.', '<cmd>Telescope frecency workspace=CWD<cr>',
    { desc = 'Telescope: [F]ind [O]ld / recent files' })
  vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Telescope: [F]ind [O]ld Files' })
  vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope: [F]ind Open [B]uffers' })
  vim.keymap.set('n', '<leader>fw', function()
    local word = vim.fn.expand '<cword>'
    builtin.grep_string { search = word }
  end, { desc = 'Telescope: [F]ind current [W]ord' })
  vim.keymap.set('n', '<leader>fW', function()
    local word = vim.fn.expand '<cWORD>'
    builtin.grep_string { search = word }
  end, { desc = 'Telescope: [F]ind current [W]ord' })
  vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false, })
  end, { desc = 'Telescope: [/] Fuzzily search in current buffer' })
  vim.keymap.set('n', '<leader>f/', function()
    builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files', }
  end, { desc = 'Telescope: [F]ind [/] in Open Files' })
  vim.keymap.set('n', '<leader>fn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = 'Telescope: [F]ind [N]eovim files' })
  vim.keymap.set('n', '<leader>fp', builtin.spell_suggest, { desc = 'Telescope: [F]ind S[p]ell Suggestions' })
end
