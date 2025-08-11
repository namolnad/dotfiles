return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {},
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  dependencies = {
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      -- support for image pasting
      "HakonHarnes/img-clip.nvim",
      event = "VeryLazy",
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
  setup = function()
    -- This setup function is called once the user has installed the plugin
    -- If the plugin is lazy loaded, this function is called when the plugin is loaded
    -- This is a good place to put your key mappings
    -- For more examples, see the `setup` function in the `examples` directory
    local avante = require("avante")

    avante.setup({
      auto_suggestions_provider = "claude",
      provider = "claude",
      -- provider = "openai",
      behavior = {
        auto_suggestions = true,
        -- diff = true,
        -- suggestion = true,
        -- jump = true,
        -- sidebar = true,
      },
      input = {
        provider = "snacks",
        provider_opts = {
          -- Additional snacks.input options
          title = "Avante Input",
          icon = " ",
        },
      },
      mappings = {
        --- @class AvanteConflictMappings
        diff = {
          ours = "co",
          theirs = "ct",
          all_theirs = "ca",
          both = "cb",
          cursor = "cc",
          next = "]x",
          prev = "[x",
        },
        suggestion = {
          accept = "<M-l>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
        jump = {
          next = "]]",
          prev = "[[",
        },
        submit = {
          normal = "<CR>",
          insert = "<C-s>",
        },
        sidebar = {
          apply_all = "A",
          apply_cursor = "a",
          switch_windows = "",         -- disabled (formerly "Tab")
          reverse_switch_windows = "", -- disabled (formerly "S-Tab")
        },
      },
      shortcuts = {
        {
          name = "refactor",
          description = "Refactor code with best practices",
          details = "Automatically refactor code to improve readability, maintainability, and follow best practices while preserving functionality",
          prompt = "Please refactor this code following best practices, improving readability and maintainability while preserving functionality."
        },
        {
          name = "test",
          description = "Generate unit tests",
          details = "Create comprehensive unit tests covering edge cases, error scenarios, and various input conditions",
          prompt = "Please generate comprehensive unit tests for this code, covering edge cases and error scenarios."
        },
        -- Add more custom shortcuts...
      },
    })
  end,
}
