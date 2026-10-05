return function()
  local secrets = require 'config.modules.secrets'

  require('minuet').setup {
    -- Only source-code buffers that aren't secrets ever reach the provider
    -- (see config/modules/secrets.lua)
    enable_predicates = {
      function()
        return secrets.ai_allowed()
      end,
    },
    -- duet sends recent edits from other buffers along with each request, and
    -- its recorder snapshots buffers to disk. Unused here, so keep it off.
    duet = {
      recent_edits = { enabled = false },
    },
    provider_options = {
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
