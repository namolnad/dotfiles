return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-plenary",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-vitest"),
          require("neotest-plenary").setup({
            -- this is my standard location for minimal vim rc
            -- in all my projects
            min_init = "./scripts/tests/minimal.vim",
          }),
          -- ruby
          require("neotest-vim-test").setup({
            file_pattern = "spec/*_spec.rb",
            test_pattern = "it '",
            test_file_pattern = "spec/%s_spec.rb",
            test_command = "bundle exec rspec %s",
          }),
        }
      })

      vim.keymap.set("n", "<leader>tc", function()
        neotest.run.run()
      end)

      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end)
    end,
  },
}
