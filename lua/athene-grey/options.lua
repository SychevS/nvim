local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4
opt.expandtab = true
opt.cursorline = true
opt.termguicolors = false
opt.ignorecase = true

vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99   -- Открывать файлы с развернутым кодом (не сворачивать всё сразу)
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true -- Включить фолдинг
vim.opt.autochdir = true
