return function()
  local dap = require 'dap'
  local dapui = require 'dapui'

  -- Go, through delve (Homebrew's `dlv`, see the Brewfile)
  dap.adapters.delve = {
    type = 'server',
    port = '${port}',
    executable = {
      command = 'dlv',
      args = { 'dap', '-l', '127.0.0.1:${port}' },
    },
  }
  dap.configurations.go = {
    { type = 'delve', name = 'Delve: Debug', request = 'launch', program = '${workspaceFolder}' },
    {
      type = 'delve',
      name = 'Delve: Debug (Arguments)',
      request = 'launch',
      program = '${workspaceFolder}',
      args = function()
        return vim.split(vim.fn.input 'Args: ', ' ')
      end,
    },
    { type = 'delve', name = 'Delve: Debug test', request = 'launch', mode = 'test', program = '${file}' },
    { type = 'delve', name = 'Delve: Debug test (go.mod)', request = 'launch', mode = 'test', program = './${relativeFileDirname}' },
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
