local conf = require("telescope.config").values
local finders = require "telescope.finders"
local make_entry = require "telescope.make_entry"
local pickers = require "telescope.pickers"

local flatten = function(tbl) return vim.iter(tbl):flatten():totable() end

local function multi_ripgrep(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.shortcuts = opts.shortcuts
      or {
        ["l"] = "lua",
        ["lua"] = "lua",
        ["v"] = "vim",
        ["vim"] = "vim",
        ["n"] = "{vim,lua}",
        ["c"] = "c",
        ["r"] = "rb",
        ["rb"] = "rb",
        ["t"] = "{ts,tsx}",
      }
  opts.pattern = opts.pattern or "%s"

  local custom_grep = finders.new_async_job {
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local prompt_split = vim.split(prompt, "  ")

      local args = { "rg" }
      if prompt_split[1] then
        table.insert(args, "-e")
        table.insert(args, prompt_split[1])
      end

      if prompt_split[2] then
        table.insert(args, "-g")

        local pattern = prompt_split[2]
        if opts.shortcuts[pattern] then
          pattern = opts.shortcuts[pattern]
        end

        -- Add *. prefix if pattern doesn't start with *
        if not pattern:match("^%*%.") then
          pattern = "*." .. pattern
        end

        table.insert(args, string.format(opts.pattern, pattern))
      end

      return flatten {
        args,
        {
          '--glob=!node_modules',
          '--glob=!app/assets/builds',
          '--glob=!.git/',
          '--glob=!.DS_Store',
          '--glob=!log/',
          "--hidden",
          "--no-ignore",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      }
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  }

  pickers
      .new(opts, {
        debounce = 100,
        prompt_title = "Live Grep (with shortcuts)",
        finder = custom_grep,
        previewer = conf.grep_previewer(opts),
        sorter = require("telescope.sorters").empty(),
      })
      :find()
end

return multi_ripgrep
