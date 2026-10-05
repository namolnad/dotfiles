function SetColorScheme(color)
  color = color or 'tokyonight'
  vim.cmd.colorscheme(color)

  -- Transparent background whatever the scheme. nvim_set_hl replaces the whole
  -- group, so merge into the scheme's definition to keep its fg and styles.
  for _, group in ipairs { 'Normal', 'NormalFloat' } do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    vim.api.nvim_set_hl(0, group, vim.tbl_extend('force', hl, { bg = 'none' }))
  end
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
