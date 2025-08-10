return {
  'almo7aya/openingh.nvim',
  config = function()
    vim.keymap.set('n', '<leader>gr', ':OpenInGHRepo <CR>',
      { desc = 'OpenInGH: Open repo in GitHub', silent = true, noremap = true })
    vim.keymap.set('n', '<leader>gf', ':OpenInGHFile <CR>',
      { desc = 'OpenInGH: Open current file in GitHub', silent = true, noremap = true })
    vim.keymap.set('v', '<leader>gf', ':OpenInGHFileLines <CR>',
      { desc = 'OpenInGH: Open lines in GitHub', silent = true, noremap = true })
  end,
}
