-- Neovim step of scripts/bootstrap, run headless with the real config:
--
--   nvim --headless -i NONE \
--     --cmd 'lua vim.g.pack_confirm = false; vim.g.dotfiles_nvim_mode = "update"' \
--     -c 'luafile scripts/nvim-update.lua'
--
-- "install" leaves plugins to startup, where vim.pack.add installs anything
-- missing at its lockfile revision. "update" also moves every plugin to its
-- latest revision, which rewrites the lockfile.
--
-- Plugin installs and updates block, but treesitter parser builds and
-- blink.cmp's binary download are async, so this waits for both before
-- quitting, and exits non-zero if anything failed.

local mode = vim.g.dotfiles_nvim_mode or 'update'
local parser_timeout = 30 * 60 * 1000 -- a new machine compiles every parser
local download_timeout = 5 * 60 * 1000

local failures = 0

-- Headless, nvim's own messages (vim.pack's progress, nvim-treesitter's
-- summary) don't end their line, so each of these starts a new one
local function say(fmt, ...)
  io.stdout:write('\n' .. fmt:format(...))
end

local function fail(fmt, ...)
  failures = failures + 1
  say('error: ' .. fmt, ...)
end

-- vim.pack and nvim-treesitter report failures through vim.notify, and
-- snacks.notifier keeps those in its history instead of printing them headless
local notify = vim.notify
vim.notify = function(msg, level, opts)
  if level and level >= vim.log.levels.ERROR then
    fail('%s', msg)
  end
  return notify(msg, level, opts)
end

local function update_plugins()
  local before = {}
  for _, p in ipairs(vim.pack.get(nil, { info = false })) do
    before[p.spec.name] = p.rev
  end

  vim.pack.update(nil, { force = true })

  local changed = {}
  for _, p in ipairs(vim.pack.get(nil, { info = false })) do
    if before[p.spec.name] ~= p.rev then
      changed[#changed + 1] = ('%s %s -> %s'):format(p.spec.name, (before[p.spec.name] or 'new'):sub(1, 7), p.rev:sub(1, 7))
    end
  end
  table.sort(changed)
  say('plugins: %d updated', #changed)
  for _, line in ipairs(changed) do
    say('  %s', line)
  end
end

-- install() also waits out builds already running (nvim-treesitter lets one
-- build per language run at a time), such as the startup install or the
-- :TSUpdate the PackChanged hook starts when nvim-treesitter itself updates
local function wait_for_parsers()
  local ts = require('nvim-treesitter')
  local ok, result = pcall(function()
    return ts.install(require('config.parsers'), { summary = true }):wait(parser_timeout)
  end)
  if not ok or result == false then
    fail('treesitter parsers: install failed (%s)', ok and 'see above' or result)
  end
  if mode == 'update' then
    ok, result = pcall(function()
      return ts.update(nil, { summary = true }):wait(parser_timeout)
    end)
    if not ok or result == false then
      fail('treesitter parsers: update failed (%s)', ok and 'see above' or result)
    end
  end
end

-- blink.cmp downloads a prebuilt fuzzy matcher for its git tag; without one it
-- warns on every start and falls back to the slower Lua matcher
local function wait_for_blink()
  local ok, download = pcall(require, 'blink.cmp.fuzzy.download')
  if not ok then
    return
  end
  local done, err, impl = false, nil, nil
  download.ensure_downloaded(function(e, i)
    done, err, impl = true, e, i
  end)
  if not vim.wait(download_timeout, function() return done end, 200) then
    return fail('blink.cmp: fuzzy matcher download timed out')
  end
  if err then
    return fail('blink.cmp: %s', err)
  end
  say('blink.cmp fuzzy matcher: %s', impl or 'rust')
end

local ok, err = xpcall(function()
  if mode == 'update' then
    update_plugins()
  end
  wait_for_parsers()
  wait_for_blink()
end, debug.traceback)
if not ok then
  fail('%s', err)
end

io.stdout:write('\n')
vim.cmd(failures == 0 and 'qa!' or 'cquit 1')
