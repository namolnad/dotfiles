return {
  'github/copilot.vim',
  config = function()
    vim.keymap.set('i', '<C-y>', '<Plug>(copilot-suggest)', { desc = 'Request a copilot suggestion' })
  end,
}
