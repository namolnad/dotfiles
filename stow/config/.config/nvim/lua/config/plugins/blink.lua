return {
  {
    'saghen/blink.cmp',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    version = 'v1.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = {
        -- use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      cmdline = {
        keymap = {
          -- recommended, as the default keymap will only show and select the next item
          ['<Tab>'] = { 'show', 'accept' },
        },
        completion = { menu = { auto_show = true } },
      },
      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
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
            -- Should match minuet.config.request_timeout * 1000,
            -- since minuet.config.request_timeout is in seconds
            timeout_ms = 3000,
            score_offset = 50, -- Gives minuet higher priority among suggestions
          },
        },
        -- optionally disable cmdline completions
        -- cmdline = {},
      },
      signature = { enabled = true }
    },
    opts_extend = { "sources.default" }
  },
}
