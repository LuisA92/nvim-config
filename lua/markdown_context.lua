-- Function to check if a comment is in a markdown cell
local function check_markdown_context(match, pattern, bufnr, predicate)
    local node = match[1] -- Get the comment node
    if not node then
        return false
    end

    local row = node:start()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, row, false)

    -- Look backwards for the most recent cell marker
    for i = #lines, 1, -1 do
        local line = lines[i]
        if line:match "^# %%%% %[markdown%]" then
            return true -- Found markdown cell marker
        elseif line:match "^# %%%%" then
            return false -- Found different cell type
        end
    end

    return false -- No cell marker found
end

-- Register the predicate
vim.treesitter.query.add_predicate("check_markdown_context", check_markdown_context, true)

return {}
