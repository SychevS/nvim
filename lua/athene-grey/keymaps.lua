local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

vim.g.mapleader = " "

vim.keymap.set('n', '<F3>', ':tabprev<CR>', opts)
vim.keymap.set('n', '<F4>', ':tabnext<CR>', opts)
vim.keymap.set('n', '<F5>', ':tabnew<CR>', opts)
vim.keymap.set('n', '<F6>', ':set hlsearch! hlsearch?<CR>', opts)
vim.keymap.set('n', '<F7>', ':%s/<C-r>"//gc<left><left><left>', opts)
vim.keymap.set('n', '<F10>', ':wa<CR>:qall<CR>', opts)
