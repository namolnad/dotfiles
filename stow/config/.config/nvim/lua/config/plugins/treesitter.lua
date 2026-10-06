return function()
  -- nvim-treesitter v1.0+ (the main branch) only installs parsers and queries.
  -- Ensure parsers are installed (deferred to avoid blocking startup)
  vim.schedule(function()
    require('nvim-treesitter.install').install(require('config.parsers'))
  end)

  -- Highlighting has to be started per buffer: Neovim 0.12 only does it for
  -- lua, markdown, help and query. Filetypes without a parser keep regex syntax.
  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('user-treesitter-highlight', { clear = true }),
    callback = function(args)
      if vim.treesitter.highlighter.active[args.buf] or not pcall(vim.treesitter.start, args.buf) then
        return
      end
      -- Ruby's indent script reads regex syntax groups, so keep both on
      if args.match == 'ruby' then
        vim.bo[args.buf].syntax = 'ON'
      end
    end,
  })

  -- Textobjects (new standalone API)
  require('nvim-treesitter-textobjects').setup {
    select = {
      lookahead = true,
      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@function.outer'] = 'V',
        ['@class.outer'] = '<c-v>',
      },
      include_surrounding_whitespace = true,
    },
  }

  local select_textobject = require('nvim-treesitter-textobjects.select').select_textobject
  vim.keymap.set({ 'x', 'o' }, 'af', function()
    select_textobject('@function.outer', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'if', function()
    select_textobject('@function.inner', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'ac', function()
    select_textobject('@class.outer', 'textobjects')
  end)
  vim.keymap.set({ 'x', 'o' }, 'ic', function()
    select_textobject('@class.inner', 'textobjects')
  end, { desc = 'Select inner part of a class region' })
  vim.keymap.set({ 'x', 'o' }, 'as', function()
    select_textobject('@local.scope', 'locals')
  end, { desc = 'Select language scope' })

  -- Treesitter context
  require('treesitter-context').setup {
    enable = true,
    max_lines = 0,
    min_window_height = 0,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    separator = nil,
    zindex = 20,
    on_attach = nil,
  }
end
