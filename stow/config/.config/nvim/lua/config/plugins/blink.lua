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
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },

      -- default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, via `opts_extend`
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        -- optionally disable cmdline completions
        -- cmdline = {},
      },
      signature = { enabled = true }
    },
    opts_extend = { "sources.default" }
  },
}
