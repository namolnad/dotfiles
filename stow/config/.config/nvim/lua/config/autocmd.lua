-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local CustomGroup = augroup('Custom', { clear = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = CustomGroup,
  callback = function()
    vim.highlight.on_yank {
      higroup = 'IncSearch',
      pattern = '*',
      timeout = 40,
    }
  end,
})

-- Remove trailing whitespace on save
autocmd({ 'BufWritePre' }, {
  group = CustomGroup,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

autocmd({ 'BufWritePre' }, {
  group = CustomGroup,
  -- pattern = '*',
  pattern = {
    '*.rb',
    '*.erb',
    '*.rake',
    'Rakefile',
    'Brewfile',
    'Gemfile',
    '*.irbrc',
    '*.ru',
    '*.gemspec',
  },
  command = 'lua vim.lsp.buf.format({ async = false })'
})

-- Jump to last cursor position unless it's invalid or in an event handler
autocmd('BufReadPost', {
  group = CustomGroup,
  pattern = '*',
  callback = function()
    if vim.fn.line '\'"' > 0 and vim.fn.line '\'"' <= vim.fn.line '$' then
      vim.cmd 'normal! g`"'
    end
  end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  group = CustomGroup,
  pattern = {
    '*.rake',
    'Rakefile',
    'Brewfile',
    'Gemfile',
    '*.irbrc',
    '*.ru',
    '*.gemspec',
  },
  callback = function()
    vim.opt_local.filetype = 'ruby'
  end,
})

-- Autocmd to track macro recording, And redraw statusline, which trigger
-- macro function of mini.statusline
vim.api.nvim_create_autocmd("RecordingEnter", {
  pattern = "*",
  callback = function()
    vim.cmd("redrawstatus")
  end,
})

-- Autocmd to track the end of macro recording
vim.api.nvim_create_autocmd("RecordingLeave", {
  pattern = "*",
  callback = function()
    vim.cmd("redrawstatus")
  end,
})
