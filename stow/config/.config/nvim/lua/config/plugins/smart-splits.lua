return function()
  local smart_splits = require 'smart-splits'

  -- resizing splits
  vim.keymap.set('n', '<M-h>', smart_splits.resize_left, { desc = 'SmartSplits: Resize split left' })
  vim.keymap.set('n', '<M-j>', smart_splits.resize_down, { desc = 'SmartSplits: Resize split down' })
  vim.keymap.set('n', '<M-k>', smart_splits.resize_up, { desc = 'SmartSplits: Resize split up' })
  vim.keymap.set('n', '<M-l>', smart_splits.resize_right, { desc = 'SmartSplits: Resize split right' })
  -- moving between splits
  vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left, { desc = 'SmartSplits: Move cursor left' })
  vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down, { desc = 'SmartSplits: Move cursor down' })
  vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up, { desc = 'SmartSplits: Move cursor up' })
  vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right, { desc = 'SmartSplits: Move cursor right' })
  vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous,
    { desc = 'SmartSplits: Move cursor to previous split' })
  -- swapping buffers between windows
  vim.keymap.set('n', '<M-S-h>', smart_splits.swap_buf_left, { desc = 'SmartSplits: Swap buffer left' })
  vim.keymap.set('n', '<M-S-j>', smart_splits.swap_buf_down, { desc = 'SmartSplits: Swap buffer down' })
  vim.keymap.set('n', '<M-S-k>', smart_splits.swap_buf_up, { desc = 'SmartSplits: Swap buffer up' })
  vim.keymap.set('n', '<M-S-l>', smart_splits.swap_buf_right, { desc = 'SmartSplits: Swap buffer right' })

  smart_splits.setup {
    ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
    ignored_filetypes = { 'NvimTree' },
    default_amount = 3,
    at_edge = 'wrap',
    float_win_behavior = 'previous',
    move_cursor_same_row = false,
    cursor_follows_swapped_bufs = false,
    resize_mode = {
      quit_key = '<ESC>',
      resize_keys = { 'h', 'j', 'k', 'l' },
      silent = false,
      hooks = { on_enter = nil, on_leave = nil },
    },
    ignored_events = { 'BufEnter', 'WinEnter' },
    multiplexer_integration = nil,
    disable_multiplexer_nav_when_zoomed = true,
    kitty_password = nil,
    log_level = 'info',
  }
end
