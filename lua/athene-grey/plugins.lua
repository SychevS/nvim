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
                    path = 2,
                }
            })
        end
    },

    {
        "iruzo/ripgrep.nvim",
    },

    {
        'nvim-telescope/telescope.nvim',
        branch = 'master',
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
            { "<leader>0", function() require("persistence").load({last = true}) end, desc = "Restore Session" },
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
                ensure_installed = {
                    "clang_format",
                    "black",
                    "stylua"
                },
                automatic_setup = true,
                handlers = {}
            })
        end
    },

    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
                "clangd",
                "pyright",
                "lua_ls"
            },
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
                    null_ls.builtins.formatting.stylua,
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

                opts.desc = "Show LSP references."
                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

                opts.desc = "Go to definition in new tab."
                vim.keymap.set("n", "gt", "<cmd>tab split | lua vim.lsp.buf.definition()<CR>", opts)

                opts.desc = "Go to definition in vertical split."
                vim.keymap.set("n", "gv", "<cmd>vsplit | lua vim.lsp.buf.definition()<CR>", opts)

                opts.desc = "Go to definition."
                keymap.set("n", "<F12>", vim.lsp.buf.definition, opts)

                opts.desc = "Restart LSP."
                keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
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
                    -- "--compile-commands-dir=",
                },
                init_options = {
                    fallbackFlags = {
                        "-std=c++20",
                    }
                },
            })

            local pyright_options = {
                capabilities = capabilities,
                on_attach = on_attach,

                settings = {
                    python = {
                        analysis = {
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            diagnosticMode = "openFilesOnly",
                            useLibraryCodeForTypes = true,

                            diagnosticSeverityOverrides = {
                                analyzeUnannotatedFunctions = true,

                                enableTypeIgnoreComments = true,

                                strictDictionaryInference = true,
                                strictListInference = true,
                                strictParameterNoneValue = true,
                                strictSetInference = true,

                                reportAssertAlwaysTrue = "warning",
                                reportCallInDefaultInitializer = "none",
                                reportConstantRedefinition = "warning",
                                reportDeprecated = "warning",
                                reportDuplicateImport = "error",
                                reportFunctionMemberAccess = "error",
                                reportImplicitOverride = "none",
                                reportImplicitStringConcatenation = "none",
                                reportImportCycles = "warning",
                                reportIncompatibleMethodOverride = "error",
                                reportIncompatibleVariableOverride = "error",
                                reportIncompleteStub = "none",
                                reportInconsistentConstructor = "error",
                                reportInvalidStringEscapeSequence = "error",
                                reportInvalidStubStatement = "none",
                                reportInvalidTypeVarUse = "error",
                                reportMatchNotExhaustive = "error",
                                reportMissingImports = "error",
                                reportMissingModuleSource = "error",
                                reportMissingSuperCall = "none",
                                reportMissingTypeArgument = "none",
                                reportMissingTypeStubs = "none",
                                reportOptionalCall = "error",
                                reportOptionalContextManager = "error",
                                reportOptionalIterable = "error",
                                reportOptionalMemberAccess = "error",
                                reportOptionalOperand = "error",
                                reportOptionalSubscript = "error",
                                reportOverlappingOverload = "error",
                                reportPrivateImportUsage = "none",
                                reportPrivateUsage = "none",
                                reportPropertyTypeMismatch = "warning",
                                reportSelfClsParameterName = "error",
                                reportShadowedImports = "warning",
                                reportTypeCommentUsage = "error",
                                reportTypedDictNotRequiredAccess = "error",
                                reportUnboundVariable = "error",
                                reportUndefinedVariable = "error",
                                reportUnknownArgumentType = "none",
                                reportUnknownLambdaType = "none",
                                reportUnknownMemberType = "none",
                                reportUnknownParameterType = "none",
                                reportUnknownVariableType = "none",
                                reportUnnecessaryCast = "warning",
                                reportUnnecessaryComparison = "none",
                                reportUnnecessaryContains = "warning",
                                reportUnnecessaryIsInstance = "none",
                                reportUnsupportedDunderAll = "warning",
                                reportUntypedBaseClass = "warning",
                                reportUntypedClassDecorator = "none",
                                reportUntypedFunctionDecorator = "none",
                                reportUntypedNamedTuple = "none",
                                reportUnusedClass = "error",
                                reportUnusedCoroutine = "error",
                                reportUnusedExpression = "error",
                                reportUnusedFunction = "error",
                                reportUnusedImport = "error",
                                reportUnusedVariable = "error",
                                reportWildcardImportFromLibrary = "error",
                            },
                        },
                    },
                },
            }

            vim.lsp.config("pyright", pyright_options)

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                on_attach = on_attach,

                settings = {
                    Lua = {
                        -- Make the language server recognize "vim" and "os" globals.
                        diagnostics = {
                            globals = {
                                "vim",
                                "os",
                            },
                        },
                        workspace = {
                            -- Make language server aware of runtime files.
                            library = { vim.env.VIMRUNTIME },
                        },
                    },
                },
            })
        end,
    },

    {
        -- Completion plugin.
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            -- Source for text in buffer.
            "hrsh7th/cmp-buffer", -- source for text in buffer
            -- Source for file system paths.
            "hrsh7th/cmp-path",
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    -- Previous suggestion.
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    -- Next suggestion.
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    -- Show completion suggestions.
                    ["<C-Space>"] = cmp.mapping.complete(),
                    -- Close completion window.
                    ["<C-e>"] = cmp.mapping.abort(),

                    -- Scroll.
                    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-j>"] = cmp.mapping.scroll_docs(4),

                    -- Confirm by enter or tab.
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                }),
                -- Sources for autocompletion.
                sources = cmp.config.sources({
                    -- LSP.
                    { name = "nvim_lsp" },
                    -- Text within current buffer.
                    { name = "buffer" },
                    -- File system paths.
                    { name = "path" },
                }),
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate", -- Автоматически обновляет парсеры при обновлении плагина
        config = function()
            local treesitter = require("nvim-treesitter")

            treesitter.setup({
                parser_install_dir = "~/.local/share/nvim/site",

                ensure_installed = {
                    "c",
                    "cpp",

                    "python",

                    "go",
                    "gosum",
                    "gomod",

                    "rust",

                    "lua",

                    "java",
                    "kotlin",

                    "proto",

                    "bash",

                    "json",
                    "yaml",

                    "latex",
                    "markdown",
                    "markdown_inline",

                    "vim",
                    "dockerfile",
                    "gitignore",

                    "javascript",
                    "typescript",
                    "tsx",
                    "html",
                    "css",
                    "prisma",
                    "svelte",
                    "graphql",
                    "query",
                },
                auto_install = true,
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },

    {
        "yetone/avante.nvim",
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            -- add any opts here
            -- this file can contain specific instructions for your project
            -- instructions_file = "avante.md",
            providers = {
                openai = {
                    __inherited_from = "openai",
                    api_key_name = "cmd:cat ~/.config/eliza_api_key",
                    endpoint = "https://api.eliza.yandex.net/openai/v1",
                    model = "gpt-5.4",
                },
                anthropic = {
                    __inherited_from = "openai",
                    api_key_name = "cmd:cat ~/.config/eliza_api_key",
                    endpoint = "https://api.eliza.yandex.net/anthropic/v1",
                    model = "claude-sonnet-4-6",
                },
            },
            provider = "anthropic",
            input = {
                provider = "native"
            }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },


}
