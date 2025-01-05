return {
  {
    'L3MON4D3/LuaSnip',
    -- follow latest release.
    version = 'v2.*', -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = 'make install_jsregexp',

    dependencies = { 'rafamadriz/friendly-snippets' },

    config = function()
      local ls = require 'luasnip'
      ls.filetype_extend('javascript', { 'jsdoc' })

      -- --- TODO: What is expand?
      -- vim.keymap.set({ 'i' }, '<C-k>', function()
      --   ls.expand()
      -- end, { silent = true, desc = "Snippets: Expand snippet" })
      --
      -- vim.keymap.set({ 'i', 's' }, '<C-l>', function()
      --   ls.jump(1)
      -- end, { silent = true, desc = "Snippets: Jump to next snippet position" })
      --
      -- vim.keymap.set({ 'i', 's' }, '<C-h>', function()
      --   ls.jump(-1)
      -- end, { silent = true, desc = "Snippets: Jump to previous snippet position" })
      --
      -- vim.keymap.set({ 'i', 's' }, '<C-j>', function()
      --   if ls.choice_active() then
      --     ls.change_choice(1)
      --   end
      --   if ls.choice_active() then
      --     ls.change_choice(1)
      --   end
      -- end, { desc = "Snippets: Next choice", silent = true })
    end,
  },
}
