local Namolnad_Fugitive = vim.api.nvim_create_augroup('Namolnad_Fugitive', { clear = true })

return {
  'tpope/vim-fugitive',
  config = function()
    local map = function(keys, func, bufnr, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = "Fugitive: " .. desc })
    end
    map('<leader>gs', vim.cmd.Git, nil, 'Git status')

    local autocmd = vim.api.nvim_create_autocmd
    autocmd('BufWinEnter', {
      group = Namolnad_Fugitive,
      pattern = '*',
      callback = function()
        if vim.bo.ft ~= 'fugitive' then
          return
        end


        local bufnr = vim.api.nvim_get_current_buf()

        map('<leader>P', '<cmd>Git push<CR>', bufnr, 'Push')
        map('gP', '<cmd>Git push<CR>', bufnr, 'Push')

        -- rebase always
        map('<leader>p', '<cmd>Git pull --rebase<CR>', bufnr, 'Pull with rebase')
        map('<leader>t', '<cmd>Git push -u origin ', bufnr, 'Set up tracking & push to origin')
      end,
    })

    map('<leader>gu', '<cmd>diffget //2<CR>', nil, 'Get from left')
    map('<leader>gh', '<cmd>diffget //3<CR>', nil, 'Get from right')
  end,
}
