-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

-- [[ Setting options ]]
-- See `:help vim.opt`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Use line curose for insert, block for normal mode
vim.opt.guicursor = 'n-v-c:block,i-ci-ve:ver25-blinkwait700-blinkon400-blinkoff250' --blinkon0 turns off the cursor blink

-- Make line numbers default
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.opt.clipboard = 'unnamedplus'

-- Enable break indent
vim.opt.breakindent = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.winborder = 'rounded'

vim.opt.autoindent = true
vim.opt.smartindent = true

-- Don't have `o` add a comment
vim.opt.formatoptions:remove 'o'

-- Save undo history
vim.opt.undofile = true
-- Save undo history in TMPDIR
vim.opt.undodir = os.getenv 'TMPDIR' .. '/vim/undodir'
-- vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 50 -- 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.termguicolors = true

vim.opt.isfname:append '@-@'

vim.opt.colorcolumn = '80'

vim.opt.visualbell = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

function Foldtext()
  local foldstart, foldend = vim.v.foldstart, vim.v.foldend

  local first_line = vim.fn.getline(foldstart)
  local last_line = vim.fn.getline(foldend)
  local sanitized_first_line = string.gsub(first_line, "^%s*(.*)[{[]$", "%1")
  -- local sanitized_last_line = string.gsub(last_line, "^%^@(.*)$", "%1")
  local sanitized_last_line = "hello"

  return string.format("%s ⋯\n%s", sanitized_first_line, sanitized_last_line)
end

-- vim.opt.foldenable = true
-- vim.opt.foldcolumn = '1'
-- vim.opt.foldmethod = 'expr'
-- vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- vim.opt.foldlevel = 20 -- Start with all folds open
-- vim.opt.foldtext = 'v:lua.Foldtext()'
-- -- vim.opt.foldtext = ''
-- vim.opt.fillchars:append ',fold: '
-- vim.api.nvim_set_hl(0, 'Folded', { bg = 'NONE', blend = 0, bold = true })
-- vim.api.nvim_set_hl(0, 'Folded', { bg = 'NONE', fg = 'NONE', bold = true })

function R(name)
  require('plenary.reload').reload_module(name)
end
