local Namolnad_Fugitive = vim.api.nvim_create_augroup('Namolnad_Fugitive', { clear = true })

return {
  'tpope/vim-fugitive',
  config = function()
    vim.keymap.set('n', '<leader>gs', vim.cmd.Git, { desc = 'Git status' })

    local autocmd = vim.api.nvim_create_autocmd
    autocmd('BufWinEnter', {
      group = Namolnad_Fugitive,
      pattern = '*',
      callback = function()
        if vim.bo.ft ~= 'fugitive' then
          return
        end

        local bufnr = vim.api.nvim_get_current_buf()
        vim.keymap.set('n', '<leader>p', '<cmd>Git push<CR>', { buffer = bufnr, desc = 'Push' })

        -- rebase always
        vim.keymap.set('n', '<leader>P', '<cmd>Git pull --rebase<CR>', { buffer = bufnr, desc = 'Pull with rebase' })

        vim.keymap.set('n', '<leader>t', '<cmd>Git push -u origin ', { buffer = bufnr, remap = false, desc = 'Set up tracking & push to origin' })
      end,
    })

    vim.keymap.set('n', '<leader>gu', '<cmd>diffget //2<CR>', { desc = '[G]it diff: Get from left' })
    vim.keymap.set('n', '<leader>gh', '<cmd>diffget //3<CR>', { desc = '[G]it diff: Get from right' })
  end,
}
