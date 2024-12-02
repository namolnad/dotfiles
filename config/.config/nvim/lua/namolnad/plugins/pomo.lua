return {
  'epwalsh/pomo.nvim',
  config = function()
    require("pomo").setup({
      sessions = {
        focus = { -- You can have multiple sessions, call :TimerSession <name> to start
          { name = "Work",        duration = "25m" },
          { name = "Short Break", duration = "5m" },
          { name = "Work",        duration = "25m" },
          { name = "Short Break", duration = "5m" },
          { name = "Work",        duration = "25m" },
          { name = "Long Break",  duration = "15m" },
        },
      },
      work_duration = 25,
      short_break_duration = 5,
      long_break_duration = 15,
      cycles_before_long_break = 4,
      update_interval = 1000,
      timers = {
        {
          name = 'long_break',
          duration = 15,
        },

      },
      notifiers = {
        {
          name = 'Default',
          opts = {
            -- With 'nvim-notify', when 'sticky = true' you'll have a live timer pop-up
            -- continuously displayed. If you only want a pop-up notification when the timer starts
            -- and finishes, set this to false.
            sticky = true,

            -- Configure the display icons:
            title_icon = "󱎫",
            text_icon = "󰄉",
            -- Replace the above with these if you don't have a patched font:
            -- title_icon = "⏳",
            -- text_icon = "⏱️",
          },
        },
        {
          name = 'System'
        }
      },
      on_complete = function()
        vim.notify('Pomodoro completed!', vim.log.levels.INFO, { title = 'Pomo.nvim' })
      end,
    })
  end
}
