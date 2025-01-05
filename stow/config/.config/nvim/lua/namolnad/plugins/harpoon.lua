return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup {}

    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { desc = "Harpoon: " .. desc })
    end

    -- Main Harpoon commands
    map('<leader>ha', function()
      harpoon:list():add()
    end, 'Add file')

    map('<leader>he', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, 'Quick menu')

    map('<leader>hr', function()
      harpoon:list():remove()
    end, 'Remove file')

    map('<leader>hc', function()
      harpoon:list():clear()
    end, 'Clear all')

    -- Quick navigation
    map('<C-h>', function()
      harpoon:list():select(1)
    end, 'File 1')

    map('<C-j>', function()
      harpoon:list():select(2)
    end, 'File 2')

    map('<C-k>', function()
      harpoon:list():select(3)
    end, 'File 3')

    map('<C-l>', function()
      harpoon:list():select(4)
    end, 'File 4')

    -- Navigate through list
    map('[h', function()
      harpoon:list():prev()
    end, 'Prev file')

    map(']h', function()
      harpoon:list():next()
    end, 'Next file')

    -- Set <leader>1..<leader>5 be my shortcuts to moving to the files
    for _, file in ipairs { 1, 2, 3, 4, 5 } do
      for _, binding in ipairs { string.format('<leader>%d', file), string.format('<M-%d>', file) } do
        map(binding, function()
          harpoon:list():select(file)
        end, string.format('File %d', file))
      end
    end
  end,
}
