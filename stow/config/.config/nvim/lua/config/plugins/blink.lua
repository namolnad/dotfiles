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
      providers = {
        minuet = {
          name = 'minuet',
          module = 'minuet.blink',
          async = true,
          timeout_ms = 3000,
          score_offset = 50,
        },
      },
    },
    signature = { enabled = true },
  }
end
