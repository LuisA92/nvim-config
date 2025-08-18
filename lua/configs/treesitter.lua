require("nvim-treesitter.configs").setup {
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
        enable = true,
        update_root = true,
    },
    ensure_installed = { "latex", "markdown", "markdown_inline", "query", "vimdoc", "vim" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = {
            --"latex",
            --"mermaid",
            --"lua",
            --"vim",
            --"markdown",
            --"tex",
            --"org",
            --"neorg",
            --"norg",
            --"tex",
        },
    },
    playground = {
        enable = true,
        disable = { "markdown" },
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
            toggle_query_editor = "9",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
        },
    },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    end,
})
