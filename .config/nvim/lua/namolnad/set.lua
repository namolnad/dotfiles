vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25-blinkwait700-blinkon400-blinkoff250" --blinkon0 turns off the cursor blink

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

-- highlight current line
vim.opt.cursorline = true

vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.visualbell = true

local augroup = vim.api.nvim_create_augroup
local IndentationGroup = augroup('IndentationGroup', { clear = true })
local autocmd = vim.api.nvim_create_autocmd

autocmd({ 'BufRead', 'BufNewFile' }, {
  group = IndentationGroup,
  pattern = {
    "*.rake",
    "*.eruby",
    "Rakefile",
    "Gemfile",
    "*.ircrc",
    "*.ru",
    "*.gemspec",
    "*.erb",
  },
  callback = function()
    vim.bo.filetype = "ruby"
  end
})

autocmd('FileType', {
  group = IndentationGroup,
  pattern = {
    "ruby",
    "typescript",
    "javascript",
    "typescriptreact",
    "javascriptreact",
    "lua",
    "slim",
    "sh",
    "zsh",
    "bash",
    "fish",
    "vim",
  },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end
})

autocmd('FileType', {
  group = IndentationGroup,
  pattern = { "python", "go", "swift" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.tabstop = 4
  end
})

autocmd('FileType', {
  group = IndentationGroup,
  pattern = "markdown",
  callback = function()
    vim.bo.formatoptions = "tcroqn2"
    vim.bo.comments = "n:&gt;"
    vim.bo.syn = "off"
  end
})
