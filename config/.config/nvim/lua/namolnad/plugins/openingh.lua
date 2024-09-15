return {
  'almo7aya/openingh.nvim',
  config = function()
    vim.keymap.set('n', '<Leader>gr', ':OpenInGHRepo <CR>', { desc = 'Open repo in GitHub', silent = true, noremap = true })
    vim.keymap.set('n', '<Leader>gf', ':OpenInGHFile <CR>', { desc = 'Open current file in GitHub', silent = true, noremap = true })
    vim.keymap.set('v', '<Leader>gf', ':OpenInGHFileLines <CR>', { desc = 'Open lines in GitHub', silent = true, noremap = true })
  end,
}
