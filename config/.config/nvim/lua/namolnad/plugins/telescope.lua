return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-frecency.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
  },
  config = function()
    local telescope = require 'telescope'
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    telescope.setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
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
          },
          -- vimgrep_argments = { '--hidden', '--glob=!.git/' } -- can't seem to make this work
        },
        live_grep = {
          -- find_command = { 'rg', '--ignore', '--hidden', '--glob=!.git/', '--smart-case' }, -- can't seem to make this work
          file_ignore_patterns = {
            'node_modules',
            'app/assets/builds',
            '.git/',
            'log/',
            'package.lock',
          },
          additional_args = {
            -- '--fixed-strings',
            '--hidden',
            '--no-ignore',
            '--smart-case',
            '--glob=!.git/',
            '--glob=!log/test.log',
            '--glob=!.DS_Store',
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
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')
    pcall(telescope.load_extension, 'frecency')
    pcall(telescope.load_extension, 'rails_schema')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>ft', builtin.builtin, { desc = '[F]ind [T]elescope commands' })
    vim.keymap.set('n', '<leader>fs', builtin.live_grep, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
    vim.keymap.set('n', '<leader>fm', builtin.man_pages, { desc = '[F]ind [M]an pages' })
    vim.keymap.set('n', '<leader>fg', builtin.git_files, { desc = '[F]ind [G]it files' })
    vim.keymap.set('n', '<leader>fR', builtin.resume, { desc = '[F]ind [R]esume' })
    vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = '[F]ind [R]egisters' })
    vim.keymap.set('n', '<leader>f.', '<cmd>Telescope frecency workspace=CWD<cr>',
      { desc = '[F]ind [O]ld / recent files' })
    vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = '[F]ind [O]ld Files' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind Open [B]uffers' })
    vim.keymap.set('n', '<leader>fw', function()
      local word = vim.fn.expand '<cword>'
      builtin.grep_string { search = word }
    end, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>fW', function()
      local word = vim.fn.expand '<cWORD>'
      builtin.grep_string { search = word }
    end, { desc = '[F]ind current [W]ord' })
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false, })
    end, { desc = '[/] Fuzzily search in current buffer' })
    vim.keymap.set('n', '<leader>f/', function()
      builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files', }
    end, { desc = '[F]ind [/] in Open Files' })
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[F]ind [N]eovim files' })
  end,
}
