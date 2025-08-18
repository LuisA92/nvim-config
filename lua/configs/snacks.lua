local M = {}

M.opts = {
    bigfile = { enabled = false },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = false },
    picker = { enabled = true },
    notifier = { enabled = false },
    quickfile = { enabled = false },
    scope = { enabled = false },
    scroll = { enabled = false },
    scratch = { enabled = true },
    statuscolumn = { enabled = false },
    words = { enabled = true },
    image = {
        enabled = true,
        doc = { enabled = false },
        convert = {
            mermaid = function()
                return nil
            end,
        },
        math = {
            enabled = false,
        },
    },
}

M.keys = {
    {
        "<leader>.",
        function()
            Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
    },
    {
        "<leader>T.",
        function()
            local data = vim.fn.stdpath "data"

            local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
            if git_root == nil or git_root == "" then
                git_root = vim.fn.getcwd()
            end

            local project_name = vim.fn.fnamemodify(git_root, ":t")

            local branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]
            if branch == nil or branch == "" then
                branch = "default"
            end

            local root = string.format("%s/snacks/todo/%s/%s", data, project_name, branch)
            vim.fn.mkdir(root, "p")
            local file = root .. "/todo.md"

            ---@diagnostic disable-next-line: missing-fields
            Snacks.scratch.open {
                ft = "markdown",
                file = file,
            }
        end,
        desc = "Toggle Scratch Todo",
    },
    {
        "<leader>S",
        function()
            Snacks.scratch.select()
        end,
        desc = "Select Scratch Buffer",
    },
    {
        "<leader><space>",
        function()
            Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
    },
    {
        "<leader>,",
        function()
            Snacks.picker.buffers()
        end,
        desc = "Buffers",
    },
    {
        "<leader>/",
        function()
            Snacks.picker.grep()
        end,
        desc = "Grep",
    },
    {
        "<leader>:",
        function()
            Snacks.picker.command_history()
        end,
        desc = "Command History",
    },
    {
        "<leader>n",
        function()
            Snacks.picker.notifications()
        end,
        desc = "Notification History",
    },
    {
        "<leader>e",
        function()
            Snacks.explorer()
        end,
        desc = "File Explorer",
    },
}

return M
