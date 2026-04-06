return function()
  local dap = require 'dap'
  local dapui = require 'dapui'

  require('mason-nvim-dap').setup {
    automatic_setup = true,
    automatic_installation = true,
    handlers = {},
    ensure_installed = { 'delve' },
  }

  vim.keymap.set('n', '<F5>', dap.continue, { desc = 'DAP: Debug - Start/Continue' })
  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'DAP: Debug - Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'DAP: Debug - Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'DAP: Debug - Step Out' })
  vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'DAP: Debug - Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'DAP: Debug - Set Breakpoint' })

  dapui.setup()
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'DAP: Debug - See last session result.' })

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  require('dap-ruby').setup()
end
