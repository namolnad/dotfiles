-- [[ Sessions ]]
-- A bare `nvim` saves its windows and buffers for the current directory when it
-- exits, including when tmux kills it. tmux-resurrect relaunches those panes as
-- `nvim +SessionRestore` (see @resurrect-processes in tmux.conf).
--  See `:help :mksession`

local session_dir = vim.fn.stdpath 'state' .. '/sessions'

-- `nvim <file>` (git commit, lazygit, claude's editor) never saves, so it can't
-- clobber the session of the nvim that's open on the project.
local started_bare = vim.fn.argc(-1) == 0

-- No folds (ufo manages those) and no terminals (they'd rerun their command)
vim.opt.sessionoptions = { 'buffers', 'curdir', 'help', 'tabpages', 'winsize' }

-- e.g. ~/Developer/dotfiles -> <state>/sessions/%Users%me%Developer%dotfiles.vim
-- (pass it with magic.file off, or Ex expands each % to the current file name)
local function session_file()
  return session_dir .. '/' .. (vim.fn.getcwd():gsub('/', '%%')) .. '.vim'
end

local function has_file_buffers()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == '' and vim.api.nvim_buf_get_name(buf) ~= '' then
      return true
    end
  end
  return false
end

vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Save the session of a bare nvim',
  group = vim.api.nvim_create_augroup('Session', { clear = true }),
  callback = function()
    if not started_bare then
      return
    end
    local file = session_file()
    if has_file_buffers() then
      vim.fn.mkdir(session_dir, 'p')
      pcall(vim.cmd.mksession, { file, bang = true, magic = { file = false } })
    else
      -- Nothing open, so come back empty rather than to an older session
      os.remove(file)
    end
  end,
})

vim.api.nvim_create_user_command('SessionRestore', function()
  local file = session_file()
  if vim.fn.filereadable(file) == 1 then
    vim.cmd.source { file, magic = { file = false } }
  end
end, { desc = 'Restore the session saved for the current directory' })
