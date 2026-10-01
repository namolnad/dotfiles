-- [[ Sessions ]]
-- A bare `nvim` keeps a session of its windows and buffers for the current
-- directory, saved as the layout changes and again on exit, so it survives tmux
-- killing it. tmux-resurrect relaunches those panes as `nvim +SessionRestore`
-- (see @resurrect-processes in tmux.conf).
--  See `:help :mksession`

local session_dir = vim.fn.stdpath 'state' .. '/sessions'

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

local function save()
  if has_file_buffers() then
    vim.fn.mkdir(session_dir, 'p')
    pcall(vim.cmd.mksession, { session_file(), bang = true, magic = { file = false } })
  end
end

-- `nvim <file>` (git commit, lazygit, claude's editor) never saves, so it can't
-- clobber the session of the nvim that's open on the project.
if vim.fn.argc(-1) == 0 then
  local group = vim.api.nvim_create_augroup('Session', { clear = true })
  local timer = assert(vim.uv.new_timer())

  -- Don't count on exit alone: a killed nvim's teardown can be cut short, and a
  -- crash never gets that far
  vim.api.nvim_create_autocmd({ 'BufEnter', 'WinNew', 'WinClosed', 'TabClosed' }, {
    desc = 'Save the session once the layout settles',
    group = group,
    callback = function()
      timer:stop()
      timer:start(1000, 0, vim.schedule_wrap(save))
    end,
  })

  vim.api.nvim_create_autocmd('VimLeavePre', {
    desc = 'Save the session of a bare nvim',
    group = group,
    callback = function()
      timer:stop()
      if has_file_buffers() then
        save()
      else
        -- Nothing open, so come back empty rather than to an older session
        os.remove(session_file())
      end
    end,
  })
end

vim.api.nvim_create_user_command('SessionRestore', function()
  local file = session_file()
  if vim.fn.filereadable(file) == 1 then
    vim.cmd.source { file, magic = { file = false } }
  end
end, { desc = 'Restore the session saved for the current directory' })
