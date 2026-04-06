return function()
  require('minuet').setup {
    provider_options = {
      claude = {
        api_key = 'AVANTE_ANTHROPIC_API_KEY',
      },
      codestral = {
        optional = {
          max_tokens = 512,
          stop = { '\n\n' },
        },
      },
    },
    virtualtext = {
      auto_trigger_ft = { 'lua', 'ruby', },
      keymap = {
        accept = '<A-A>',
        accept_line = '<A-a>',
        accept_n_lines = '<A-z>',
        prev = '<A-[>',
        next = '<A-]>',
        dismiss = '<A-e>',
      },
    },
  }
end
