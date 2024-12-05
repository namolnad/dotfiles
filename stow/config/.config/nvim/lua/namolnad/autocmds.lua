-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local NamolnadGroup = augroup('Namolnad', { clear = true })

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = NamolnadGroup,
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
  group = NamolnadGroup,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- Jump to last cursor position unless it's invalid or in an event handler
autocmd('BufReadPost', {
  group = NamolnadGroup,
  pattern = '*',
  callback = function()
    if vim.fn.line '\'"' > 0 and vim.fn.line '\'"' <= vim.fn.line '$' then
      vim.cmd 'normal! g`"'
    end
  end,
})

autocmd({ 'BufRead', 'BufNewFile' }, {
  group = NamolnadGroup,
  pattern = {
    '*.rake',
    '*.eruby',
    'Rakefile',
    'Brewfile',
    'Gemfile',
    '*.irbrc',
    '*.ru',
    '*.gemspec',
    '*.erb',
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
