return {
  'github/copilot.vim',
  config = function()
    vim.keymap.set('i', '<C-c>', '<Plug>(copilot-suggest)', { desc = 'Copilot: Request a copilot suggestion' })
    vim.keymap.set('i', '<C-l>', '<Plug>(copilot-accept-word)',
      { desc = 'Copilot: Partially accept a copilot suggestion' })
    vim.keymap.set('i', '<C-j>', '<Plug>(copilot-accept-line)', { desc = 'Copilot: Accept a copilot suggestion' })
  end,
}
