-- Custom predicate to check if we're in a markdown cell
local function is_in_markdown_cell()
    return function(match, pattern, bufnr, predicate)
        local node = match[predicate[2]]
        if not node then
            return false
        end

        local row = node:start()
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, row + 1, false)

        local in_markdown = false
        for i = #lines, 1, -1 do
            local line = lines[i]
            if line:match "^# %%%% %[markdown%]" then
                in_markdown = true
                break
            elseif line:match "^# %%%%" then
                in_markdown = false
                break
            end
        end

        return in_markdown
    end
end

-- Register the custom predicate
vim.treesitter.query.add_predicate("lua-match?", is_in_markdown_cell(), true)
