-- Core settings
require 'config.options'
require 'config.autocmd'
require 'config.keymap'
require 'config.terminal'
require 'config.modules'
require 'config.lsp'

-- Plugin manifest (vim.pack.add + build hooks)
require 'config.pack'

-- Loader helper
local loader = require 'config.loader'

------------------------------------------------------------
-- Phase 1: Eager plugins (load at startup)
------------------------------------------------------------

-- Snacks must be first (was priority=1000)
loader.load('snacks.nvim', require('config.plugins.snacks'))

-- Colorscheme
loader.load('tokyonight.nvim', require('config.plugins.colors'))

-- Shared dependencies (no setup needed, just on runtimepath)
loader.load('plenary.nvim')
loader.load('nvim-web-devicons')
loader.load('nui.nvim')

-- Mini (statusline, surround, pairs, ai)
loader.load('mini.nvim', require('config.plugins.mini'))

-- Treesitter + extensions (load together, then setup)
loader.load('nvim-treesitter')
loader.load('nvim-treesitter-context')
loader.load('nvim-treesitter-textobjects', require('config.plugins.treesitter'))

-- Comment string
loader.load('nvim-ts-context-commentstring', require('config.plugins.ts-context-commentstring'))

-- Completion
loader.load('friendly-snippets')
loader.load('blink.cmp', require('config.plugins.blink'))
loader.load('minuet-ai.nvim', require('config.plugins.minuet'))

-- Git
loader.load('gitsigns.nvim', require('config.plugins.gitsigns'))

-- Formatting
loader.load('conform.nvim', require('config.plugins.conform'))

-- File explorer
loader.load('oil.nvim', require('config.plugins.oil'))

-- LSP dev
loader.load('lazydev.nvim', require('config.plugins.lazydev'))

-- Markdown rendering
loader.load('render-markdown.nvim', require('config.plugins.markdown'))

-- Color highlighting
loader.load('nvim-colorizer.lua', require('config.plugins.nvim-colorizer'))

-- Secret cloaking
loader.load('cloak.nvim', require('config.plugins.cloak'))

-- Window maximize
loader.load('maximizer.nvim', require('config.plugins.maximizer'))

-- Database
loader.load('vim-dadbod')
loader.load('vim-dadbod-ui', require('config.plugins.dadbod'))
loader.load('vim-dadbod-completion')

-- GitHub
loader.load('openingh.nvim', require('config.plugins.openingh'))

-- Doc generation (+ LuaSnip dependency)
loader.load('LuaSnip')
loader.load('neogen', require('config.plugins.neogen'))

------------------------------------------------------------
-- Phase 2: Event-deferred plugins
------------------------------------------------------------

-- UIEnter = after UI draws (replaces lazy.nvim's VeryLazy)
loader.on_event({
  'flash.nvim',
  'noice.nvim',
  'nvim-ufo', 'promise-async',
  'unimpaired.nvim',
  'which-key.nvim',
}, 'UIEnter', function()
  require('config.plugins.flash')()
  require('config.plugins.noice')()
  require('config.plugins.ufo')()
  require('config.plugins.unimpaired')()
  require('config.plugins.which-key')()
  require('config.plugins.snacks-deferred')()
end)

-- Lint on first buffer read
loader.on_event('nvim-lint', { 'BufReadPre', 'BufNewFile' }, require('config.plugins.lint'))

-- Telescope + todo-comments on VimEnter
loader.on_event({
  'telescope.nvim',
  'telescope-fzf-native.nvim',
  'telescope-ui-select.nvim',
  'telescope-frecency.nvim',
  'todo-comments.nvim',
}, 'VimEnter', function()
  require('config.plugins.telescope')()
  require('todo-comments').setup { signs = false }
end)

------------------------------------------------------------
-- Phase 3: Key-deferred plugins (biggest startup savings)
------------------------------------------------------------

-- smart-splits: ~79ms saved
loader.on_keys('smart-splits.nvim', {
  { 'n', '<C-h>' }, { 'n', '<C-j>' }, { 'n', '<C-k>' }, { 'n', '<C-l>' },
  { 'n', '<C-\\>' },
  { 'n', '<M-h>' }, { 'n', '<M-j>' }, { 'n', '<M-k>' }, { 'n', '<M-l>' },
  { 'n', '<M-S-h>' }, { 'n', '<M-S-j>' }, { 'n', '<M-S-k>' }, { 'n', '<M-S-l>' },
}, require('config.plugins.smart-splits'))

-- DAP cluster: ~30ms saved
loader.on_keys({
  'nvim-dap', 'nvim-dap-ui', 'nvim-nio',
  'mason.nvim', 'mason-nvim-dap.nvim', 'nvim-dap-ruby',
}, {
  { 'n', '<F5>' }, { 'n', '<F1>' }, { 'n', '<F2>' }, { 'n', '<F3>' }, { 'n', '<F7>' },
  { 'n', '<leader>b' }, { 'n', '<leader>B' },
}, require('config.plugins.dap'))

-- Neotest cluster: ~20ms saved
loader.on_keys({
  'neotest', 'FixCursorHold.nvim', 'neotest-minitest', 'neotest-rspec',
}, {
  { 'n', '<leader>tc' }, { 'n', '<leader>tC' }, { 'n', '<leader>tD' },
}, require('config.plugins.neotest'))

-- TreeSJ: ~15ms saved
loader.on_keys('treesj', {
  { 'n', '<leader>m' }, { 'n', '<leader>j' }, { 'n', '<leader>J' },
}, require('config.plugins.treesj'))

-- Claude Code
loader.on_keys('claudecode.nvim', {
  { 'n', '<leader>ac' }, { 'n', '<leader>af' }, { 'n', '<leader>ar' },
  { 'n', '<leader>aC' }, { 'n', '<leader>ab' }, { 'n', '<leader>aa' },
  { 'n', '<leader>ad' }, { 'v', '<leader>as' },
}, require('config.plugins.claudecode'))
