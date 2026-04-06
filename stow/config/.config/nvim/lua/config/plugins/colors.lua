function SetColorScheme(color)
  color = color or 'tokyonight'
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

return function()
  require('tokyonight').setup {
    style = 'storm',
    transparent = true,
    terminal_colors = true,
    styles = {
      comments = { italic = true },
      keywords = { italic = false },
      sidebars = 'dark',
      floats = 'dark',
    },
  }
  SetColorScheme 'tokyonight'
end
