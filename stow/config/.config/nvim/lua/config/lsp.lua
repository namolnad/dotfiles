local default_capabilities = vim.lsp.protocol.make_client_capabilities()
local capabilities = vim.tbl_deep_extend(
  'force',
  default_capabilities,
  {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  }
)

vim.lsp.config('*', { capabilities = capabilities })

local function has_sorbet_config()
  return vim.fn.filereadable(vim.fn.getcwd() .. "/sorbet/config") == 1
end

local servers = {
  'lua_ls',
  'rubocop',
  'ruby_lsp',
  'ts_ls',
}

if has_sorbet_config() then
  table.insert(servers, 'sorbet')
end

vim.lsp.enable(servers)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('user-lsp-attach', { clear = true }),
  callback = function(event)
    -- Reference highlighting under the cursor comes from snacks.words (snacks.lua)

    -- Blink.cmp handles completion, so we don't need the built-in completion
    -- if client:supports_method('textDocument/completion') then
    --   vim.opt.completeopt = {
    --     'menu',
    --     'menuone',
    --     'noinsert',
    --     'fuzzy',
    --     'popup',
    --   }
    --   vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
    --   vim.keymap.set('i', '<C-Space>', function()
    --     vim.lsp.completion.get()
    --   end)
    -- end

    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Telescope-routed LSP navigation (superior multi-result UI)
    map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    -- grr, not gr: a gr map would wait to rule out the built-in grn/gra/gri/...
    map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    -- K (hover), grn (rename), gra (code action) are 0.12 defaults; gD is not
  end,
})


vim.diagnostic.config {
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
  },
  virtual_lines = {
    current_line = true
  },
}
