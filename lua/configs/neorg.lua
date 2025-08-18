require'plenary.filetype'.add_file('foo')
require("neorg").setup {
    load = {
        ["core.defaults"] = {}, -- Loads default behaviour
				["core.clipboard"] = {},
        ["core.export"] = {},
				['core.qol.toc'] = {},
				['core.promo'] = {},
				--['external.jupyter'] = {},
				['core.journal'] = {
					config = {
						journal_folder = 'journal',
						strategy = 'flat',
					}
				},
				['core.qol.todo_items'] = {
					config = {
						create_todo_items = true,
						create_todo_parents = true,
					}
				},
        ["core.export.markdown"] = {},
        --["core.integrations.telescope"] = {},
				--["core.tempus"] = {}, 
				--["core.ui"] = {},
				--["core.ui.calendar"] = {}, 
        ["core.concealer"] = {
            config = {
                folds = true,
            },
        }, -- Adds pretty icons to your documents
        ["core.keybinds"] = {
            config = {
                default_keybinds = true,
            },
        },
        ["core.esupports.metagen"] = {
            config = {
                type = "auto",
                template = {
                    {
                        "title",
                        function()
                            return vim.fn.expand "%:p:t:r"
                        end,
                    },
                    { "description", "" },
                    { "authors", "Luis Aldama" },
                    { "categories", "" },
                    {
                        "created",
                        function()
                            return os.date "%Y-%m-%d"
                        end,
                    },
                    {
                        "updated",
                        function()
                            return os.date "%Y-%m-%d"
                        end,
                    },
                },
            },
        },
        ["core.integrations.treesitter"] = {
            config = { configure_parsers = true, install_parsers = true },
        },
        ["core.summary"] = {

            config = {
                strategy = "metadata",
            },
        },
        ["core.completion"] = {
            config = { engine = "nvim-cmp", name = "[Neorg]" },
        }, --completion engine
        ["core.dirman"] = { -- Manages Neorg workspaces
            config = {
                workspaces = {
                    notes = "~/master/notes/neorg",
                },
            },
        },
    },
}
