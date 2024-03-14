vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

local augroup = vim.api.nvim_create_augroup
local IndentationGroup = augroup('IndentationGroup', {})
local autocmd = vim.api.nvim_create_autocmd

autocmd('FileType', {
    group = IndentationGroup,
    pattern = "ruby,haml,eruby,yaml,html,sass,cucumber",
    callback = function()
        vim.bo.autoindent = true
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
    end

})

autocmd('FileType', {
    group = IndentationGroup,
    pattern = "python",
    callback = function()
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
    end
})

autocmd('FileType', {
    group = IndentationGroup,
    pattern = "go",
    callback = function()
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
        vim.cmd("retab")
    end
})

autocmd('FileType', {
    group = IndentationGroup,
    pattern = "swift",
    callback = function()
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
    end
})

autocmd('FileType', {
    group = IndentationGroup,
    pattern = "js,ts,jsx,tsx",
    callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
        vim.bo.autoindent = true
        vim.bo.smartindent = true
        vim.bo.cindent = false
    end
})

autocmd('FileType', {
    group = IndentationGroup,
    pattern = "slim",
    callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
    end
})

autocmd('FileType', {
    group = IndentationGroup,
    pattern = "mkd,markdown",
    callback = function()
        vim.bo.autoindent = true
        vim.bo.formatoptions = "tcroqn2"
        vim.bo.comments = "n:&gt;"
        vim.bo.syn = "off"
    end
})
