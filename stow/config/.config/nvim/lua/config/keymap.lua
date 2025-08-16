-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Remap: Clear search highlights on Esc' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Remap: Move visual selection down one line' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Remap: Move visual selection up one line' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Remap: join lines and keep cursor position' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Remap: Move down half page and center cursor' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Remap: Move up half page and center cursor' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Remap: Move to next search result and center cursor' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Remap: Move to previous search result and center cursor' })

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]],
  { desc = 'Remap: Paste over visual selection without replacing default register contents' })

-- next greatest remap ever : asbjornHaland
-- Copy to global pasteboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["*y]], { desc = 'Remap: Yank to global pasteboard' })
vim.keymap.set('n', '<leader>Y', [["*Y]], { desc = 'Remap: Yank (back) to global pasteboard' })

-- Paste from global pasteboard
vim.keymap.set('n', '<leader>p', [["*p]], { desc = 'Remap: Paste from global pasteboard' })
vim.keymap.set('n', '<leader>P', [["*P]], { desc = 'Remap: Paste (back) from global pasteboard' })

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- Esc vs Ctrl-c... Who gives a damn?
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Remap: Use <C-c> to escape' })
vim.keymap.set({ 'n', 'i' }, 'kj', '<Esc>', { desc = 'Remap: Use kj to escape' })
vim.keymap.set({ 'n', 'i' }, 'jk', '<Esc>', { desc = 'Remap: Use jk to escape' })

vim.keymap.set('n', 'Q', '<nop>', { desc = 'Remap: Disable Ex mode' })
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = 'Remap: Open tmux sessionizer' })

vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = 'Remap: Globally replace word under cursor' })

vim.keymap.set('n', '<leader>x', '<cmd>luafile %<CR>', { desc = 'Remap: Source current lua file' })

vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Remap: Switch between last two buffers' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>', { silent = true, desc = 'Remap: Disable <left>' })
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>', { silent = true, desc = 'Remap: Disable <right>' })
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>', { silent = true, desc = 'Remap: Disable <up>' })
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>', { silent = true, desc = 'Remap: Disable <down>' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Remap: Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Remap: Open diagnostic [Q]uickfix list' })

-- Visual mode mappings
vim.keymap.set('v', '<leader>r', [["hy:%s/<C-r>h//g<left><left>]], { desc = 'Remap: Replace in visual selection' })
vim.keymap.set('v', '<leader>c', [["hy:%s/<C-r>h//gc<left><left><left>]],
  { desc = 'Remap: Replace in visual selection with confirmation' })
vim.keymap.set('v', '<C-s>', [[:sort<CR>]], { desc = 'Remap: Sort visual selection' })
