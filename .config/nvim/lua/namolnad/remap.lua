-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights on Esc' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, { desc = 'Open Ex command line' })

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move visual selection down one line' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move visual selection up one line' })

vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'join lines and keep cursor position' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Move down half page and center cursor' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Move up half page and center cursor' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Move to next search result and center cursor' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Move to previous search result and center cursor' })

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = 'Paste over visual selection without replacing default register contents' })

-- next greatest remap ever : asbjornHaland
-- Copy to global pasteboard
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["*y]], { desc = 'Yank to global pasteboard' })
vim.keymap.set('n', '<leader>Y', [["*Y]], { desc = 'Yank (back) to global pasteboard' })

-- Paste from global pasteboard
vim.keymap.set('n', '<leader>p', [["*p]], { desc = 'Paste from global pasteboard' })
vim.keymap.set('n', '<leader>P', [["*P]], { desc = 'Paste (back) from global pasteboard' })

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

-- Esc vs Ctrl-c... Who gives a damn?
vim.keymap.set('i', '<C-c>', '<Esc>', { desc = 'Use <C-c> to escape' })

vim.keymap.set('n', 'Q', '<nop>', { desc = 'Disable Ex mode' })
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>', { desc = 'Open tmux sessionizer' })

vim.keymap.set('n', '<leader>S', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'Globally replace word under cursor' })

-- vim.keymap.set("n", "<leader><leader>", function()
--     vim.cmd("so")
-- end)

vim.keymap.set('n', '<leader><leader>', '<C-^>', { desc = 'Switch between last two buffers' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>', { silent = true, desc = 'Disable <left>' })
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>', { silent = true, desc = 'Disable <right>' })
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>', { silent = true, desc = 'Disable <up>' })
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>', { silent = true, desc = 'Disable <down>' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
