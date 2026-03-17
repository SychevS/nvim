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
vim.opt.splitright = true

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    vim.cmd("silent! lcd %:p:h")
  end
})
