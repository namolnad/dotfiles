-- Lightweight lazy-loading helper for vim.pack
-- Provides event-deferred and keymap-deferred plugin loading via packadd.
local M = {}

--- Load a plugin immediately via packadd and run its setup function.
---@param plugin string plugin directory name (e.g. 'smart-splits.nvim')
---@param setup_fn function|nil optional function to call after packadd
function M.load(plugin, setup_fn)
  vim.cmd.packadd(plugin)
  if setup_fn then
    setup_fn()
  end
end

--- Defer loading until one of the given events fires.
---@param plugins string|string[] plugin name(s) to packadd
---@param events string|string[] autocmd events (e.g. 'BufReadPre', 'UIEnter')
---@param setup_fn function|nil runs after all plugins are loaded
---@param pattern string|nil autocmd pattern (default '*')
function M.on_event(plugins, events, setup_fn, pattern)
  plugins = type(plugins) == 'string' and { plugins } or plugins
  events = type(events) == 'string' and { events } or events
  vim.api.nvim_create_autocmd(events, {
    pattern = pattern or '*',
    once = true,
    callback = function()
      for _, p in ipairs(plugins) do
        vim.cmd.packadd(p)
      end
      if setup_fn then
        setup_fn()
      end
    end,
  })
end

--- Defer loading until a keymap is pressed. The keymap is replayed after loading.
---@param plugins string|string[] plugin name(s) to packadd
---@param mappings table list of {mode, lhs} pairs
---@param setup_fn function|nil runs after packadd (should register real keymaps)
function M.on_keys(plugins, mappings, setup_fn)
  plugins = type(plugins) == 'string' and { plugins } or plugins
  for _, map in ipairs(mappings) do
    local mode, lhs = map[1], map[2]
    vim.keymap.set(mode, lhs, function()
      -- Remove the stub keymap before loading to avoid recursion
      vim.keymap.del(mode, lhs)
      -- Load the plugin(s)
      for _, p in ipairs(plugins) do
        vim.cmd.packadd(p)
      end
      if setup_fn then
        setup_fn()
      end
      -- Replay the key
      local keys = vim.api.nvim_replace_termcodes(lhs, true, false, true)
      vim.api.nvim_feedkeys(keys, 'mit', false)
    end, { desc = 'Lazy-load ' .. plugins[1] })
  end
end

return M
