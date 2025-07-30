local M = {}

function M.setup()
  require('user.lsp.keymaps').setup()
  require('user.lsp.diagnostics').setup()
  require('user.lsp.servers').setup()
end

return M