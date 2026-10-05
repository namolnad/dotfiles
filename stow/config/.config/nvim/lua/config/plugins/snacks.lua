return function()
  ---@type snacks.Config
  require('snacks').setup {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
        { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
      },
    },
    indent = {},
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    scratch = {
      ft = "markdown",
    },
    styles = {
      notification = {
        wo = { wrap = true }
      }
    }
  }

  -- Keymaps
  vim.keymap.set('n', '<leader>.', function() Snacks.scratch() end, { desc = 'Snacks: Toggle Scratch Buffer' })
  vim.keymap.set('n', '<leader>>', function() Snacks.scratch.select() end, { desc = 'Snacks: Select Scratch Buffer' })
  -- <leader>nh rather than <leader>n, which would wait to rule out neogen's <leader>nf/nt
  vim.keymap.set('n', '<leader>nh', function() Snacks.notifier.show_history() end,
    { desc = 'Snacks: [N]otification [H]istory' })
  vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Snacks: Delete Buffer' })
  vim.keymap.set('n', '<leader>rf', function() Snacks.rename.rename_file() end, { desc = 'Snacks: [R]ename [F]ile' })
  vim.keymap.set('n', '<leader>gB', function() Snacks.gitbrowse() end, { desc = 'Snacks: Git Browse' })
  -- <leader>gb (gitsigns blame toggle) and <leader>gf (openingh) are taken
  vim.keymap.set('n', '<leader>gi', function() Snacks.git.blame_line() end, { desc = 'Snacks: Git Blame [I]nfo for Line' })
  vim.keymap.set('n', '<leader>gh', function() Snacks.lazygit.log_file() end,
    { desc = 'Snacks: Lazygit Current File [H]istory' })
  vim.keymap.set('n', '<leader>gg', function() Snacks.lazygit() end, { desc = 'Snacks: Lazygit' })
  vim.keymap.set('n', '<leader>gl', function() Snacks.lazygit.log() end, { desc = 'Snacks: Lazygit Log (cwd)' })
  vim.keymap.set('n', '<leader>un', function() Snacks.notifier.hide() end,
    { desc = 'Snacks: Dismiss All Notifications' })
  -- Normal mode only: in terminal mode every [ and ] would wait for a second keypress
  vim.keymap.set('n', ']]', function() Snacks.words.jump(vim.v.count1) end,
    { desc = 'Snacks: Next Reference' })
  vim.keymap.set('n', '[[', function() Snacks.words.jump(-vim.v.count1) end,
    { desc = 'Snacks: Prev Reference' })
  vim.keymap.set('n', '<leader>N', function()
    Snacks.win({
      file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
      width = 0.6,
      height = 0.6,
      wo = {
        spell = false,
        wrap = false,
        signcolumn = "yes",
        statuscolumn = " ",
        conceallevel = 3,
      },
    })
  end, { desc = 'Snacks: Neovim News' })
end
