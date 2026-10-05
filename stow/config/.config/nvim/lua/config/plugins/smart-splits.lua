return function()
  local smart_splits = require 'smart-splits'

  local function other_window()
    local normal = vim.tbl_filter(function(win)
      return vim.api.nvim_win_get_config(win).relative == ''
    end, vim.api.nvim_tabpage_list_wins(0))
    return #normal > 1
  end

  -- Resizing also grows into a neighbouring tmux pane; swapping only trades
  -- buffers between nvim windows
  local function can_resize()
    if other_window() then
      return true
    end
    return vim.env.TMUX ~= nil
      and (tonumber(vim.fn.system { 'tmux', 'display-message', '-p', '#{window_panes}' }) or 1) > 1
  end

  -- With nothing to resize or swap, the arrows nag toward hjkl instead
  local function or_nag(fn, possible, key)
    return function()
      if possible() then
        fn()
      else
        vim.api.nvim_echo({ { 'Use ' .. key .. ' to move!!' } }, false, {})
      end
    end
  end

  -- resizing splits (arrows: AeroSpace owns Alt+hjkl, macOS owns Ctrl+arrows)
  vim.keymap.set('n', '<Left>', or_nag(smart_splits.resize_left, can_resize, 'h'), { desc = 'SmartSplits: Resize split left' })
  vim.keymap.set('n', '<Down>', or_nag(smart_splits.resize_down, can_resize, 'j'), { desc = 'SmartSplits: Resize split down' })
  vim.keymap.set('n', '<Up>', or_nag(smart_splits.resize_up, can_resize, 'k'), { desc = 'SmartSplits: Resize split up' })
  vim.keymap.set('n', '<Right>', or_nag(smart_splits.resize_right, can_resize, 'l'), { desc = 'SmartSplits: Resize split right' })
  -- moving between splits
  vim.keymap.set('n', '<C-h>', smart_splits.move_cursor_left, { desc = 'SmartSplits: Move cursor left' })
  vim.keymap.set('n', '<C-j>', smart_splits.move_cursor_down, { desc = 'SmartSplits: Move cursor down' })
  vim.keymap.set('n', '<C-k>', smart_splits.move_cursor_up, { desc = 'SmartSplits: Move cursor up' })
  vim.keymap.set('n', '<C-l>', smart_splits.move_cursor_right, { desc = 'SmartSplits: Move cursor right' })
  vim.keymap.set('n', '<C-\\>', smart_splits.move_cursor_previous,
    { desc = 'SmartSplits: Move cursor to previous split' })
  -- swapping buffers between windows
  vim.keymap.set('n', '<S-Left>', or_nag(smart_splits.swap_buf_left, other_window, 'h'), { desc = 'SmartSplits: Swap buffer left' })
  vim.keymap.set('n', '<S-Down>', or_nag(smart_splits.swap_buf_down, other_window, 'j'), { desc = 'SmartSplits: Swap buffer down' })
  vim.keymap.set('n', '<S-Up>', or_nag(smart_splits.swap_buf_up, other_window, 'k'), { desc = 'SmartSplits: Swap buffer up' })
  vim.keymap.set('n', '<S-Right>', or_nag(smart_splits.swap_buf_right, other_window, 'l'), { desc = 'SmartSplits: Swap buffer right' })

  smart_splits.setup {
    ignored_buftypes = { 'nofile', 'quickfix', 'prompt' },
    ignored_filetypes = { 'NvimTree' },
    default_amount = 3,
    at_edge = 'wrap',
    float_win_behavior = 'previous',
    move_cursor_same_row = false,
    cursor_follows_swapped_bufs = false,
    ignored_events = { 'BufEnter', 'WinEnter' },
    multiplexer_integration = nil,
    disable_multiplexer_nav_when_zoomed = true,
    kitty_password = nil,
    log_level = 'info',
  }
end
