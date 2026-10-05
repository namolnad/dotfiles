return function()
  require('blink.cmp').setup {
    keymap = { preset = 'default' },
    appearance = {
      nerd_font_variant = 'mono'
    },
    cmdline = {
      keymap = {
        ['<Tab>'] = { 'show', 'accept' },
      },
      completion = { menu = { auto_show = true } },
    },
    sources = {
      default = {
        'lsp',
        'path',
        'snippets',
        'buffer',
        'minuet',
      },
      -- vim-dadbod-completion: table and column names in SQL buffers
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
      },
      providers = {
        dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
        minuet = {
          name = 'minuet',
          module = 'minuet.blink',
          -- minuet's own predicates skip manual <C-Space> requests, so blink must
          -- not call it at all outside the buffers secrets.ai_allowed() permits
          enabled = function()
            return require('config.modules.secrets').ai_allowed()
          end,
          async = true,
          timeout_ms = 3000,
          score_offset = 50,
        },
      },
    },
    signature = { enabled = true },
  }
end
