local M = {}

M.opts = {
    keymap = {
        preset = "default",
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<Cr>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-s>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    },

    snippets = { preset = "luasnip" },

    appearance = {
        nerd_font_variant = "mono",
    },

    completion = {
        documentation = {
            auto_show = false,
            window = { border = "single" },
        },
        list = {
            selection = { preselect = false },
        },
    },

    sources = {
        default = { "lsp", "path", "snippets", "buffer", "cmdline" },
        providers = {
            path = {
                min_keyword_length = 0,
                opts = {
                    trailing_slash = true,
                },
            },
        },
        per_filetype = {
            markdown = { "lsp", "buffer", "path", "snippets" },
        },
    },

    cmdline = {
        keymap = {
            ["<CR>"] = { "accept", "fallback" },
            ["<Tab>"] = { "show", "select_next" },
            ["<S-Tab>"] = { "show", "select_prev" },
            ["<C-k>"] = { "select_prev", "fallback" },
            ["<C-j>"] = { "select_next", "fallback" },
        },
        sources = function()
            local type = vim.fn.getcmdtype()
            if type == "/" or type == "?" then
                return { "buffer" }
            end
            if type == ":" or type == "@" then
                return { "cmdline" }
            end
            return {}
        end,
        completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false } },
        },
    },

    fuzzy = {
        implementation = "prefer_rust_with_warning",
        -- You can define custom sorts here if needed
        -- sorts = {
        --   "score",
        --   "sort_text",
        -- },
    },
}

return M
