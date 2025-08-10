return {
  'JoosepAlviste/nvim-ts-context-commentstring',
  lazy = true,
  opts = {
    enable_autocmd = false,
  },
  config = function(_, opts)
    require('nvim-ts-context-commentstring').setup(opts)

    local get_option = vim.filetype.get_option
    vim.schedule(function()
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring' and require('ts_context_commentstring.internal').calculate_commentstring() or
            get_option(filetype, option)
      end
    end)
  end,
}
