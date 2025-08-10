return {
  'tummetott/unimpaired.nvim',
  event = 'VeryLazy',
  config = function()
    require('unimpaired').setup()

    -- Override visual mappings to use same logic as J/K remaps
    vim.keymap.set('v', ']e', ":m '>+1<CR>gv=gv", { desc = 'Move visual selection down' })
    vim.keymap.set('v', '[e', ":m '<-2<CR>gv=gv", { desc = 'Move visual selection up' })
  end,
}
