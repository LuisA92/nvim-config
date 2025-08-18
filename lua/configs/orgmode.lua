--require("orgmode").setup_ts_grammar()

require("orgmode").setup {
    org_agenda_files = { "~/Dropbox/agenda/**" },
    org_default_notes_file = "~/Dropbox/agenda/inbox.org",
    org_startup_folded = "showeverything",
    org_archive_location = "archive/%s_archive",
    org_highlight_latex_and_related = "entities",
    org_startup_indent = "noindent",
    win_split_mode = "auto",
    --win_split_mode = function(name)
    --local bufnr = vim.api.nvim_create_buf(false, true)
    ----- Setting buffer name is required
    --vim.api.nvim_buf_set_name(bufnr, name)
    --local fill = 0.8
    --local width = math.floor((vim.o.columns * fill))
    --local height = math.floor((vim.o.lines * fill))
    --local row = math.floor((((vim.o.lines - height) / 2) - 1))
    --local col = math.floor(((vim.o.columns - width) / 2))
    --vim.api.nvim_open_win(bufnr, true, {
    --relative = "editor",
    --width = width,
    --height = height,
    --row = row,
    --col = col,
    --style = "minimal",
    --border = "rounded",
    --})
    --end,
    mappings = {
        org = {
            org_toggle_checkbox = "<leader>o<leader>",
            org_set_tags_command = "<leader>ot",
            org_meta_return = "<leader>i",
        },
    },
    org_capture_templates = {
        t = {
            description = "Todo",
            template = "* TODO %?\n  %u",
            target = "~/Dropbox/agenda/inbox.org",
        },
        j = {
            description = "Journal",
            template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
            target = "~/Dropbox/agenda/monthly-%<%Y-%m>.org",
        },
    },
}

--require("org-bullets").setup()
