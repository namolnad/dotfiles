return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup {}

    vim.keymap.set('n', '<M-h><M-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Toggle/explore Harpoon quick menu' })

    vim.keymap.set('n', '<M-h><M-a>', function()
      harpoon:list():add()
    end, { desc = 'Add current file to Harpoon' })
    vim.keymap.set('n', '<M-h><M-r>', function()
      harpoon:list():remove()
    end, { desc = 'Remove current file from Harpoon' })
    vim.keymap.set('n', '<M-h><M-c>', function()
      harpoon:list():clear()
    end, { desc = 'Clear Harpoon list' })

    vim.keymap.set('n', '<M-h><M-h>', function()
      harpoon:list():select(1)
    end, { desc = 'Select Harpoon item 1' })
    vim.keymap.set('n', '<M-h><M-j>', function()
      harpoon:list():select(2)
    end, { desc = 'Select Harpoon item 2' })
    vim.keymap.set('n', '<M-h><M-k>', function()
      harpoon:list():select(3)
    end, { desc = 'Select Harpoon item 3' })
    vim.keymap.set('n', '<M-h><M-l>', function()
      harpoon:list():select(4)
    end, { desc = 'Select Harpoon item 4' })

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<M-C-p>', function()
      harpoon:list():prev()
    end, { desc = 'Select previous Harpoon item' })
    vim.keymap.set('n', '<M-C-n>', function()
      harpoon:list():next()
    end, { desc = 'Select next Harpoon item' })

    -- Set <leader>1..<leader>5 be my shortcuts to moving to the files
    for _, idx in ipairs { 1, 2, 3, 4, 5 } do
      vim.keymap.set('n', string.format('<leader>%d', idx), function()
        harpoon:list():select(idx)
      end)
    end
  end,
}
