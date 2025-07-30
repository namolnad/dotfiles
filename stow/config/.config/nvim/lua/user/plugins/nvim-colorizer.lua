return {
  -- Adds color highlighting for hex codes, like #ff0000
  'norcalli/nvim-colorizer.lua',
  config = function()
    require('colorizer').setup()
  end,
}
