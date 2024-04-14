return {
  'tpope/vim-dadbod',
  {
    'kristijanhusak/vim-dadbod-ui',
    config = function()
      vim.api.nvim_set_keymap('n', '<leader>du', ':DBUIToggle<CR>', { noremap = true, silent = true, desc = 'Toggle dadbod ui' })
    end,
  },
  'kristijanhusak/vim-dadbod-completion',
}
