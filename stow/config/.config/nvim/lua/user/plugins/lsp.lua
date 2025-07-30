return {
  'neovim/nvim-lspconfig',
  dependencies = {
    'williamboman/mason.nvim', -- Binary installer (should install via Mason UI)
    'saghen/blink.cmp',        -- LSP Completion plugin
    'j-hui/fidget.nvim'        -- Adds LSP progress notifications
  },
  config = function()
    require('user.lsp').setup()
  end,
}
