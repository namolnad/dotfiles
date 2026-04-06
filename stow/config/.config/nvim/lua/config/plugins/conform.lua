return function()
  require('conform').setup {
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 500, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { { 'prettierd', 'prettier' } },
      ruby = { 'rubocop' },
      yaml = { 'prettier' },
      eruby = { 'erb_format' },
    },
  }

  vim.api.nvim_create_user_command('FormatDisable', function(args)
    if args.bang then
      vim.b.disable_autoformat = true
    else
      vim.g.disable_autoformat = true
    end
  end, {
    desc = 'Disable autoformat-on-save',
    bang = true,
  })
  vim.api.nvim_create_user_command('FormatEnable', function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
  end, {
    desc = 'Re-enable autoformat-on-save',
  })
  vim.keymap.set('n', '<leader>F', function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    print("Format-on-save: " .. (vim.b.disable_autoformat and "disabled" or "enabled"))
  end, { desc = 'Conform: Toggle format-on-save' })
end
