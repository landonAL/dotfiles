vim.opt.wrap = false
vim.opt.relativenumber = true
vim.opt.showmatch = false
vim.opt.ignorecase = true
vim.opt.mouse = 'a'
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.number = true
vim.opt.cursorline = false
vim.opt.ttyfast = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.termguicolors = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true

vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
    vim.api.nvim_set_hl(0, 'Normal', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'NormalFloat', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'FloatBorder', {bg = 'none'})
    vim.api.nvim_set_hl(0, 'Pmenu', {bg = 'none'})
end)
