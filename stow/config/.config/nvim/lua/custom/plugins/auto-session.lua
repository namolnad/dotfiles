return {
  'rmagatti/auto-session',
  config = function()
    local auto_session = require 'auto-session'

    auto_session.setup {
      log_level = 'error',
      auto_save_enabled = true,
      auto_restore_enabled = false,
      auto_restore_enable_last_session = false,
      auto_session_suppress_dirs = { '~/', '~/Developer/', '~/Downloads', '~/Documents', '~/Desktop/' },
    }

    local keymap = vim.keymap

    keymap.set('n', '<leader>WR', '<cmd>SessionRestore<CR>', { desc = 'AutoSession: Restore session for cwd' })             -- restore last workspace session for current directory
    keymap.set('n', '<leader>WS', '<cmd>SessionSave<CR>',
      { desc = 'AutoSession: Save session for auto session root dir' })                                                     -- save workspace session for current working directory
  end,
}
