return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} }, -- Binary installer (must install via Mason UI)
    'saghen/blink.cmp',                       -- LSP Completion plugin
    { 'j-hui/fidget.nvim',       opts = {} }  -- Adds LSP progress notifications
  },
  config = function()
    require('user.lsp').setup()
  end,
}
