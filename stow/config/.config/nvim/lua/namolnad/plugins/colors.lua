function SetColorScheme(color)
  color = color or 'rose-pine'
  vim.cmd.colorscheme(color)

  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
end

return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    config = function()
      require('catppuccin').setup {
        flavour = 'mocha',
      }
      -- vim.cmd.colorscheme 'catppuccin'
    end,
  },
  {
    'folke/tokyonight.nvim',
    config = function()
      require('tokyonight').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = 'moon',         -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        transparent = true,     -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = false },
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = 'dark', -- style for sidebars, see below
          floats = 'dark',   -- style for floating windows
        },
      }
      -- vim.cmd.colorscheme 'tokyonight'
    end,
  },
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    config = function()
      require('rose-pine').setup {
        disable_background = true,
        variant = 'moon',
        highlight_groups = {
          TelescopeBorder = { fg = 'rose', bg = 'rose', blend = 10 },
          MiniStatuslineFilename = { fg = 'foam', bg = 'foam', blend = 10 },
          MiniStatuslineDevinfo = { fg = 'foam', bg = 'foam', blend = 10 },
        },
      }

      SetColorScheme('rose-pine')
    end,
  },
}
