return {
    {
        "morhetz/gruvbox",
        config = function()
            vim.cmd("colorscheme gruvbox")
        end
    },

    {
        "preservim/nerdtree",
        config = function()
            vim.g.NERDTreeMinimalUI = 1
            vim.g.NERDTreeWinSize = 30

            vim.keymap.set('n', '<F2>', ':NERDTreeToggle<CR>', { silent = true })
        end
    },

    {
        "derekwyatt/vim-fswitch",
        config = function()
            -- Настройки для C++ (ищет в текущей папке, в ../include и соседней /include)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "cpp", "c", "cc", "cxx" },
                callback = function()
                    -- Куда переключаться (расширения)
                    vim.b.fswitchdst = "h,hpp,hh,hxx"
                    -- Где искать (текущая папка, папка выше, папка include рядом)
                    vim.b.fswitchlocs = ".,../include,../inc,../../include,include"
                end
            })

            -- Настройки для заголовков (ищет в /src или текущей папке)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "h", "hpp", "hh" },
                callback = function()
                    vim.b.fswitchdst = "cpp,c,cc,cxx"
                    vim.b.fswitchlocs = ".,../src,../../src,src"
                end
            })

            vim.keymap.set('n', '<C-h>', ':FSHere<CR>', { silent = true, desc = "Switch Source/Header" })
        end
    },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true -- эквивалентно require("nvim-autopairs").setup({})
    },

    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    icons_enabled = false,      -- отключает иконки
                    theme = 'auto', -- подстроится под вашу тему оформления
                    component_separators = '|', -- простые разделители
                    section_separators = '',    -- убирает треугольники
                }
            })
        end
    },

    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = { 
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },
        config = function()
            local builtin = require('telescope.builtin')
            -- Основные горячие клавиши
            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Поиск файлов' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Поиск текста по всему проекту' }) -- need rg
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Список открытых табов' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Поиск по справке Neovim' })
        end
    },

    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        opts = { options = { "buffers", "curdir", "tabpages", "winsize" } },
        -- Горячие клавиши для восстановления
        keys = {
            { "<F9>", function() require("persistence").load() end, desc = "Restore Session" },
        },
    },

    {
        'mhinz/vim-startify',
        config = function()
        -- Пример настройки через Lua
        vim.g.startify_lists = {
            { type = 'files',     header = {'   Recent Files'} },
            { type = 'dir',       header = {'   Current Directory ' .. vim.fn.getcwd()} },
            { type = 'sessions',  header = {'   Sessions'} },
            { type = 'bookmarks', header = {'   Bookmarks'} },
        }
        end
    },
    
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    }
}
