local M = {}

function M.setup()
  vim.diagnostic.config {
    float = {
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      source = true,
      header = '',
      prefix = '',
    },
  }
end

return M