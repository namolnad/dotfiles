return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  config = function()
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    require('mini.surround').setup({
      mappings = {
        add = 'ys',          -- [Y]ou add [s]urrounding in Normal and Visual modes
        delete = 'ds',       -- [D]elete [s]urrounding
        replace = 'cs',      -- [C]hange [s]urrounding
        find = '',           -- Find surrounding (to the right)
        find_left = '',      -- Find surrounding (to the left)
        highlight = '',      -- Highlight surrounding
        update_n_lines = '', -- Update `n_lines`
      },
    })

    -- Simple and easy statusline.
    --  You could remove this setup call if you don't like it,
    --  and try some other statusline plugin
    local statusline = require 'mini.statusline'

    -- You can configure sections in the statusline by overriding their
    -- default behavior. For example, here we set the section for
    -- cursor location to LINE:COLUMN
    ---@diagnostic disable-next-line: duplicate-set-field
    statusline.section_location = function()
      return '%2l:%-2v'
    end

    statusline.setup {
      -- set use_icons to true if you have a Nerd Font
      use_icons = vim.g.have_nerd_font,
      content = {
        active = function()
          local check_macro_recording = function()
            if vim.fn.reg_recording() ~= "" then
              return "Recording @" .. vim.fn.reg_recording()
            else
              return ""
            end
          end

          local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
          local git = MiniStatusline.section_git({ trunc_width = 40 })
          local diff = MiniStatusline.section_diff({ trunc_width = 75 })
          local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
          local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
          local filename = MiniStatusline.section_filename({ trunc_width = 140 })
          local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
          local location = MiniStatusline.section_location({ trunc_width = 200 })
          local search = MiniStatusline.section_searchcount({ trunc_width = 75 })
          local macro = check_macro_recording()

          return MiniStatusline.combine_groups({
            { hl = mode_hl,                 strings = { mode } },
            { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
            "%<", -- Mark general truncate point
            { hl = "MiniStatuslineFilename",    strings = { filename } },
            "%=", -- End left alignment
            { hl = "MiniStatuslineModeCommand", strings = { macro } },
            { hl = "MiniStatuslineFilename",    strings = { lsp } },
            { hl = "MiniStatuslineFileinfo",    strings = { fileinfo } },
            { hl = mode_hl,                     strings = { search, location } },
          })
        end,
      },
    }

    -- Pair brackets, quotes, etc.
    require('mini.pairs').setup()

    -- Use unimpaired instead of bracketed
    -- require('mini.bracketed').setup()

    -- ... and there is more!
    --  Check out: https://github.com/echasnovski/mini.nvim
  end,
}
