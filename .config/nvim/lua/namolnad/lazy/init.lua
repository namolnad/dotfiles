return {
  {
    "nvim-lua/plenary.nvim",
    name = "plenary"
  },
  "github/copilot.vim",
  "gpanders/editorconfig.nvim",
  {
    "rails_schema",
    dir = "~/Developer/rails_schema.nvim",
    config = function()
      require("rails_schema").setup({
        -- keymap = "<leader><leader>s",
      })
    end
  },
}
