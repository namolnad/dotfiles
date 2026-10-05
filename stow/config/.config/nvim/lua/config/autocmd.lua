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

-- Don't continue comments onto lines opened with o/O. Most ftplugins add 'o'
-- back to 'formatoptions' after options.lua runs, and filetype plugins load
-- after this file, so strip it once they're done. Markdown keeps it (see
-- after/ftplugin/markdown.lua) to continue lists and quotes.
autocmd('FileType', {
  group = CustomGroup,
  callback = function(args)
    if args.match == 'markdown' then
      return
    end
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        vim.bo[args.buf].formatoptions = vim.bo[args.buf].formatoptions:gsub('o', '')
      end
    end)
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
