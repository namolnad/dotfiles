local M = {}

local state_file = vim.fn.stdpath("data") .. "/botd.json"

local function get_all_keybindings()
  local bindings = {}
  local modes = { "n", "v", "x", "i", "o", "c", "t" }

  for _, mode in ipairs(modes) do
    local keymaps = vim.api.nvim_get_keymap(mode)
    for _, keymap in ipairs(keymaps) do
      if keymap.desc and keymap.desc ~= "" then
        table.insert(bindings, {
          mode = mode,
          key = keymap.lhs,
          desc = keymap.desc
        })
      end
    end
  end

  return bindings
end

local function get_today_string()
  return os.date("%Y-%m-%d")
end

local function load_state()
  local file = io.open(state_file, "r")
  if not file then
    return nil
  end

  local content = file:read("*a")
  file:close()

  local ok, state = pcall(vim.json.decode, content)
  return ok and state or nil
end

local function save_state(state)
  local file = io.open(state_file, "w")
  if not file then
    return false
  end

  file:write(vim.json.encode(state))
  file:close()
  return true
end

function M.get_daily_keybinding()
  local bindings = get_all_keybindings()
  if #bindings == 0 then
    return nil
  end

  local today = get_today_string()
  local state = load_state() or {}

  if state.date == today and state.binding then
    return state.binding
  end

  -- Generate new binding for today
  math.randomseed(os.time())
  local pick = bindings[math.random(#bindings)]

  -- Save state
  state.date = today
  state.binding = pick
  save_state(state)

  return pick
end

local function display_binding(binding)
  if not binding then
    vim.notify("No key bindings found!", vim.log.levels.WARN)
    return
  end

  vim.notify(
    string.format("🔑 %s-mode: `%s` → %s", binding.mode, binding.key, binding.desc),
    vim.log.levels.INFO,
    { timeout = 10000 }
  )
end

local function has_been_shown_today()
  local state = load_state()
  if not state then
    return false
  end

  local today = get_today_string()
  return state.date == today and state.shown == true
end

local function mark_as_shown()
  local state = load_state() or {}
  state.shown = true
  save_state(state)
end

function M.show()
  local binding = M.get_daily_keybinding()
  display_binding(binding)
  mark_as_shown()
end

function M.show_if_not_shown_today()
  if not has_been_shown_today() then
    M.show()
  end
end

function M.next()
  local bindings = get_all_keybindings()
  if #bindings == 0 then
    display_binding(nil)
    return
  end

  local today = get_today_string()
  local state = load_state() or {}

  -- Generate new random binding
  math.randomseed(os.time() + vim.loop.hrtime())
  local pick = bindings[math.random(#bindings)]

  -- Update state
  state.date = today
  state.binding = pick
  save_state(state)

  display_binding(pick)
end

local function setup_command()
  vim.api.nvim_create_user_command("BOTD", function(opts)
    local subcommand = opts.fargs[1] or "show"

    if subcommand == "show" then
      M.show()
    elseif subcommand == "next" then
      M.next()
    else
      vim.notify("Unknown subcommand: " .. subcommand .. ". Use 'show' or 'next'", vim.log.levels.ERROR)
    end
  end, {
    nargs = "?",
    complete = function()
      return { "show", "next" }
    end,
    desc = "Binding Of The Day - show current or get next random keybinding"
  })
end

local function setup_autocommand(show)
  local callback_fn = (show == "once") and M.show_if_not_shown_today or M.show

  vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
    callback = function()
      vim.defer_fn(callback_fn, 500) -- Delay 0.5 seconds to let nvim fully load
    end,
    desc = "Show key binding of the day on startup and when gaining focus"
  })
end

function M.setup(opts)
  opts = opts or {}

  if opts.command ~= false then
    setup_command()
  end

  if opts.autocommand ~= false then
    local autocommand_opts = opts.autocommand
    local show = "always" -- default to show = "always"

    if type(autocommand_opts) == "table" then
      show = autocommand_opts.show or "always"
    end

    setup_autocommand(show)
  end
end

return M
