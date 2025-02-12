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
            '--glob=!.rbenv/versions/',
            '--glob=!.rbenv/shims/',
            '--glob=!stow/config/.config/alfred',
            '--glob=!tmp/**/*'
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
            'rbenv/versions',
            'rbenv/shims',
            'alfredpreferences',
            'tmp/',
          },
          additional_args = {
            -- '--fixed-strings',
            '--hidden',
            '--no-ignore',
            '--smart-case',
            '--glob=!.git/',
            '--glob=!log/test.log',
            '--glob=!.DS_Store',
            '--glob=!.vim/undodir/',
            '--glob=!tmp/**/*'
            -- '--glob=!stow/config/.config/rbenv/versions/',
            -- '--glob=!stow/config/.config/rbenv/shims/',
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
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true,    -- override the file sorter
          case_mode = 'smart_case',       -- or "ignore_case" or "respect_case"
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    telescope.load_extension 'fzf'
    telescope.load_extension 'ui-select'
    telescope.load_extension 'frecency'
    telescope.load_extension 'rails_schema'

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'

    -- vim.keymap.set('n', '<leader>fg', require "custom.telescope.multi-ripgrep", { desc = 'Telescope: [F]ind [g]elp' })
    vim.keymap.set('n', '<leader>fg', require "custom.telescope.multi-ripgrep", { desc = 'Telescope: [F]ind [g]elp' })
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
  end,
}
