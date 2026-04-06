return function()
  vim.api.nvim_set_keymap('n', '<leader>du', ':DBUIToggle<CR>',
    { noremap = true, silent = true, desc = 'Dadbod: Toggle UI' })
end
