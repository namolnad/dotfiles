local Namolnad_Commentary = vim.api.nvim_create_augroup('Namolnad_Commentary', { clear = true })

return {
  'tpope/vim-commentary',
  config = function()
    local autocmd = vim.api.nvim_create_autocmd

    autocmd('FileType', {
      group = Namolnad_Commentary,
      pattern = { 'typescriptreact', 'javascriptreact' },
      callback = function()
        vim.commentstring = '{/* %s */}'
      end,
    })
  end,
}
