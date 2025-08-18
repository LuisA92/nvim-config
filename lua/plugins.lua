return {
    -- colorschemes
    { "rose-pine/neovim" },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    -- {
    --     "nvim-focus/focus.nvim",
    --     version = "*",
    --     config = function()
    --         require("focus").setup()
    --     end,
    -- },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function()
            require "configs.treesitter"
        end,
    },

    { "nvim-treesitter/playground" },

    {
        "stevearc/oil.nvim",
        opts = {},
        dependencies = { { "echasnovski/mini.icons", opts = {} }, { "nvim-tree/nvim-web-devicons" } },
        config = function()
            require "configs.oil"
        end,
    },

    -- Directory Tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
            "MunifTanjim/nui.nvim",
            -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
        },

        config = function()
            require("neo-tree").setup()
        end,
    },
    -- Symbols
    {
        "stevearc/aerial.nvim",
        config = function()
            require "configs.aerial"
        end,
    },

    -- Buffer Line
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require "configs.bufferline"
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

    -- clipboard
    {
        "AckslD/nvim-neoclip.lua",
        dependencies = { "kkharji/sqlite.lua", module = "sqlite" },
        config = function()
            require("neoclip").setup()
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
        "bngarren/checkmate.nvim",
        ft = "markdown", -- Lazy loads for Markdown files matching patterns in 'files'
        opts = {
            todo_markers = {
                unchecked = "[ ]",
                checked = "[x]",
            },
        },
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

    {
        "WhoIsSethDaniel/toggle-lsp-diagnostics.nvim",
        config = function()
            require("toggle_lsp_diagnostics").init()
        end,
    },

    -- LSP
    {
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

    { "williamboman/mason.nvim" },
    { "williamboman/mason-lspconfig.nvim" },

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

    -- Telescope
    { "kiyoon/telescope-insert-path.nvim" },

    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        -- or                              , branch = '0.1.x',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "debugloop/telescope-undo.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        },

        config = function()
            require "configs.telescope"
        end,
    },

    { "nvim-telescope/telescope-media-files.nvim" },

    {
        "LuisA92/telescope-bibtex.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("telescope").load_extension "bibtex"
        end,
    },

    {
        "LuisA92/swenv.nvim",
        config = function()
            require "configs.swenv"
        end,
    },

    -- Markdown, LaTeX, and Notes

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
        "glepnir/template.nvim",
        config = function()
            require "configs.template"
        end,
    },

    { "dhruvasagar/vim-table-mode" },

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

    -- REPL

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

    {
        "famiu/bufdelete.nvim",
        lazy = false,
    },

    -- QOL
    {
        "max397574/better-escape.nvim",
        config = function()
            require "configs.betterescape"
        end,
    },

    { "tpope/vim-repeat" },

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
            require("neogen").setup {}
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
    -- {
    --     "roobert/surround-ui.nvim",
    --     dependencies = {
    --         "kylechui/nvim-surround",
    --         "folke/which-key.nvim",
    --     },
    --     config = function()
    --         require("surround-ui").setup {
    --             root_key = "S",
    --         }
    --     end,
    -- },
    {
        "windwp/nvim-autopairs",
        lazy = false,
        --event = "InsertEnter",
        config = function()
            require "configs.autopairs"
        end,
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

    -- Misc

    { "nvim-pack/nvim-spectre" }, -- search and replace

    { "nvim-lua/plenary.nvim" },

    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
    },

    { "junegunn/fzf" },

    { "junegunn/fzf.vim" },

    -- Folds
    {
        "kevinhwang91/nvim-ufo",
        dependencies = { "kevinhwang91/promise-async" },
        config = function()
            require "configs.nvim-ufo"
        end,
    },

    -- vim keys and vim reference
    {
        "shahshlok/vim-coach.nvim",
        dependencies = {
            "folke/snacks.nvim",
        },
        config = function()
            require("vim-coach").setup()
        end,
        keys = {
            { "<leader>?", "<cmd>VimCoach<cr>", desc = "Vim Coach" },
        },
    },

    -- UI
    { "stevearc/dressing.nvim" },

    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup {}
        end,
    },
}
