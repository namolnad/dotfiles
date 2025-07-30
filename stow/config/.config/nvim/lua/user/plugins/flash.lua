return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  ---@type Flash.Config
  opts = {},
  -- stylua: ignore
  keys = {
    { "<leader>s", mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash: [s]earch" },
    { "<leader>S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash: [S]earch for Treesitter nodes" },
    { "r",         mode = "o",               function() require("flash").remote() end,            desc = "Flash: [r]emote" },
    { "R",         mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Flash: Treesitter Search" },
    { "<c-s>",     mode = { "c" },           function() require("flash").toggle() end,            desc = "Flash: Toggle during Search" },
  },
}
