return function()
  require('unimpaired').setup()

  vim.keymap.set('v', ']e', ":m '>+1<CR>gv=gv", { desc = 'Move visual selection down' })
  vim.keymap.set('v', '[e', ":m '<-2<CR>gv=gv", { desc = 'Move visual selection up' })
end
