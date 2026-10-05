-- Mouse wheel handling for telescope pickers. Telescope's border windows let
-- mouse events through, so on a border, a title or the gap between panels the
-- wheel would reach the window behind the picker. These mappings send it to the
-- panel under the pointer, border included, and swallow it everywhere else.
local action_state = require 'telescope.actions.state'

local M = {}

--- Whether a screen position falls inside a window or its one-cell border
---@param win integer?
---@param row integer 1-based screen row
---@param col integer 1-based screen column
---@return boolean
local function over(win, row, col)
  if not (win and vim.api.nvim_win_is_valid(win)) then
    return false
  end
  local pos = vim.api.nvim_win_get_position(win) -- 0-based, so the border sits at pos itself
  return row >= pos[1] and row <= pos[1] + vim.api.nvim_win_get_height(win) + 1
    and col >= pos[2] and col <= pos[2] + vim.api.nvim_win_get_width(win) + 1
end

--- A telescope mapping that scrolls the panel under the mouse
---@param direction 1|-1 1 scrolls down, -1 up
function M.wheel(direction)
  return function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local mouse = vim.fn.getmousepos()
    local lines = tonumber(vim.o.mousescroll:match 'ver:(%d+)') or 3
    for _, win in ipairs { picker.preview_win, picker.results_win } do
      if over(win, mouse.screenrow, mouse.screencol) then
        local key = direction > 0 and '\5' or '\25' -- <C-e> / <C-y>
        vim.api.nvim_win_call(win, function()
          vim.cmd('normal! ' .. lines .. key)
        end)
        return
      end
    end
  end
end

return M
