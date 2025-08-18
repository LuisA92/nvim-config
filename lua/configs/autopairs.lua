require("nvim-autopairs").setup {
    ignored_next_char = [=[[%w%%%'%[%(%{%"%.%`%$]]=],
    map_cr = true,
}

--functions to apply autopairs to
local function apply_autopairs(item)
    local allowed_functions = {
        "emph",
        "usepackage",
        "cite",
        "section",
        "ref",
        "subsubsection",
        "chapter",
        "subsection",
        "subsubsection",
        "textit",
    }

    for _, func_name in ipairs(allowed_functions) do
        if item.label == func_name then
            return true
        end
    end

    return false
end
