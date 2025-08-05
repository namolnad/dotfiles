local M = {}

local function get_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend(
    'force',
    capabilities,
    require('blink.cmp').get_lsp_capabilities(),
    { textDocument = { foldingRange = { dynamicRegistration = false, lineFoldingOnly = true } } }
  )
  return capabilities
end


local function get_server_configs()
  local rbenv_root = vim.fn.trim(vim.fn.system('rbenv root'))

  return {
    html_lsp = {
      filetypes = { 'html' }
    },
    ts_ls = {},
    lua_ls = {
      settings = {
        Lua = {
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    },
    ruby_lsp = {
      cmd = { rbenv_root .. '/shims/ruby-lsp' },
    },
    rubocop = {
      cmd = { 'bundle', 'exec', 'rubocop', '--lsp' },
    },
    sorbet = {
      cmd = { rbenv_root .. '/shims/srb', 'tc', '--lsp' },
    },
  }
end

function M.setup()
  local servers = get_server_configs()
  local capabilities = get_capabilities()

  -- Setup all servers using vim.lsp.config and vim.lsp.enable
  for server_name, server_config in pairs(servers) do
    server_config.capabilities = capabilities

    -- Ensure all servers use Replace behavior for snippets
    server_config.settings = server_config.settings or {}
    server_config.settings.completion = server_config.settings.completion or {}
    server_config.settings.completion.callSnippet = 'Replace'

    vim.lsp.config(server_name, server_config)
    vim.lsp.enable(server_name)
  end
end

return M
