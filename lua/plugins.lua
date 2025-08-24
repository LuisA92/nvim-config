return {
    -- colorschemes
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function()
            require "configs.treesitter"
        end,
    },

    {
        "nvim-treesitter/playground",
    },

    -- I/O
    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = {
            { "echasnovski/mini.icons", opts = {} },
            { "nvim-tree/nvim-web-devicons" },
        },
        config = function()
            require "configs.oil"
        end,
    },

    -- Status line

    {
        "nvim-lualine/lualine.nvim",
        lazy = false,
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require "configs.lualine"
        end,
    },
    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require "configs.toggleterm"
        end,
    },

    -- Workspace and sessions
    {
        "natecraddock/sessions.nvim",
        config = function()
            require("sessions").setup()
        end,
    },

    {
        "natecraddock/Workspaces.nvim",
        config = function()
            require "configs.workspaces"
        end,
    },

    -- Motion
    {
        "folke/flash.nvim",
        --event = "VeryLazy",
        lazy = false,
        config = function()
            require("configs.flash").setup()
        end,
    },

    -- LSP

    {
        --to install LSPs
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        -- Autocompletion
        "saghen/blink.cmp",
        version = "1.*",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "fang2hou/blink-copilot",
        },

        event = "InsertEnter",
        opts = function()
            return require("configs.blink").opts
        end,
        opts_extend = { "sources.default" },
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp" },
        opts = function()
            return require("configs.nvim-lspconfig").opts
        end,
        config = function(_, opts)
            require("configs.nvim-lspconfig").setup(opts)
        end,
    },

    {
        "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
        config = function()
            require("toggle_lsp_diagnostics").init()
        end,
    },

    -- Formatter

    {
        "stevearc/conform.nvim",
        opts = {},
        config = function()
            require "configs.conform"
        end,
    },

    -- Snippets
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*",
        build = "make install_jsregexp",
        config = function()
            require "configs.luasnip"
        end,
    },

    -- Misc
    {
        "LuisA92/swenv.nvim",
        config = function()
            require "configs.swenv"
        end,
    },

    -- Markdown, LaTeX, Jupyter, Notes
    {
        "LuisA92/peek.nvim",
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
        config = function()
            require("peek").setup()
            vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
            vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
        end,
    },

    {
        "lervag/wiki.vim",
        lazy = false,
        config = function()
            require "configs.wikivim"
        end,
    },

    {
        "dhruvasagar/vim-table-mode",
    },

    {
        "lervag/vimtex",
        lazy = false,
        config = function()
            require "configs.vimtex"
        end,
    },

    {
        "jakewvincent/mkdnflow.nvim",
        config = function()
            require "configs.mkdnflow"
        end,
    },

    {
        "MeanderingProgrammer/markdown.nvim",
        main = "render-markdown",
        opts = {},
        name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
        dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" },
        config = function()
            require "configs.markdown"
        end,
    },

    {
        "zk-org/zk-nvim",
        config = function()
            require "configs.zk-nvim"
        end,
    },

    {
        "dkarter/bullets.vim",
        config = function()
            require "configs.bullets"
        end,
    },

    {
        "GCBallesteros/jupytext.nvim",
        config = true,
        opts = {
            custom_language_formatting = {
                python = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
                r = {
                    extension = "qmd",
                    style = "quarto",
                    force_ft = "quarto",
                },
            },
        },
    },

    {
        "GCBallesteros/NotebookNavigator.nvim",
        dependencies = {
            "echasnovski/mini.comment",
            "Vigemus/iron.nvim",
        },
        event = "VeryLazy",
        keys = function()
            return require("configs.notebook-navigator").keys
        end,
        config = function()
            require("configs.notebook-navigator").setup()
        end,
    },

    -- REPL to run python

    {
        "Vigemus/iron.nvim",
        config = function()
            require "configs.iron"
        end,
    },

    -- Window management
    {
        "mrjones2014/smart-splits.nvim",
        config = function()
            require "configs.smart-splits"
        end,
    },

    -- Slight quality of life improvmenets
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = function()
            return require("configs.snacks").opts
        end,
        keys = function()
            return require("configs.snacks").keys
        end,
    },

    {
        "max397574/better-escape.nvim",
        config = function()
            require "configs.betterescape"
        end,
    },

    {
        "tpope/vim-repeat",
    },

    -- Programming

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("todo-comments").setup()
        end,
    },

    {
        "danymat/neogen",
        config = function()
            require("neogen").setup {

                enabled = true,
                languages = {
                    python = {
                        template = {
                            annotation_convention = "google_docstrings", -- or "numpy", "reST"
                        },
                    },
                },
            }
        end,
    },

    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup {

                keymaps = {
                    insert = "<C-g>s",
                },
            }
        end,
    },

    {
        "windwp/nvim-autopairs",
        lazy = false,
        --event = "InsertEnter",
        config = function()
            require "configs.autopairs"
        end,
    },

    {
        "stevearc/aerial.nvim",
        config = function()
            require "configs.aerial"
        end,
    },

    -- Misc

    {
        "nvim-pack/nvim-spectre",
    },

    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                override_vim_notify = true,
            },
        },
    },

    {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
            dir_path = "/Users/luis/master/notes/attachments/",
            use_absolute_path = true,
        },
        keys = {
            -- suggested keymap
            --{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
        },
    },
}
-- %%
