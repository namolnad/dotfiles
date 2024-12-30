local opt_set = vim.opt_local
local key_set = vim.keymap.set

local state = {
  term_window = {
    buf = -1,
    win = -1,
  }
}

-- Set local settings for terminal buffers
vim.api.nvim_create_autocmd('TermOpen', {
  group = vim.api.nvim_create_augroup('custom-term-open', {}),
  callback = function()
    opt_set.number = false
    opt_set.relativenumber = false
    opt_set.scrolloff = 0
    opt_set.signcolumn = 'no'

    -- Add the hide terminal keymap to the terminal buffer
    for _, key in ipairs({ 'gq', '<esc>' }) do
      key_set('n', key, function()
        vim.api.nvim_win_hide(state.term_window.win)
      end, { buffer = true, desc = 'Hide terminal' })
    end
  end,
})

local function create_buffer(opts)
  opts = opts or {}
  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true) -- No file, scratch buffer
  end
  return buf
end


local function create_floating_window(opts)
  opts = opts or {}

  -- Create a buffer
  local buf = create_buffer { buf = opts.buf }

  -- Define window configuration
  local width = opts.width or math.floor(vim.o.columns * 0.8)
  local height = opts.height or math.floor(vim.o.lines * 0.8)

  -- Calculate the position to center the window
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)

  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal", -- No borders or extra UI elements
    border = "rounded",
  }

  -- Create the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return { buf = buf, win = win }
end

local toggle_float_terminal = function()
  if not vim.api.nvim_win_is_valid(state.term_window.win) then
    state.term_window = create_floating_window { buf = state.term_window.buf }
    if vim.bo[state.term_window.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.term_window.win)
  end
end

local function create_bottom_window(opts)
  opts = opts or {}
  local height = opts.height or 18

  local buf = create_buffer { buf = opts.buf }

  vim.cmd 'botright split'

  local win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_buf(win, buf)
  vim.api.nvim_win_set_height(win, height)
  vim.wo[win].winfixheight = true

  return { buf = buf, win = win }
end

local toggle_bottom_terminal = function()
  if not vim.api.nvim_win_is_valid(state.term_window.win) then
    state.term_window = create_bottom_window { buf = state.term_window.buf }
    if vim.bo[state.term_window.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.term_window.win)
  end
end

-- Easily hit escape in terminal mode.
key_set('t', '<esc><esc>', '<c-\\><c-n>', { desc = 'Hit escape in terminal mode' })

key_set('n', '<leader>tb', toggle_bottom_terminal, { desc = 'Toggle [T]erminal. Position [B]ottom' })
key_set({ 'n', 't' }, '<leader>tF', toggle_float_terminal, { desc = 'Toggle [T]erminal. Position [F]loating' })
