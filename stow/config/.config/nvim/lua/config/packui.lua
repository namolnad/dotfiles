-- Plugin management UI for vim.pack (Neovim 0.12 built-in package manager).
-- The manifest itself lives in lua/config/pack.lua; this is just the front end.
--
-- Keymaps sit under <leader>l ("pLugins"). vim.pack's own confirmation buffer
-- does the heavy lifting for updates -- see `:h vim.pack` -- so these mostly
-- exist to save typing `:lua vim.pack.update()` and to cover the bits that have
-- no built-in entry point (status, clean, log).

local M = {}

--- Render a resolved spec's version constraint for display.
---@param spec vim.pack.SpecResolved
---@return string
local function version_label(spec)
  local v = spec.version
  if v == nil then
    return 'default'
  elseif type(v) == 'string' then
    return v
  end
  -- vim.version.range()
  return ('%s - %s'):format(tostring(v.from), tostring(v.to))
end

--- Open a read-only float sized to its contents.
---@param lines string[]
---@param title string
local function float(lines, title)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
  vim.bo[buf].buftype = 'nofile'

  local width = 0
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(width + 2, vim.o.columns - 4)
  local height = math.min(#lines, vim.o.lines - 6)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    width = width,
    height = height,
    style = 'minimal',
    border = 'rounded',
    title = title,
    title_pos = 'center',
  })
  vim.wo[win].cursorline = true

  for _, key in ipairs({ 'q', '<Esc>' }) do
    vim.keymap.set('n', key, function()
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end, { buffer = buf, nowait = true, desc = 'Close' })
  end
end

--- List every plugin vim.pack manages, with its current revision.
function M.status()
  local plugins = vim.pack.get(nil, { info = false })
  table.sort(plugins, function(a, b) return a.spec.name < b.spec.name end)

  local name_width = 0
  for _, p in ipairs(plugins) do
    name_width = math.max(name_width, #p.spec.name)
  end

  local lines = {}
  for _, p in ipairs(plugins) do
    lines[#lines + 1] = ('  %s %-' .. name_width .. 's  %-8s  %s'):format(
      p.active and '*' or '-',
      p.spec.name,
      p.rev:sub(1, 7),
      version_label(p.spec)
    )
  end
  lines[#lines + 1] = ''
  lines[#lines + 1] = '  * active    - on disk but absent from pack.lua (<leader>lc to remove)'

  float(lines, (' %d plugins '):format(#plugins))
end

--- Delete plugins that are on disk but no longer in any vim.pack.add() call.
function M.clean()
  local orphans = vim.iter(vim.pack.get(nil, { info = false }))
    :filter(function(p) return not p.active end)
    :map(function(p) return p.spec.name end)
    :totable()

  if #orphans == 0 then
    vim.notify('vim.pack: nothing to clean', vim.log.levels.INFO)
    return
  end

  table.sort(orphans)
  local prompt = ('Delete %d orphaned plugin(s) from disk?\n\n  %s\n'):format(
    #orphans, table.concat(orphans, '\n  '))
  if vim.fn.confirm(prompt, '&Yes\n&No', 2) == 1 then
    vim.pack.del(orphans)
    vim.notify(('vim.pack: removed %d plugin(s)'):format(#orphans), vim.log.levels.INFO)
  end
end

--- Open vim.pack's update log.
function M.log()
  local path = vim.fs.joinpath(vim.fn.stdpath('log'), 'nvim-pack.log')
  if vim.fn.filereadable(path) == 0 then
    vim.notify('vim.pack: no log yet (' .. path .. ')', vim.log.levels.WARN)
    return
  end
  vim.cmd.tabedit(vim.fn.fnameescape(path))
  vim.cmd('normal! G')
end

local function map(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = 'Pack: ' .. desc })
end

map('<leader>ll', function() vim.pack.update() end, 'Update all plugins')
map('<leader>lo', function() vim.pack.update(nil, { offline = true }) end, 'Review pending updates (offline)')
map('<leader>ls', M.status, 'Status -- installed plugins')
map('<leader>lr', function() vim.pack.update(nil, { target = 'lockfile' }) end, 'Restore revisions from lockfile')
map('<leader>lc', M.clean, 'Clean orphaned plugins')
map('<leader>lg', M.log, 'Open pack update log')

return M
