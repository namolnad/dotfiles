-- Plugin manifest for vim.pack (Neovim 0.12 built-in package manager)
-- All plugins are downloaded to site/pack/core/opt and loaded via packadd.

-- Eager plugins: loaded immediately at startup
vim.pack.add({
  -- UI / Core
  'https://github.com/folke/snacks.nvim',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/echasnovski/mini.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-lua/plenary.nvim',

  -- Completion
  { src = 'https://github.com/saghen/blink.cmp', version = 'v1' },
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/milanglacier/minuet-ai.nvim',

  -- Treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  'https://github.com/JoosepAlviste/nvim-ts-context-commentstring',

  -- Git
  'https://github.com/lewis6991/gitsigns.nvim',

  -- Formatting
  'https://github.com/stevearc/conform.nvim',

  -- File explorer
  'https://github.com/stevearc/oil.nvim',

  -- LSP dev
  'https://github.com/folke/lazydev.nvim',

  -- UI
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  'https://github.com/norcalli/nvim-colorizer.lua',
  'https://github.com/laytan/cloak.nvim',
  'https://github.com/0x00-ketsu/maximizer.nvim',

  -- Database
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
  'https://github.com/kristijanhusak/vim-dadbod-completion',

  -- GitHub
  'https://github.com/almo7aya/openingh.nvim',

  -- Doc generation
  'https://github.com/danymat/neogen',
  'https://github.com/L3MON4D3/LuaSnip',
})

-- Deferred plugins: downloaded but NOT loaded at startup.
-- Loaded later via packadd (on_event / on_keys in init.lua).
-- The no-op load function prevents them from being added to runtimepath.
vim.pack.add({
  -- Key-deferred (expensive)
  'https://github.com/mrjones2014/smart-splits.nvim',
  'https://github.com/Wansmer/treesj',
  'https://github.com/coder/claudecode.nvim',

  -- Key-deferred (DAP cluster)
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/jay-babu/mason-nvim-dap.nvim',
  'https://github.com/suketa/nvim-dap-ruby',

  -- Key-deferred (neotest cluster)
  'https://github.com/nvim-neotest/neotest',
  'https://github.com/antoinemadec/FixCursorHold.nvim',
  'https://github.com/zidhuss/neotest-minitest',
  'https://github.com/olimorris/neotest-rspec',

  -- Event-deferred (UIEnter)
  'https://github.com/folke/flash.nvim',
  'https://github.com/folke/noice.nvim',
  'https://github.com/kevinhwang91/nvim-ufo',
  'https://github.com/kevinhwang91/promise-async',
  'https://github.com/tummetott/unimpaired.nvim',
  'https://github.com/folke/which-key.nvim',

  -- Event-deferred (VimEnter)
  'https://github.com/nvim-telescope/telescope.nvim',
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',
  'https://github.com/nvim-telescope/telescope-frecency.nvim',
  'https://github.com/folke/todo-comments.nvim',

  -- Event-deferred (BufReadPre)
  'https://github.com/mfussenegger/nvim-lint',
}, {
  load = function() end, -- no-op: don't add to rtp, we'll packadd manually
})

-- Post-install/update hooks
vim.api.nvim_create_autocmd('User', {
  pattern = 'PackChanged',
  callback = function()
    -- Build telescope-fzf-native
    if vim.fn.executable('make') == 1 then
      local fzf_path = vim.fn.stdpath('data') .. '/site/pack/core/opt/telescope-fzf-native.nvim'
      if vim.fn.isdirectory(fzf_path) == 1 then
        vim.fn.system({ 'make', '-C', fzf_path })
      end
    end
    -- Update treesitter parsers
    vim.cmd('TSUpdate')
  end,
})
