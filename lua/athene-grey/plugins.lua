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
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "cpp", "c", "cc", "cxx" },
                callback = function()
                    vim.b.fswitchdst = "h,hpp,hh,hxx"
                    vim.b.fswitchlocs = ".,../include,../inc,../../include,include"
                end
            })

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
        config = true
    },

    {
        'nvim-lualine/lualine.nvim',
        config = function()
            require('lualine').setup({
                options = {
                    icons_enabled = false,
                    theme = 'auto',
                    component_separators = '|',
                    section_separators = '',
                }
            })
        end
    },

    {
        "iruzo/ripgrep.nvim",
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
        keys = {
            { "<leader>0", function() require("persistence").load() end, desc = "Restore Session" },
        },
    },

    {
        'mhinz/vim-startify',
        config = function()
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
        dependencies = {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
        config = function()
            require("mason").setup()
        end,
    },

    {
        "jay-babu/mason-null-ls.nvim",
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = { "clang_format", "black" },
                automatic_setup = true,
                handlers = {}
            })
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = { "clangd", "pyright" },
        },
    },

    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.clang_format,
                    null_ls.builtins.formatting.black,
                },
            })
        end
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local cmp_nvim_lsp = require("cmp_nvim_lsp")
            local capabilities = cmp_nvim_lsp.default_capabilities()

            local on_attach = function(client, bufnr)
                local keymap = vim.keymap

                -- Keybind options.
                local opts = { silent = true, buffer = bufnr }

                -- Set keymaps.

                opts.desc = "Go to definition."
                keymap.set("n", "<F12>", vim.lsp.buf.definition, opts)
            end

            vim.diagnostic.config({ virtual_text = true })

            vim.lsp.config("*", {
                capabilities = capabilities,
                on_attach = on_attach,
            })

            vim.lsp.config("clangd", {
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=never",
                    "--log=info",
                    "--pretty",
                },
                init_options = {
                    fallbackFlags = {
                        "-std=c++20",
                    }
                },
            })
        end,
    }
}
