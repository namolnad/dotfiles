return {
  'eandrju/cellular-automaton.nvim',
  config = function()
    vim.keymap.set('n', '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>', { desc = 'Make it rain' })
    vim.keymap.set('n', '<leader>fml', '<cmd>CellularAutomaton make_it_rain<CR>', { desc = 'Make it rain' })
    vim.keymap.set('n', '<leader>gol', '<cmd>CellularAutomaton game_of_life<CR>', { desc = 'Game of Life' })
  end,
}
