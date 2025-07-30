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

local function setup_ruby_servers()
  local rbenv_root = vim.fn.trim(vim.fn.system('rbenv root'))
  local lspconfig = require('lspconfig')
  local capabilities = get_capabilities()

  lspconfig.ruby_lsp.setup {
    cmd = { rbenv_root .. '/shims/ruby-lsp' },
    capabilities = capabilities,
  }

  lspconfig.rubocop.setup {
    cmd = { 'bundle', 'exec', 'rubocop', '--lsp' },
    capabilities = capabilities,
  }

  lspconfig.sorbet.setup {
    cmd = { rbenv_root .. '/shims/srb', 'tc', '--lsp' },
    capabilities = capabilities,
  }
end

local function get_server_configs()
  return {
    lua_ls = {
      settings = {
        Lua = {
          completion = {
            callSnippet = 'Replace',
          },
          diagnostics = {
            disable = { 'missing-fields' },
            globals = { 'vim', 'it', 'describe', 'before_each', 'after_each' },
          },
        },
      },
    },
    ts_ls = {},
  }
end

function M.setup()
  local servers = get_server_configs()
  local lspconfig = require('lspconfig')
  local capabilities = get_capabilities()

  setup_ruby_servers()

  require('mason').setup()

  -- Setup Mason-managed servers directly
  for server_name, server_config in pairs(servers) do
    server_config.capabilities = capabilities
    lspconfig[server_name].setup(server_config)
  end
end

return M