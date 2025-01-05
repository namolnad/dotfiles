return {
  'almo7aya/openingh.nvim',
  config = function()
    vim.keymap.set('n', '<Leader>gr', ':OpenInGHRepo <CR>',
      { desc = 'OpenInGH: Open repo in GitHub', silent = true, noremap = true })
    vim.keymap.set('n', '<Leader>gf', ':OpenInGHFile <CR>',
      { desc = 'OpenInGH: Open current file in GitHub', silent = true, noremap = true })
    vim.keymap.set('v', '<Leader>gf', ':OpenInGHFileLines <CR>',
      { desc = 'OpenInGH: Open lines in GitHub', silent = true, noremap = true })
  end,
}
