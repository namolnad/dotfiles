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
    'Gemfile',
    '*.ircrc',
    '*.ru',
    '*.gemspec',
    '*.erb',
  },
  callback = function()
    vim.bo.filetype = 'ruby'
  end,
})

autocmd('FileType', {
  group = NamolnadGroup,
  pattern = {
    'ruby',
    'typescript',
    'javascript',
    'typescriptreact',
    'javascriptreact',
    'lua',
    'slim',
    'sh',
    'zsh',
    'bash',
    'fish',
    'vim',
  },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
})

autocmd('FileType', {
  group = NamolnadGroup,
  pattern = { 'python', 'go', 'swift' },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.tabstop = 4
  end,
})

autocmd('FileType', {
  group = NamolnadGroup,
  pattern = 'markdown',
  callback = function()
    vim.bo.formatoptions = 'tcroqn2'
    vim.bo.comments = 'n:&gt;'
    vim.bo.syn = 'off'
  end,
})
