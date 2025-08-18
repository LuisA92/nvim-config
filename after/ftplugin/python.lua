-- Jupytext markdown comment continuation
local function is_in_markdown_cell()
    local lines = vim.api.nvim_buf_get_lines(0, 0, vim.api.nvim_win_get_cursor(0)[1], false)

    -- Look backwards for the most recent cell marker
    for i = #lines, 1, -1 do
        local line = lines[i]
        if line:match "^# %%%% %[markdown%]" then
            return true
        elseif line:match "^# %%%%" then
            return false -- Found a different cell type
        end
    end

    return false
end

local function continue_markdown_comment()
    local line = vim.api.nvim_get_current_line()

    -- Only work in markdown cells and on comment lines
    if not is_in_markdown_cell() or not line:match "^# " then
        return "<CR>"
    end

    -- Check if it's just "# " (empty markdown comment)
    if line:match "^# %s*$" then
        -- Return keystrokes to delete the "# " and create normal line
        return "<C-u><CR>"
    else
        -- Continue with new markdown comment line
        return "<CR># "
    end
end

-- Map Enter key in insert mode for Python files
vim.keymap.set("i", "<CR>", continue_markdown_comment, {
    buffer = true,
    expr = true,
    desc = "Continue markdown comments in jupytext cells",
})
