return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  version = false, -- set this if you want to always pull the latest change
  opts = {
    -- auto_suggestions_provider = "claude",
    -- provider = "openai",
    -- openai = {
    --   endpoint = "https://api.openai.com/v1",
    --   model = "gpt-4o",             -- your desired model (or use gpt-4o, etc.)
    --   timeout = 30000,              -- Timeout in milliseconds, increase this for reasoning models
    --   temperature = 0,
    --   max_completion_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
    --   --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    -- },
    --
    -- provider = "ollama",
    -- ollama = {
    --   endpoint = "http://127.0.0.1:11434", -- Note that there is no /v1 at the end.
    --   model = "qwq:32b",
    -- },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    "zbirenbaum/copilot.lua",      -- for providers='copilot'
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
      -- auto_suggestions_provider = "claude",
      provider = "claude",
      -- provider = "openai",
      behavior = {
        -- auto_suggestions = true,
        -- diff = true,
        -- suggestion = true,
        -- jump = true,
        -- sidebar = true,
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
    })
  end,
}
